/// * All purposes generic state class
class GenericState<T> {
  final Status _status;
  final T? _data;
  final String? error;

  // * Constructors for the different status one for each `Status` enum value.

  /// Initial State Constructor
  GenericState.initial([T? initialData])
      : _status = Status.initial,
        _data = initialData,
        error = null;

  /// Success State Constructor
  GenericState.success(T data)
      : _status = Status.success,
        _data = data,
        error = null;

  /// Fail State Constructor
  GenericState.fail([this.error])
      : _status = Status.fail,
        _data = null;

  /// Loading State Constructor
  GenericState.loading()
      : _status = Status.loading,
        _data = null,
        error = null;

  /// Gets GenericState `Status`
  Status get status => _status;

  /// Checks `state` is success or not
  bool get isSuccess => _status == Status.success;

  /// Checks `state` is loading or not, useful to show loading indicators
  bool get isLoading => _status == Status.loading;

  /// Checks `state` is failed or not, useful to show error messages
  bool get isFailed => _status == Status.fail;

  /// Gets the state data directly, if the `status` is not a `success` it returns null.
  /// so you call this only when your are sure that the state is success or provide a onDataAbsence callback that returns a default value of you data.
  T? getData({
    T? Function()? onDataAbsence,
  }) =>
      isSuccess ? _data : onDataAbsence?.call();

  /// Gets the error message of the fail state
  String? getError() => isFailed ? error : null;

  /// All cases are required except `initial` (optional), which allows returning a non-nullable value.
  /// if initial is not provider ([loading] callback is used by default).
  /// Usually this is used with UI with a `Widget` return type.
  R when<R>({
    R Function(T? data)? initial,
    required R Function(T data) data,
    required R Function() loading,
    required R Function(String error) error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial != null ? initial(_data) : loading();
      case Status.success:
        return data(_data as T);
      case Status.fail:
        return error(
          this.error ?? "errors_something_went_wrong",
        );
      case Status.loading:
        return loading();
    }
  }
}

/// * Use this enum directly if you have a simple use case (state) of different status without data.
enum Status {
  initial,
  success,
  fail,
  loading;

  /// Returns a type [R] for different status.
  /// used with simple state use cases that doesn't require data.
  R when<R>({
    R Function()? initial,
    required R Function() success,
    required R Function() fail,
    required R Function() loading,
  }) {
    switch (this) {
      case Status.initial:
        return initial != null ? initial() : loading();
      case Status.success:
        return success();
      case Status.fail:
        return fail();
      case Status.loading:
        return loading();
    }
  }
}
