import "package:jwt_decoder/jwt_decoder.dart";

String? getUserIdFromJwt(String? jwt) {
  if (jwt == null) {
    return null;
  }
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  return decodedToken['user_id'] as String;
}

String? getUsernameFromJwt(String? jwt) {
  if (jwt == null) {
    return null;
  }
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  return decodedToken['username'] as String;
}
