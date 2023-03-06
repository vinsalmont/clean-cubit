import 'package:clean_cubit/presentation/router/arguments/favorites_arguments.dart';
import 'package:clean_cubit/presentation/router/arguments/photo_detail_arguments.dart';
import 'package:clean_cubit/presentation/router/routes.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    required this.arguments,
  }) : super();

  final FavoritesArguments arguments;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: GridView.builder(
          itemCount: widget.arguments.photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    photoDetail,
                    arguments: PhotoDetailArguments(
                      photo: widget.arguments.photos[index],
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      FancyShimmerImage(
                        imageUrl: widget.arguments.photos[index].thumbnailUrl,
                        boxFit: BoxFit.fitWidth,
                        height: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          widget.arguments.photos[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}
