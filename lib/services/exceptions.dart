
class BadRequestException implements Exception {
  String message;
  BadRequestException(this.message);
}

class InternetException implements Exception {
  String message;
  InternetException(this.message);
}