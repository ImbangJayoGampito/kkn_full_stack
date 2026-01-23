abstract class Result<T, E> {}

class Ok<T, E> extends Result<T, E> {
  final T value;
  Ok(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E error;
  Err(this.error);
}

class StatusCode {
  final int code;

  const StatusCode({required this.code});

  static const unauthorized = StatusCode(code: 401);
  static const notFound = StatusCode(code: 404);
  static const internalServerError = StatusCode(code: 500);
  static const badRequest = StatusCode(code: 400);
  static const forbidden = StatusCode(code: 403);
  static const methodNotAllowed = StatusCode(code: 405);
  static const notAcceptable = StatusCode(code: 406);
  static const conflict = StatusCode(code: 409);
  static const preconditionFailed = StatusCode(code: 412);
  static const preconditionRequired = StatusCode(code: 428);

  Result<T, E> processStatus<T, E>({
    required Object json,
    required T Function(Object json) onSuccess,
  }) {
    if (code >= 200 && code < 300) {
      return Ok<T, E>(onSuccess(json));
    }

    String errorMessages = '';
    switch (code) {
      case 400:
        errorMessages = 'Bad Request';
        break;
      case 401:
        errorMessages = 'Unauthorized';
        break;
      case 403:
        errorMessages = 'Forbidden';
        break;
      case 404:
        errorMessages = 'Not Found';
        break;
      case 405:
        errorMessages = 'Method Not Allowed';
        break;
      case 406:
        errorMessages = 'Not Acceptable';
        break;
      case 409:
        errorMessages = 'Conflict';
        break;
      case 412:
        errorMessages = 'Precondition Failed';
        break;
      case 428:
        errorMessages = 'Precondition Required';
        break;
      case 500:
        errorMessages = 'Internal Server Error';
        break;
      default:
        errorMessages = 'Unknown Error';
    }

    errorMessages += json.toString();

    // Convert string to E (error type)
    return Err<T, E>(errorMessages as E);
  }
}
