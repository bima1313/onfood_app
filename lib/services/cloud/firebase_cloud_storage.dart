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
  final couponsCollections = FirebaseFirestore.instance.collection('coupons');

  Future<Iterable<CloudMenus>> allMenu() async {
    try {
      return await menusCollections.get().then(
            (value) => value.docs.map((doc) => CloudMenus.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllMenusException();
    }
  }

  Future<CloudMenus> specificMenu({required String menuName}) async {
    try {
      return await menusCollections
          .where(menuNameFieldName, isEqualTo: menuName)
          .get()
          .then((value) =>
              value.docs.map((doc) => CloudMenus.fromSnapshot(doc)).single);
    } catch (e) {
      throw CouldNotGetSpecificMenuException();
    }
  }

  Future<Iterable<CloudOrders>> allOrder({required String ownerUserId}) async {
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

  Future<CloudOrders> createOrder({
    required String ownerUserId,
    required String displayName,
    required Timestamp dateTimeOrder,
    required String tableNumber,
    required Map<String, dynamic> orders,
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

  Future<void> deleteOrder({
    required String documentId,
  }) async {
    try {
      await ordersCollections.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOrderException();
    }
  }

  Future<Iterable<CloudOrders>> historyOrder({
    required String ownerUserId,
  }) async {
    try {
      return await ordersCollections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .where(donePaymentFieldName, isEqualTo: true)
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudOrders.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllOrdersException();
    }
  }

  Future<CloudCoupons> createCoupon({
    required String documentId,
    required String ownerUserId,
    required int reward,
  }) async {
    await couponsCollections.doc(documentId).set({
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
      await couponsCollections.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteCouponException();
    }
  }

  Future<CloudCoupons> getCoupon({required String ownerUserId}) async {
    try {
      return await couponsCollections
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) =>
                value.docs.map((doc) => CloudCoupons.fromSnapshot(doc)).single,
          );
    } catch (e) {
      return const CloudCoupons(documentId: '', userId: '', discount: 0);
    }
  }

  /// To detect if the coupon has been used
  Future<void> changeDocumentId({
    required String ownerUserId,
    required int discount,
    required String newDocumentId,
    required String oldDocumentId,
  }) async {
    try {
      await couponsCollections.doc(newDocumentId).set({
        ownerUserIdFieldName: ownerUserId,
        discountFieldName: discount,
      });
      await couponsCollections.doc(oldDocumentId).delete();
    } catch (e) {
      throw CouldNotUpdateCouponException();
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
