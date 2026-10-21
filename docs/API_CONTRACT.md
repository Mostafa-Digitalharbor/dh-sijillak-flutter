# Sijilak mobile app - API contract

What the app calls today. It currently runs on an in-app mock that implements exactly these
endpoints (`assets/mock/**` holds sample responses); switching to the real backend is configuration
only (`env/*.json`: `API_BASE_URL`, `USE_MOCK_BACKEND=false`). Source of truth in code: the
`*_endpoints.dart`, `*_remote_data_source.dart` and `data/models/*` files of each feature.

## Conventions

| Topic | Assumption |
|---|---|
| Base URL | `API_BASE_URL` + `/v1` (e.g. `https://api.example.com/v1/auth/login`). JSON, UTF-8. |
| Success | `2xx` with body `{"data": <payload>}`. Payload is an object, an array, or `{}`. Writes that return nothing may answer `204`/empty. |
| Auth header | `Authorization: Bearer <accessToken>` on every request once signed in (sign-in/register/OTP/handle calls are sent without it). |
| Other headers | `Accept: application/json`, `Accept-Language: ar \| en` (user language, localise server messages), `X-App-Platform: android \| iOS \| ...`. |
| Tokens | Returned by sign-in/registration as `tokens: {accessToken, refreshToken, expiresAt}` (`expiresAt` ISO-8601, optional). |
| Refresh | On any `401` for a request that carried a token the app calls `POST /auth/refresh` once, then replays the request once. Refresh rejected (any 4xx) = user is signed out. Offline/5xx during refresh keeps the session. Concurrent 401s share one refresh. Refresh-token rotation is supported (new `refreshToken` in the answer replaces the old). |
| Errors | Non-2xx body: `{"error": {"code": "<machine_code>", "message": "<text>", "fields": {"<field>": "<code>"}}}`. Only the status is required. `fields` values may be a string or a list (first is used). |
| Status mapping | `401` unauthorized, `404` not found, `422` (or `400` with `fields`) validation error (`fields` = field -> code), other (`400`, `403`, `409`, `429`, `5xx`) server error carrying status + `error.code`. Timeouts / no connection = network error. |
| Types | Money: integers in SAR (no decimals). Dates: ISO-8601 strings. Ids: strings, except invoice/quote `number` (integer). Enum-like values: the exact strings listed below. Unknown extra fields are ignored. |
| Timeouts | connect 15 s, send 30 s, receive 30 s. |
| Mock-only behaviour | Mock codes: OTP `000000` is rejected (any other 6 digits verify); reserved handles `admin,test,sijillak,www,app` are taken. The real rules are the backend's. |

Enums: `DealStage` = `newLead | qualified | quote | negotiation | won`; `InvoiceStatus` = `paid | due | late`;
`InvoicePeriod` (query `period`) = `thisMonth | lastMonth | thisYear` (omitted = all time);
`QuoteStatus` = `sent | approved`; `PaymentMethod` = `bank_transfer | card | cash`;
`NotificationKind` = `quoteViewed | quoteApproved | invoiceOverdue | paymentReceived | taskReminder | dealWon`;
`HomeTaskKind` = `call | meeting`; `CustomerActivityKind` = `quoteSent | call | invoiceOverdue`;
registration `sector` = `trade | industry | services | contracting | other`;
registration `city` = `riyadh | jeddah | dammam | makkah | madinah`.

Reused shapes:

- **AuthSession**: `{user: {id, name, email}, workspace: {id, name, handle, url}, tokens: {accessToken, refreshToken, expiresAt?}}`
- **Tokens**: `{accessToken, refreshToken, expiresAt?}`
- **DocumentLine**: `{name, unitPrice, quantity}` (`quantity` defaults to 1)
- **Deal**: `{id, title, stage, customerId, customerName, value, probability(0-100), ownerId, ownerName, nextAction?: {title, at?, hasTime}, quoteExpiresAt?, expectedClose?, notes?}`

