
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/camp.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import 'add_camp_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _targetDevice;
  Box<Camp>? _campBox;
  final int _rssiThreshold = -85;
  final double _safeDistanceMeters = 50;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    _campBox = await Hive.openBox<Camp>('camps');
    await NotificationService.init();
  }

  void _startScan() {
    _flutterBlue.startScan(timeout: Duration(seconds: 5));
    _flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (_targetDevice == null) {
          setState(() {
            _targetDevice = result.device;
          });
          _monitorDevice();
          _flutterBlue.stopScan();
        }
      }
    });
  }

  Future<void> _monitorDevice() async {
    if (_targetDevice == null) return;

    while (true) {
      try {
        var rssi = await _targetDevice!.readRssi();
        if (rssi < _rssiThreshold) {
          Position pos = await LocationService.getCurrentPosition();
          bool isSafe = LocationService.isWithinSafeZone(pos, _campBox!.values.toList(), _safeDistanceMeters);
          if (!isSafe) {
            NotificationService.showNotification("DAMP ALERT 🚨", "Cup left in unsafe location!");
          }
        }
        await Future.delayed(Duration(seconds: 3));
      } catch (e) {
        print('Error monitoring RSSI: $e');
        break;
      }
    }
  }

  void _navigateToAddCamp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddCampScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DAMP - Drink Monitor'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt),
            onPressed: _navigateToAddCamp,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startScan,
          child: Text('Start BLE Scan'),
        ),
      ),
    );
  }
}
