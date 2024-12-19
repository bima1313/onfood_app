import 'package:flutter/material.dart';

class CouponInformationWidget extends StatelessWidget {
  /// Creates a [CustomListTile].
  ///
  /// The information how to get a coupon.
  const CouponInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Informasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text.rich(
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Jika setiap 5 kali transaksi dengan total ',
                    ),
                    TextSpan(
                      text: 'keseluruhan transaksi pembelian mencapai ',
                    ),
                    TextSpan(
                      text:
                          'minimal 150 ribu, maka akan memperoleh reward berupa kupon diskon.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
