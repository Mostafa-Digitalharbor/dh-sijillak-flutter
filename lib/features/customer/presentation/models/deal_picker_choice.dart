import '../../domain/entities/customer_deal.dart';

/// What the user picked in the deal picker sheet.
sealed class DealPickerChoice {
  const DealPickerChoice();
}

/// One of the customer's open deals.
class ExistingDealChoice extends DealPickerChoice {
  const ExistingDealChoice(this.deal);

  final CustomerDeal deal;
}

/// The "new deal" entry.
class NewDealChoice extends DealPickerChoice {
  const NewDealChoice();
}
