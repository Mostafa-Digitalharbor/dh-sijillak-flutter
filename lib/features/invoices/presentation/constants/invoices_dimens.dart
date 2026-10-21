import 'package:flutter/painting.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the invoices flow (list, detail, new invoice,
/// payment sheet and confirmation).
abstract final class InvoicesDimens {
  /// Design top offset of the header (before the status-bar inset).
  static const double topPadding = 52;
  static const double listTopPadding = 56;
  static const double listBottomPadding = 120;
  static const double doneTopPadding = 100;
  static const double doneBottomPadding = 34;

  /// Space under the new-invoice list for its (tall) pinned total bar.
  static const double newInvoiceBarClearance = 170;

  // Invoices list
  static const double periodButtonHeight = 44;
  static const double periodIconSize = 18;
  static const double summaryTitleSize = 14;
  static const double summaryAmountSize = 24;
  static const double currencySize = 13;
  static const double rowCurrencySize = 11;
  static const double summaryBarHeight = 10;
  static const double summaryBarGap = 3;
  static const double legendDot = 8;
  static const double legendDotRadius = 2;
  static const double rowIconTile = 42;
  static const double rowIconSize = 20;

  // Invoice detail
  static const double qrSize = 76;
  static const double qrPadding = 4;
  static const double qrRadius = 8;
  static const double partyNameSize = 16;
  static const double actionHeight = 52;
  static const double actionRadius = 16;
  static const double actionFontSize = 16;

  /// Icon (20) + gap (8) inside the record-payment button.
  static const double primaryIconExtra = 28;

  /// Icon (20) + gap (8) + hairline borders (3) of the share button.
  static const double outlineIconExtra = 31;
  static const double pillFontSize = 13;
  static const pillPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  // New invoice
  static const double customerBadge = 44;
  static const double sectionTitleSize = 16;
  static const double stepperButton = 36;
  static const double stepperRadius = 11;
  static const double stepperGlyphSize = 20;
  static const double quantityMinWidth = 24;
  static const double quantitySize = 16;
  static const double addButtonHeight = 50;
  static const double addButtonRadius = 16;
  static const double addIconSize = 18;
  static const double addIconStroke = 2.2;
  static const double addLabelSize = 15;
  static const double draftLabelSize = 15;
  static const double draftExtraWidth = 3;
  static const int issueGrow = 2;

  // Add-product sheet and line removal
  static const double productTileMinHeight = 52;
  static const double productNameSize = 15;
  static const double removeIconSize = 18;
  static const double removeLabelSize = 13;
  static const double sectionGap = 18;

  // Payment sheet
  static const double sheetTitleSize = 22;
  static const double sheetSubtitleSize = 14;
  static const double fieldHeight = 48;
  static const double fieldFontSize = 15;
  static const double amountFieldHeight = 62;
  static const double amountFontSize = 26;
  static const double methodTileHeight = 64;
  static const double methodLabelSize = 13;
  static const double attachHeight = 48;
  static const double attachRadius = 14;
  static const double attachIconSize = 18;
  static const double attachLabelSize = 14;

  // Payment confirmation
  static const double checkCircle = 96;
  static const double checkIcon = 46;
  static const double checkIconStroke = 2.4;
  static const double checkRing = 12;
  static final checkShadow = [
    const BoxShadow(color: AppColors.white60, spreadRadius: checkRing),
    ...AppShadows.tinted(alpha: 0.3, blur: 34, dy: 16),
  ];
  static const double doneAmountSize = 36;
  static const double doneCurrencySize = 16;
  static const double noteIconSize = 20;
  static const double noteTextSize = 13;
  static const donePillPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 3,
  );

  // Screen backgrounds
  static const listBlobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 120,
      left: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 560,
      right: -80,
    ),
  ];

  static const detailBlobs = [
    BackgroundBlob(
      size: 320,
      color: AppColors.accent,
      opacity: 0.24,
      top: 20,
      left: -120,
    ),
    BackgroundBlob(
      size: 260,
      color: AppColors.primary,
      opacity: 0.14,
      top: 540,
      right: -90,
    ),
  ];

  static const newInvoiceBlobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 180,
      right: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 560,
      left: -80,
    ),
  ];

  static const doneBlobs = [
    BackgroundBlob(
      size: 360,
      color: AppColors.accent,
      opacity: 0.28,
      top: 30,
      left: 15,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 620,
      right: -80,
    ),
  ];
}
