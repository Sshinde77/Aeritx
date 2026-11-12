import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';

class OnDeviceNotification {
  static BuildContext? get _ctx => Toaster.navigator?.currentContext;

  static openPageFromMap(Map<String, dynamic> message, BuildContext context) {
    final data = FCMPayload.fromMap(message);
    _buttonAction(data, context);
  }

  static openPageFromLN(Map<String, dynamic> message) {
    final data = FCMPayload.fromMap(message);

    if (_ctx == null) throw Exception('context not found on `openPage`');
    _buttonAction(data, _ctx!);
  }

  static void _buttonAction(FCMPayload data, BuildContext context) {
    final type = data.type;
    if (type == null) return;
    type.action(
      onOrder: () {
        if (data.orderNumber != null) {
          RouteNames.orderDetails.goNamed(
            context,
            query: {'id': data.orderNumber!},
          );
        }
      },
      onSellerChat: () {
        if (data.sellerId != null) {
          RouteNames.sellerChatDetails.pushNamed(
            context,
            pathParams: {'id': data.sellerId!},
          );
        }
      },
    );
  }
}
