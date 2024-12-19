class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Menus
class CouldNotGetAllMenusException extends CloudStorageException {}

class CouldNotGetSpecificMenuException extends CloudStorageException {}

// Orders
class CouldNotGetAllOrdersException extends CloudStorageException {}

class CouldNotUpdateOrderException extends CloudStorageException {}

class CouldNotDeleteOrderException extends CloudStorageException {}

// Coupons
class CouldNotGetCouponException extends CloudStorageException {}

class CouldNotDeleteCouponException extends CloudStorageException {}

class CouldNotUpdateCouponException extends CloudStorageException {}

// Users
class CouldReadUsernameUsersException extends CloudStorageException {}

class CouldNotUpdateUsernameException extends CloudStorageException {}

class CouldNotGetUserDataException extends CloudStorageException {}
