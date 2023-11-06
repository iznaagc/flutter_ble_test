import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

// モックデータクラス
class MockDevice {
  final String name;
  final String id;
  final int rssi;

  MockDevice({required this.name, required this.id, required this.rssi});
}

// モックモードと本番モード切替用のクラス
class DeviceData {
  final String name;
  final String id;
  final int rssi;

  DeviceData({required this.name, required this.id, required this.rssi});
}

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  bool mockMode = false;

  // モックデータ
  List<DeviceData> mockData = [
    DeviceData(name: "Mock Device 1", id: "00:00:00:00:00:01", rssi: -60),
    DeviceData(name: "Mock Device 2", id: "00:00:00:00:00:02", rssi: -62),
  ];

  Stream<List<DeviceData>> get scanResult => mockMode
      ? Stream.value(mockData)
      : ble.scanResults.map((results) => results
          .map(
            (result) => DeviceData(
              name: result.device.name,
              id: result.device.id.toString(),
              rssi: result.rssi,
            ),
          )
          .toList());

  Future scanDevices() async {
    if (!mockMode) {
      if (await Permission.bluetoothScan.request().isGranted) {
        if (await Permission.bluetoothConnect.request().isGranted) {
          ble.startScan(timeout: Duration(seconds: 10));
          ble.stopScan();
        }
      }
    }
  }
}
