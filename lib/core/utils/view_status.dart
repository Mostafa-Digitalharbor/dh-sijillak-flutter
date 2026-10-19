/// Lifecycle of a screen's data load, shared by every cubit state.
enum ViewStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == loading;
  bool get isFailure => this == failure;
  bool get isSuccess => this == success;
}
