import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:equatable/equatable.dart';

/// Represents the state of the feed screen.
class FeedState extends Equatable {
  /// Constructs a [FeedState] instance with a feed and a list of selected photos.
  const FeedState({
    required this.feed,
    required this.selectedPhotos,
  });

  /// Constructs an initial [FeedState] instance with an empty feed and no selected photos.
  factory FeedState.initial() => const FeedState(
        feed: [],
        selectedPhotos: [],
      );

  /// The list of photos in the feed.
  final List<Photo> feed;

  /// The list of selected photos.
  final List<Photo> selectedPhotos;

  /// Returns a new [FeedState] instance with the specified properties updated.
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
