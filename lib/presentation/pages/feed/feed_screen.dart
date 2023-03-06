import 'package:clean_cubit/cubit/feed/feed_cubit.dart';
import 'package:clean_cubit/cubit/feed/feed_states.dart';
import 'package:clean_cubit/data/repositories/feed_repository.dart';
import 'package:clean_cubit/dependency_injection/dependency_injector.dart';
import 'package:clean_cubit/presentation/router/arguments/favorites_arguments.dart';
import 'package:clean_cubit/presentation/router/routes.dart';
import 'package:clean_cubit/presentation/widgets/badge_icon_button.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen() : super();

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final FeedCubit _cubit;
  late final FeedRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = DependencyInjector.getIt.get<FeedRepository>();
    _cubit = FeedCubit(_repository);
    _cubit.loadFeed();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<FeedCubit>.value(
        value: _cubit,
        child: BlocBuilder<FeedCubit, FeedState>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              leading: _cubit.isEmpty
                  ? null
                  : TextButton(
                      onPressed: _cubit.resetSelection,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
              actions: _cubit.isEmpty
                  ? null
                  : [
                      BadgeIconButton(
                        iconData: Icons.photo_library_sharp,
                        onPressed: () {
                          Navigator.of(context).pushNamed(favorites,
                              arguments: FavoritesArguments(
                                photos: state.selectedPhotos,
                              ));
                        },
                        badgeCount: _cubit.selectedPhotosCount,
                      ),
                    ],
              title: const Text('Feed'),
            ),
            body: GridView.builder(
              itemCount: state.feed.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  final selectedPhoto = state.feed[index];
                  if (_cubit.isSelected(photo: selectedPhoto)) {
                    _cubit.deselectPhoto(photo: selectedPhoto);
                  } else {
                    _cubit.selectPhoto(photo: selectedPhoto);
                  }
                },
                child: Stack(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          FancyShimmerImage(
                            imageUrl: state.feed[index].thumbnailUrl,
                            boxFit: BoxFit.fitWidth,
                            height: 150,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Text(
                              state.feed[index].title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_cubit.isSelected(photo: state.feed[index]))
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
