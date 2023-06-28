import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/widgets/images_list.dart';

import '../providers/user_images.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
   return _MainScreenState();
  }

}

class _MainScreenState extends ConsumerState<MainScreen>{
  late Future<void> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = ref.read(userImagesProvider.notifier).loadImages();
  }
  

  @override
  Widget build(BuildContext context) {
    final userImages = ref.watch(userImagesProvider);

    return Scaffold(body: Padding(
      padding: const EdgeInsets.all(0.1),
      child: FutureBuilder(future: _imagesFuture, builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : ImagesList(pictures: userImages),) ,
    ));
  }
}
