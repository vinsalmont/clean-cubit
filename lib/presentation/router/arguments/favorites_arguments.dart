import 'package:clean_cubit/domain/entities/photo.dart';

class FavoritesArguments {
  const FavoritesArguments({
    required this.photos,
  });
  final List<Photo> photos;
}
