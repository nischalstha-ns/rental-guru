/// A generic result type representing either success or failure.
class Result<S, F> {
  final S? success;
  final F? failure;
  final bool isFailure;

  const Result._(this.success, this.failure, this.isFailure);

  const Result.success(S value)
      : success = value,
        failure = null,
        isFailure = false;

  const Result.failure(F value)
      : success = null,
        failure = value,
        isFailure = true;

  R fold<R>(R Function(F error) onFailure, R Function(S value) onSuccess) {
    if (isFailure) return onFailure(failure!);
    return onSuccess(success!);
  }

  S getSuccess() => success!;
  F getFailure() => failure!;
  bool get isSuccess => !isFailure;
}