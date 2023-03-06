import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:equatable/equatable.dart';

class FeedState extends Equatable {
  const FeedState({
    required this.feed,
    required this.selectedPhotos,
  });

  factory FeedState.initial() => const FeedState(
        feed: [],
        selectedPhotos: [],
      );

  final List<Photo> feed;
  final List<Photo> selectedPhotos;

  FeedState copyWith({
    bool? isLoading,
    List<Photo>? feed,
    List<Photo>? selectedPhotos,
  }) =>
      FeedState(
        feed: feed ?? this.feed,
        selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      );

  @override
  List<Object?> get props => [feed, selectedPhotos];
}
