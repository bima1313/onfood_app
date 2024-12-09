// login exceptions
class InvalidEmailAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

// updateEmail exceptions
class RequiresRecentLoginAuthException implements Exception {}

class UserTokenExpiredAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}
