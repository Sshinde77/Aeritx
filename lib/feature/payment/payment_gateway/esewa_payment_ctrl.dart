// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eSewaPaymentCtrlProvider =
    NotifierProviderFamily<ESewaPaymentCtrlNotifier, String, PaymentState>(
        ESewaPaymentCtrlNotifier.new);

class ESewaPaymentCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  Future<void> initiatePayment(BuildContext context) async {
    try {
      // Use the new esewa_flutter WebView-based API
      final esewaConfig = _creds.isSandbox
          ? ESewaConfig.dev(
              amount: _log.finalAmount,
              successUrl: '${Endpoints.baseApiUrl}/esewa/success',
              failureUrl: '${Endpoints.baseApiUrl}/esewa/failure',
              secretKey: _creds.secretKey,
              productCode: _creds.productCode.isNotEmpty
                  ? _creds.productCode
                  : 'EPAYTEST',
            )
          : ESewaConfig.live(
              amount: _log.finalAmount,
              successUrl: '${Endpoints.baseApiUrl}/esewa/success',
              failureUrl: '${Endpoints.baseApiUrl}/esewa/failure',
              secretKey: _creds.secretKey,
              productCode: _creds.productCode,
            );

      final result = await Esewa.i.init(
        context: context,
        eSewaConfig: esewaConfig,
      );

      if (result.hasData && result.data != null && result.data!.data != null) {
        // Payment successful - result.data contains base64 encoded response
        Logger(':::SUCCESS::: => ${result.data!.data}');
        Toaster.showInfo('please wait ...');
        await onPaymentSuccess(result.data!.data!, context);
      } else {
        // Payment failed or cancelled
        Logger(':::FAILURE::: => ${result.error}');
        Toaster.showInfo('please wait ...');
        await _confirm(context);
      }
    } catch (e, s) {
      talk.ex(e, s);
      Toaster.showError('Payment failed: ${e.toString()}');
    }
  }

  Future<void> onPaymentSuccess(
    String base64Data,
    BuildContext context,
  ) async {
    // The base64Data contains the eSewa response with transaction details
    final jsonData = {"status": "COMPLETE", "data": base64Data};
    await _confirm(context, jsonData);
  }

  ESewaCredentials get _creds =>
      ESewaCredentials.fromMap(_log.method.paymentParameter);

  Future<void> _confirm(
    BuildContext context, [
    Map<String, String>? data,
  ]) async {
    final trx = _log.trx;
    final status = data == null ? 'failed' : 'success';

    String callback = '${_log.method.callbackUrl}/$trx/$status';

    String encodedData = base64Encode(utf8.encode(jsonEncode(data)));

    await PaymentRepo().confirmPayment(
      context,
      {'data': encodedData},
      callback,
      isDeposit: arg.isDeposit,
    );
  }

  PaymentLog get _log => arg.log;

  @override
  String build(PaymentState arg) {
    return '';
  }
}
