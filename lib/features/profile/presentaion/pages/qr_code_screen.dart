import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PrettyQrView.data(
          data: 'lorem ipsum dolor sit amet',
          decoration: const PrettyQrDecoration(
            image: PrettyQrDecorationImage(
              image: AssetImage('images/flutter.png'),
            ),
            quietZone: PrettyQrQuietZone.standart,
          ),
        ),
      ),
    );
  }
}
