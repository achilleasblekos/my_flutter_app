import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/models/picture.dart';
import 'package:grada_app/providers/user_images.dart';
import 'package:grada_app/screens/tabs.dart';

final userImagesProvider =
    StateNotifierProvider<UserImagesNotifier, List<Picture>>(
        (ref) => UserImagesNotifier());

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({Key? key, required this.photo}) : super(key: key);

  final Picture photo;

  void _deleteImage(BuildContext context) async {
    final ref = ProviderContainer();
    final userImagesNotifier = ref.read(userImagesProvider.notifier);

    // Show a confirmation dialog before deleting the image
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true); // Return true to confirm deletion
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false); // Return false to cancel deletion
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      userImagesNotifier.deleteImage(photo);
      
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const TabsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.file(
            photo.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 635,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Delete'),
        ],
        onTap: (index) {
          if (index == 1) {
            _deleteImage(context);
          }
        },
      ),
    );
  }
}
