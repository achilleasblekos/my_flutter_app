import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/screens/tabs.dart';
import 'package:grada_app/widgets/image_input.dart';

import '../providers/user_images.dart';

class AddImageScreen extends ConsumerStatefulWidget {
  const AddImageScreen({super.key});

  @override
  ConsumerState<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends ConsumerState<AddImageScreen> {
  File? _selectedImage;

  void _saveImage() async {
  if (_selectedImage == null) {
    return;
  }
  ref.read(userImagesProvider.notifier).addImage(_selectedImage!);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const TabsScreen()));
}
  void _cancel(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const TabsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          ImageInput(
            onPickImage: (image) {
              setState(() {
                _selectedImage = image;
              });
              
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){}, child: const Text('Upload')),
              ElevatedButton(onPressed: _saveImage, child: const Text('Save')),
              ElevatedButton(
                  onPressed: _cancel,
                  child: const Text('Cancel')),
            ],
          ),
        ]),
      ),
    );
  }
}
