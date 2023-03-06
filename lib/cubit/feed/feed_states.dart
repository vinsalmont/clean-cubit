import 'package:clean_cubit/domain/entities/photo.dart';

class FeedState {
  const FeedState({
    required this.isLoading,
    required this.feed,
    required this.selectedPhotos,
  });

  factory FeedState.initial() => const FeedState(
        isLoading: true,
        feed: [],
        selectedPhotos: [],
      );

  final bool isLoading;
  final List<Photo> feed;
  final List<Photo> selectedPhotos;

  FeedState copyWith({
    bool? isLoading,
    List<Photo>? feed,
    List<Photo>? selectedPhotos,
  }) =>
      FeedState(
        isLoading: isLoading ?? this.isLoading,
        feed: feed ?? this.feed,
        selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      );
}
