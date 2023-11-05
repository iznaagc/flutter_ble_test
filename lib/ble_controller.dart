import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {

  FlutterBlue ble = FlutterBlue.instance;

  // 権限を確認してスキャン開始
  Future scanDevices() async{
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        // Bluetoothスキャン開始
        ble.startScan(timeout: Duration(seconds: 10));

        ble.stopScan();
      }
    }
  }

  Stream<List<ScanResult>> get scanResult => ble.scanResults;
}