/// Key under which every successful body carries its payload.
const envelopeDataKey = 'data';

/// The payload of a response body: `body['data']` for an envelope, the body
/// itself when it is not an envelope, null for an empty body.
Object? unwrapEnvelope(Object? body) {
  if (body is Map && body.containsKey(envelopeDataKey)) {
    return body[envelopeDataKey];
  }
  if (body is String && body.isEmpty) return null;
  return body;
}
