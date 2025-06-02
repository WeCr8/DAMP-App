
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/camp.dart';

class AddCampScreen extends StatefulWidget {
  const AddCampScreen({super.key});

  @override
  _AddCampScreenState createState() => _AddCampScreenState();
}

class _AddCampScreenState extends State<AddCampScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isAlternate = false;

  void _saveCamp() async {
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Camp camp = Camp(
      name: _nameController.text,
      latitude: pos.latitude,
      longitude: pos.longitude,
      isAlternate: _isAlternate,
    );
    var campBox = Hive.box<Camp>('camps');
    await campBox.add(camp);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Base/Alternate Camp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Camp Name'),
            ),
            SwitchListTile(
              title: Text('Alternate Camp?'),
              value: _isAlternate,
              onChanged: (val) {
                setState(() {
                  _isAlternate = val;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveCamp,
              child: Text('Save Camp'),
            ),
          ],
        ),
      ),
    );
  }
}
