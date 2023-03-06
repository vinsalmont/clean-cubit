import 'package:clean_cubit/data/repositories/feed_repository.dart';
import 'package:clean_cubit/domain/cubit/feed/feed_states.dart';
import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A [Cubit] that manages the state of the feed screen.
class FeedCubit extends Cubit<FeedState> {
  /// Constructs a [FeedCubit] instance with a [FeedRepository] instance and an initial [FeedState].
  FeedCubit(
    this._feedRepository,
  ) : super(FeedState.initial());

  final FeedRepository _feedRepository;

  /// Loads the feed from the [FeedRepository] and updates the state accordingly.
  Future<void> loadFeed() async {
    final photos = await _feedRepository.loadFeed();

    emit(
      state.copyWith(
        feed: photos,
      ),
    );
  }

  /// Selects a photo and updates the state accordingly.
  void selectPhoto({
    required Photo photo,
  }) {
    final photos = List<Photo>.from(state.selectedPhotos)..add(photo);
    emit(state.copyWith(
      selectedPhotos: photos,
    ));
  }

  /// Deselects a photo and updates the state accordingly.
  void deselectPhoto({
    required Photo photo,
  }) {
    final photos = List<Photo>.from(state.selectedPhotos)..remove(photo);
    emit(state.copyWith(
      selectedPhotos: photos,
    ));
  }

  /// Resets the selected photos and updates the state accordingly.
  void resetSelection() {
    emit(state.copyWith(
      selectedPhotos: [],
    ));
  }

  /// Returns `true` if there are no selected photos, `false` otherwise.
  bool get isEmpty => state.selectedPhotos.isEmpty;

  /// Returns the number of selected photos.
  int get selectedPhotosCount => state.selectedPhotos.length;

  /// Returns `true` if the specified photo is selected, `false` otherwise.
  bool isSelected({
    required Photo photo,
  }) =>
      state.selectedPhotos.contains(photo);
}
