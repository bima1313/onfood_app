import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onfood/widgets/buttons/confirm_order_button.dart';
import 'package:onfood/widgets/coupon_information_widget.dart';
import 'package:onfood/widgets/order_information_widget.dart';
import 'package:onfood/widgets/order_text_field.dart';
import 'package:onfood/widgets/order_widget.dart';

class DetailOrderView extends StatefulWidget {
  const DetailOrderView({super.key});

  @override
  State<DetailOrderView> createState() => _DetailOrderViewState();
}

class _DetailOrderViewState extends State<DetailOrderView> {
  late final TextEditingController _informationController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    _informationController = TextEditingController();
    _numberController = TextEditingController();
    initializeDateFormatting();
    super.initState();
  }

  @override
  void dispose() {
    _informationController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrderWidget(),
            OrderTextField(
              numberController: _numberController,
              informationController: _informationController,
            ),
            const OrderInformationWidget(),
            ConfirmOrderButton(
              numberController: _numberController,
              informationController: _informationController,
            ),
            const CouponInformationWidget(),
          ],
        ),
      ),
    );
  }
}
