import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrcodeScaner extends StatefulWidget {
  final List qrCodeData;

  const QrcodeScaner({super.key, required this.qrCodeData});

  @override
  State<QrcodeScaner> createState() => _QrcodeScanerState();
}

class _QrcodeScanerState extends State<QrcodeScaner> {
  final MobileScannerController _cameraController = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        if (widget.qrCodeData.contains(code)) {
          _cameraController.stop();
          _showMatchedDialog(code);
        }
        break;
      }
    }
  }

  void _showMatchedDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Matched'),
          content: Text('QR Code Detected: $code'),
          actions: [
            TextButton(
              onPressed: () {
// Close the dialog and restart the scanner
                Navigator.of(context).pop();
                _cameraController.start();
              },
              child: const Text('Start Scan Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        controller: _cameraController,
        onDetect: _onDetect,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
