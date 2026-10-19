/// Funnel stage of a deal, in pipeline order.
enum DealStage {
  newLead,
  qualified,
  quote,
  negotiation,
  won;

  /// Deals in these stages still count towards the open pipeline.
  bool get isOpen => this != won;
}
