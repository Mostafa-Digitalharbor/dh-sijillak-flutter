import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../../customer/domain/usecases/get_customer_use_case.dart';
import '../../../quote/domain/usecases/create_quote_for_deal_use_case.dart';
import '../../domain/entities/deal_stage.dart';
import '../../domain/entities/lead_defaults.dart';
import '../../domain/entities/lead_party.dart';
import '../../domain/entities/new_deal.dart';
import '../../domain/usecases/create_deal_use_case.dart';
import '../../domain/usecases/get_lead_defaults_use_case.dart';
import '../extensions/lead_input_parser.dart';

/// State of the new-deal form: the chosen stage, the pre-filled customer and
/// owner, and the progress of loading them and of saving.
class NewLeadState extends Equatable {
  const NewLeadState({
    this.stage = DealStage.qualified,
    this.status = ViewStatus.initial,
    this.defaults,
    this.customer,
    this.failure,
    this.submitStatus = ViewStatus.initial,
    this.submitFailure,
    this.createQuote = false,
    this.quoteNumber,
  });

  final DealStage stage;

  /// Load status of [defaults].
  final ViewStatus status;
  final LeadDefaults? defaults;

  /// The customer the deal is for: the pre-filled one until the user picks
  /// another.
  final LeadParty? customer;
  final Failure? failure;

  final ViewStatus submitStatus;
  final Failure? submitFailure;

  /// Whether the save in flight (or just done) continues to a new quote.
  final bool createQuote;

  /// Number of the quote created for the saved deal, once it exists.
  final int? quoteNumber;

  bool get canSubmit =>
      defaults != null && customer != null && !submitStatus.isLoading;

  NewLeadState copyWith({
    DealStage? stage,
    ViewStatus? status,
    LeadDefaults? defaults,
    LeadParty? customer,
    Failure? failure,
    ViewStatus? submitStatus,
    Failure? submitFailure,
    bool? createQuote,
    int? quoteNumber,
  }) => NewLeadState(
    stage: stage ?? this.stage,
    status: status ?? this.status,
    defaults: defaults ?? this.defaults,
    customer: customer ?? this.customer,
    failure: failure,
    submitStatus: submitStatus ?? this.submitStatus,
    submitFailure: submitFailure,
    createQuote: createQuote ?? this.createQuote,
    quoteNumber: quoteNumber ?? this.quoteNumber,
  );

  @override
  List<Object?> get props => [
    stage,
    status,
    defaults,
    customer,
    failure,
    submitStatus,
    submitFailure,
    createQuote,
    quoteNumber,
  ];
}

/// Drives the new-deal form. It owns the text controllers of the fields so
/// the values survive rebuilds and can be read when saving.
class NewLeadCubit extends Cubit<NewLeadState> {
  NewLeadCubit(
    this._getDefaults,
    this._createDeal,
    this._createQuote,
    this._getCustomer,
  ) : super(const NewLeadState());

  /// A new lead can start at any stage except the won one.
  static const selectableStages = [
    DealStage.newLead,
    DealStage.qualified,
    DealStage.quote,
    DealStage.negotiation,
  ];

  final GetLeadDefaultsUseCase _getDefaults;
  final CreateDealUseCase _createDeal;
  final CreateQuoteForDealUseCase _createQuote;
  final GetCustomerUseCase _getCustomer;

  String? _customerId;

  final titleController = TextEditingController();
  final valueController = TextEditingController();
  final expectedCloseController = TextEditingController();
  final notesController = TextEditingController();

  /// Loads the form's defaults. With [customerId] the deal starts for that
  /// customer instead of the default one; without an argument the last
  /// [customerId] is kept (used by the retry button).
  Future<void> load([String? customerId]) async {
    _customerId = customerId ?? _customerId;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getDefaults(const NoParams());
    if (isClosed) return;
    final defaults = result.dataOrNull;
    if (defaults == null) {
      emit(
        state.copyWith(
          status: ViewStatus.failure,
          failure: result.failureOrNull,
        ),
      );
      return;
    }
    final preselected = _customerId;
    if (preselected == null) {
      emit(
        state.copyWith(
          status: ViewStatus.success,
          defaults: defaults,
          customer: state.customer ?? defaults.customer,
        ),
      );
      return;
    }
    final customer = await _getCustomer(preselected);
    if (isClosed) return;
    emit(
      customer.when(
        success: (customer) => state.copyWith(
          status: ViewStatus.success,
          defaults: defaults,
          customer: LeadParty(
            id: customer.id,
            name: customer.name,
            subtitle: customer.location.isEmpty ? null : customer.location,
          ),
        ),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  /// Makes the deal belong to [customer].
  void selectCustomer(LeadParty customer) =>
      emit(state.copyWith(customer: customer));

  void selectStage(DealStage stage) => emit(state.copyWith(stage: stage));

  /// Saves the deal typed into the form. [expectedClose] is the date parsed
  /// from [expectedCloseController] (parsing needs the locale's month names,
  /// so the view does it). Observe [NewLeadState.submitStatus] for the result.
  Future<void> submit({
    required DateTime? expectedClose,
    required bool createQuote,
  }) async {
    final defaults = state.defaults;
    final customer = state.customer;
    if (defaults == null || customer == null || state.submitStatus.isLoading) {
      return;
    }
    emit(
      state.copyWith(
        submitStatus: ViewStatus.loading,
        createQuote: createQuote,
      ),
    );
    final notes = notesController.text.trim();
    final result = await _createDeal(
      NewDeal(
        title: titleController.text.trim(),
        customerId: customer.id,
        ownerId: defaults.owner.id,
        value: LeadInputParser.amount(valueController.text) ?? 0,
        stage: state.stage,
        expectedClose: expectedClose,
        notes: notes.isEmpty ? null : notes,
      ),
    );
    if (isClosed) return;
    final deal = result.dataOrNull;
    if (deal == null) {
      emit(_failed(result.failureOrNull!));
      return;
    }
    if (!createQuote) {
      emit(state.copyWith(submitStatus: ViewStatus.success));
      return;
    }
    final quote = await _createQuote(deal.id);
    if (isClosed) return;
    emit(
      quote.when(
        success: (quote) => state.copyWith(
          submitStatus: ViewStatus.success,
          quoteNumber: quote.number,
        ),
        error: _failed,
      ),
    );
  }

  NewLeadState _failed(Failure failure) =>
      state.copyWith(submitStatus: ViewStatus.failure, submitFailure: failure);

  @override
  Future<void> close() {
    titleController.dispose();
    valueController.dispose();
    expectedCloseController.dispose();
    notesController.dispose();
    return super.close();
  }
}
