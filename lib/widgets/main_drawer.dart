import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/screens/tabs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grada_app/providers/user_images.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key, required this.onSelectScreen, required this.onPickImage});

  final void Function(String identifier) onSelectScreen;

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
  
  final void Function(List<File> images) onPickImage;
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  
  Future<void> _pickImageFromGallery() async {
  final imagePicker = ImagePicker();
  List<XFile>? pickedImages = await imagePicker.pickMultiImage();

  if (pickedImages.isEmpty) {
    return;
  }

  List<File> selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();

  final userImagesNotifier = ref.read(userImagesProvider.notifier);
  for (File image in selectedImages) {
     userImagesNotifier.addImage(image);
  }
  await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const TabsScreen()));

}



  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      DrawerHeader(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Row(children: [
          Image.asset(
            'assets/images/grada.png',
            width: 80,
          ),
          const SizedBox(
            width: 18,
          ),
          Text('MyGraDA',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
        ]),
      ),
      ListTile(
        leading: const Icon(
          Icons.home_outlined,
          size: 30,
        ),
        title: Text("Home",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                )),
        onTap: () {
          widget.onSelectScreen('home');
        },
      ),
      ListTile(
        leading: const Icon(Icons.person_outlined, size: 30),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          widget.onSelectScreen('profile');
        },
      ),
      ListTile(
        leading: const Icon(Icons.folder_outlined, size: 30),
        title: const Text(
          'Images',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onTap: _pickImageFromGallery,
      ),
      const SizedBox(
        height: 350,
      ),
      ListTile(
        leading: const Icon(Icons.logout_outlined, size: 30),
        title: const Text(
          'Logout',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          FirebaseAuth.instance.signOut();
          
        },
      )
    ]));
  }
}
