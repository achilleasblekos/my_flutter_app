import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/models/picture.dart';
import 'package:grada_app/screens/image_details_screen.dart';

class ImagesList extends ConsumerStatefulWidget {
  const ImagesList({super.key, required this.pictures});

  final List<Picture> pictures;

  @override
  ConsumerState<ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends ConsumerState<ImagesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.pictures.isEmpty) {
      return Center(
          child: Text(
        'No images added yet.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemCount: widget.pictures.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: ImageDetailScreen(
                  photo: widget.pictures[index],
                ),
              ),
            ),
          );
        },
        child: GridTile(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(widget.pictures[index].image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
