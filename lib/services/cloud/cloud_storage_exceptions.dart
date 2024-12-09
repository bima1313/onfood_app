class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Menus
class CouldNotGetAllMenusException extends CloudStorageException {}

// Orders
class CouldNotGetAllOrdersException extends CloudStorageException {}

class CouldNotUpdateOrderException extends CloudStorageException {}

class CouldNotDeleteOrderException extends CloudStorageException {}

// Coupons
class CouldNotGetAllCouponsException extends CloudStorageException {}

class CouldNotDeleteCouponException extends CloudStorageException {}

// Users
class CouldReadUsernameUsersException extends CloudStorageException {}

class CouldNotUpdateUsernameException extends CloudStorageException {}

class CouldNotGetUserDataException extends CloudStorageException {}
