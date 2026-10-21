import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/document_line.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/usecases/get_invoice_draft_use_case.dart';
import '../../domain/usecases/issue_invoice_use_case.dart';

class NewInvoiceState extends Equatable {
  const NewInvoiceState({
    this.status = ViewStatus.initial,
    this.failure,
    this.draft,
    this.submitStatus = ViewStatus.initial,
    this.submitFailure,
    this.issued,
  });

  /// Loading of the draft.
  final ViewStatus status;
  final Failure? failure;
  final InvoiceDraft? draft;

  /// Issuing of the invoice.
  final ViewStatus submitStatus;
  final Failure? submitFailure;

  /// The invoice created by a successful issue.
  final InvoiceDetail? issued;

  bool get isSubmitting => submitStatus.isLoading;

  NewInvoiceState withDraft(InvoiceDraft draft) => NewInvoiceState(
    status: status,
    failure: failure,
    draft: draft,
    submitStatus: submitStatus,
    submitFailure: submitFailure,
    issued: issued,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    draft,
    submitStatus,
    submitFailure,
    issued,
  ];
}

class NewInvoiceCubit extends Cubit<NewInvoiceState> {
  NewInvoiceCubit(this._getDraft, this._issueInvoice)
    : super(const NewInvoiceState());

  static const maxQuantity = 9999;

  final GetInvoiceDraftUseCase _getDraft;
  final IssueInvoiceUseCase _issueInvoice;

  int? _quoteNumber;

  /// Loads a fresh draft: the default one, or converted from the quote
  /// numbered [quoteNumber].
  Future<void> load({int? quoteNumber}) async {
    _quoteNumber = quoteNumber;
    emit(const NewInvoiceState(status: ViewStatus.loading));
    final result = await _getDraft(
      GetInvoiceDraftParams(quoteNumber: quoteNumber),
    );
    if (isClosed) return;
    result.when(
      success: (draft) =>
          emit(NewInvoiceState(status: ViewStatus.success, draft: draft)),
      error: (failure) =>
          emit(NewInvoiceState(status: ViewStatus.failure, failure: failure)),
    );
  }

  /// Loads the draft again after a failure, from the same source.
  Future<void> reload() => load(quoteNumber: _quoteNumber);

  /// Bills the draft to another customer, identified by name and tax number.
  void changeCustomer({required String name, required String vatNumber}) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.withDraft(draft.withCustomer(customer: name, vatNumber: vatNumber)),
    );
  }

  void changeQuantity(int index, int delta) {
    final draft = state.draft;
    if (draft == null) return;
    final lines = [...draft.lines];
    final quantity = (lines[index].quantity + delta).clamp(0, maxQuantity);
    lines[index] = lines[index].withQuantity(quantity);
    emit(state.withDraft(draft.withLines(lines)));
  }

  void addLine(DocumentLine line) {
    final draft = state.draft;
    if (draft == null) return;
    emit(state.withDraft(draft.withLines([...draft.lines, line])));
  }

  void removeLine(int index) {
    final draft = state.draft;
    if (draft == null) return;
    final lines = [...draft.lines]..removeAt(index);
    emit(state.withDraft(draft.withLines(lines)));
  }

  /// Issues the draft; on success [NewInvoiceState.issued] holds the invoice.
  Future<void> issue() async {
    final draft = state.draft;
    if (draft == null || state.isSubmitting) return;
    emit(
      NewInvoiceState(
        status: state.status,
        draft: draft,
        submitStatus: ViewStatus.loading,
      ),
    );
    final result = await _issueInvoice(draft);
    if (isClosed) return;
    result.when(
      success: (invoice) => emit(
        NewInvoiceState(
          status: state.status,
          draft: draft,
          submitStatus: ViewStatus.success,
          issued: invoice,
        ),
      ),
      error: (failure) => emit(
        NewInvoiceState(
          status: state.status,
          draft: draft,
          submitStatus: ViewStatus.failure,
          submitFailure: failure,
        ),
      ),
    );
  }
}
