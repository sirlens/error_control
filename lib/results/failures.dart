abstract class Failure {
  final String message;
  const Failure(this.message);
}

class Result<T> {
    final T? data;
    final Failure? error;
  
    Result.success(this.data) : error = null;
    Result.failure(this.error) : data = null;
  
    bool get isSuccess => error == null;
    bool get isFailure => error != null;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}



class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class ApiResponse {
  final int statusCode;
  final Map<String, dynamic> data;

  ApiResponse(this.statusCode, this.data);
}