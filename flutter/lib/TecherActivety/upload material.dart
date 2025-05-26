import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Make sure firebase_options.dart is configured if needed
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Learning Material',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadMaterialPage(),
    );
  }
}

class UploadMaterialPage extends StatefulWidget {
  @override
  _UploadMaterialPageState createState() => _UploadMaterialPageState();
}

class _UploadMaterialPageState extends State<UploadMaterialPage> {
  File? selectedFile;
  String title = "";
  String description = "";
  bool isUploading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null || title.isEmpty) return;

    setState(() {
      isUploading = true;
    });

    try {
      final fileName = selectedFile!.path.split('/').last;
      final storageRef = FirebaseStorage.instance.ref().child(
        'learning_materials/$fileName',
      );
      await storageRef.putFile(selectedFile!);

      final fileUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('learning_materials').add({
        'title': title,
        'description': description,
        'file_url': fileUrl,
        'uploaded_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload successful')));

      setState(() {
        selectedFile = null;
        title = "";
        description = "";
      });
    } catch (e) {
      print('Upload failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed')));
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Learning Material")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (val) => title = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (val) => description = val,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickFile, child: Text('Pick File')),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Selected: ${selectedFile!.path.split('/').last}"),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUploading ? null : uploadFile,
              child:
                  isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