## Auth (public unless stated)

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /auth/handles/availability` | query `handle` | `{available: bool}` |
| `POST /auth/otp/request` | `{phone}` | `{}` |
| `POST /auth/otp/verify` | `{phone, code}` | `{}`; wrong code: `422` with `fields: {code: "invalid"}` |
| `POST /auth/workspaces` (register) | `{company: {name, sector, handle}, owner: {name, email, phone, password, termsAccepted}, tax: {commercialRegNo, vatNumber, city, postalCode, address, zatcaEnabled}, brand: {hasLogo}}` | AuthSession incl. tokens; taken handle: `422` `fields: {handle: "taken"}` |
| `POST /auth/login` | `{email, password}` | AuthSession incl. tokens; missing field: `422` `fields: {email\|password: "required"}`; wrong credentials: `401` |
| `POST /auth/refresh` | `{refreshToken}` | Tokens; invalid/used token: `401` |

Biometric sign-in has no endpoint of its own: after the device check the app calls `POST /auth/refresh`
with the refresh token stored in the keystore and resumes the remembered user/workspace.

## Home

| `GET /home/overview` | - | `{user: {id, name, firstName}, summary: {monthlySales, salesGrowthPercent, recentSales: [int], dueAmount, overdueInvoices, openDeals, expectedDealsValue}, tasks: [{id, kind, title, customerName, scheduledAt}]}` |
|---|---|---|

## Pipeline (deals)

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /deals` | - | `{stages: [{stage, count, totalValue}], deals: [Deal]}` |
| `GET /deals/lead-defaults` | - | `{customer: {id, name}, owner: {id, name}}` (preselected party of the new-lead form) |
| `POST /deals` | `{title, customerId, ownerId, value, stage, expectedClose?, notes?}` | Deal |

## Customers

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /customers` | optional query `q` (free text, name/VAT) | `[{id, name, location, openDeals, amountDue, vatNumber?}]` |
| `POST /customers` | `{name, phone, email, city, sector}` (city/sector free text) | Customer (below) |
| `GET /customers/{id}` | - | `{id, name, location, city, sector, phone, email, address, commercialRegistration, vatNumber, customerSince, accountOwner, totalSales, amountDue, openDeals, activity: [{id, kind, title, at, detail?, amount?}]}`; unknown id: `404` |
| `GET /customers/{id}/deals` | - | `[{id, title, stage, value, probability}]` |
| `GET /customers/{id}/invoices` | - | `[{number, date, amount, status}]` |

## Quotes

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /quotes/{number}` | - | Quote: `{number, customer, dealTitle, lines: [DocumentLine], dealId?, status, viewedAt?, validUntil?}`; unknown: `404` |
| `POST /quotes/{number}/approve` | none | Quote (status `approved`) |
| `POST /deals/{dealId}/quotes` | none | Quote created from the deal |

## Invoices and products

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /invoices` | optional query `status` (`paid\|due\|late`), `q` (text), `period` | `{overview: {paid, due, late}, invoices: [{customer, number, date, amount, status}]}` (overview = totals in SAR per status) |
| `GET /invoices/draft` | optional query `quote` (quote number to prefill from) | `{customer, vatNumber, issueDate, paymentTermsDays, lines: [DocumentLine]}` |
| `GET /products` | - | `[{id, name, unitPrice}]` |
| `POST /invoices` (issue) | `{customer, vatNumber, issueDate, paymentTermsDays, lines: [DocumentLine]}` | InvoiceDetail |
| `GET /invoices/{number}` | - | InvoiceDetail: `{number, customer, vatNumber, issueDate, dueDate, lines: [DocumentLine], status, payments: [{amount, method, date, reference?, hasReceipt}]}`; unknown: `404` |
| `POST /invoices/{number}/payments` | `{amount, method, date, reference?, hasReceipt}` | InvoiceDetail (with the new payment, status recomputed) |

VAT (15 %) is computed by the app from `lines`; the backend should compute and validate its own totals.

## Notifications

| Method + path | Request | Response `data` |
|---|---|---|
| `GET /notifications` | - | `[{id, kind, createdAt, isRead, customerName?, amount?, subject?, quoteNumber?, invoiceNumber?, customerId?, dealId?}]` |
| `GET /notifications/unread-count` | - | `{count}` |
| `POST /notifications/{id}/read` | none | the notification (same shape) |
| `POST /notifications/read-all` | none | `{}` |

## Search

| `GET /search` | query `q` | `{customers: [{id, name, location, openDeals}], deals: [{id, title, stage, value, customerId, customerName}], invoices: [{number, customer, amount, status}], quotes: [{number, customer, dealTitle, status}]}` (missing group = empty) |
|---|---|---|

## Not covered yet (no backend call in the app)

Forgot password, logo upload, sign-out (local only: the app discards tokens; add `POST /auth/logout`
to revoke the refresh token if wanted), profile editing, push-token registration.
