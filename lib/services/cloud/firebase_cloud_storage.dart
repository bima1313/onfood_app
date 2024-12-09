import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onfood/services/cloud/constructor/cloud_coupons.dart';
import 'package:onfood/services/cloud/constructor/cloud_menus.dart';
import 'package:onfood/services/cloud/constructor/cloud_orders.dart';
import 'package:onfood/services/cloud/cloud_storage_constants.dart';
import 'package:onfood/services/cloud/cloud_storage_exceptions.dart';
import 'package:onfood/services/cloud/constructor/users.dart';

class FirebaseCloudStorage {
  // Firestore Collections
  final usersCollections = FirebaseFirestore.instance.collection('users');
  final menusCollections = FirebaseFirestore.instance.collection('menus');
  final ordersCollections = FirebaseFirestore.instance.collection('orders');
  final couponCollections = FirebaseFirestore.instance.collection('coupon');

  Future<Iterable<CloudMenus>> allMenu() async {
    try {
      return await menusCollections.get().then(
            (value) => value.docs.map((doc) => CloudMenus.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllMenusException();
    }
  }

  Future<CloudOrders> createOrder({
    required String ownerUserId,
    required String displayName,
    required String dateTimeOrder,
    required String tableNumber,
    required Map orders,
    required int totalPayment,
    required bool donePayment,
    required String information,
  }) async {
    final document = await ordersCollections.add({
      ownerUserIdFieldName: ownerUserId,
      displayNameFieldName: displayName,
      dateTimeFieldName: dateTimeOrder,
      tableNumberFieldName: tableNumber,
      userOrdersFieldName: orders,
      totalPaymentFieldName: totalPayment,
      donePaymentFieldName: donePayment,
      informationFieldName: information,
    });
    final fetchedOrder = await document.get();
    return CloudOrders(
      documentId: fetchedOrder.id,
      userId: ownerUserId,
      displayName: displayName,
      dateTime: dateTimeOrder,
      tableNumber: tableNumber,
      userOrders: orders,
      totalPayment: totalPayment,
      donePayment: donePayment,
      information: information,
    );
  }

  Future<Iterable<CloudOrders>> allorder({required String ownerUserId}) async {
    try {
      return await ordersCollections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .orderBy(dateTimeFieldName, descending: true)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudOrders.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllOrdersException();
    }
  }

  Future<void> deleteOrder({
    required String documentId,
  }) async {
    try {
      await ordersCollections.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOrderException();
    }
  }

  Future<CloudCoupons> createCoupon({
    required String documentId,
    required String ownerUserId,
    required int reward,
  }) async {
    await couponCollections.doc(documentId).set({
      ownerUserIdFieldName: ownerUserId,
      discountFieldName: reward,
    });
    return CloudCoupons(
      documentId: documentId,
      userId: ownerUserId,
      discount: reward,
    );
  }

  Future<void> cancelCoupon({
    required String documentId,
  }) async {
    try {
      await couponCollections.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCouponException();
    }
  }

  Future<void> deleteCoupon({
    required String documentId,
  }) async {
    try {
      await couponCollections.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCouponException();
    }
  }

  Future<Iterable<CloudCoupons>> allCoupon() async {
    try {
      return await couponCollections.get().then(
            (value) => value.docs.map((doc) => CloudCoupons.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllCouponsException();
    }
  }

  Future<Iterable<Users>> users() async {
    try {
      return await usersCollections.get().then(
            (value) => value.docs.map((doc) => Users.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldReadUsernameUsersException();
    }
  }

  Future<Users> createUser({
    required String userId,
    required String username,
    required String phoneNumber,
  }) async {
    final document = await usersCollections.add({
      ownerUserIdFieldName: userId,
      usernameFieldName: username,
      phoneNumberFieldName: phoneNumber,
    });
    final fetchedUser = await document.get();
    return Users(
      documentId: fetchedUser.id,
      userId: userId,
      username: username,
      phoneNumber: phoneNumber,
    );
  }

  Future<Users> userData({
    required String ownerUserId,
  }) async {
    try {
      return await usersCollections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => Users.fromSnapshot(doc)).single,
          );
    } catch (e) {
      throw CouldNotGetUserDataException();
    }
  }

  Future<void> updateUserData({
    required String documentId,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      await usersCollections.doc(documentId).update({
        usernameFieldName: username,
        phoneNumberFieldName: phoneNumber,
      });
    } catch (e) {
      throw CouldNotUpdateUsernameException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
