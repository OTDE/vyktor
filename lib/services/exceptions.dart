/// Custom [Exception] for when the app sends a bad GraphQL request.
class BadRequestException implements Exception {
  String message;
  BadRequestException(this.message);
}

/// Custom [Exception] for when the internet won't allow a request to be sent.
class InternetException implements Exception {
  String message;
  InternetException(this.message);
}