import 'package:clean_cubit/cubit/feed/feed_states.dart';
import 'package:clean_cubit/data/repositories/feed_repository.dart';
import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(
    this._feedRepository,
  ) : super(FeedState.initial());

  final FeedRepository _feedRepository;

  Future<void> loadFeed() async {
    final photos = await _feedRepository.loadFeed();

    emit(
      state.copyWith(
        feed: photos,
      ),
    );
  }

  void selectPhoto({
    required Photo photo,
  }) {
    final photos = List<Photo>.from(state.selectedPhotos)..add(photo);
    emit(state.copyWith(
      selectedPhotos: photos,
    ));
  }

  void deselectPhoto({
    required Photo photo,
  }) {
    final photos = List<Photo>.from(state.selectedPhotos)..remove(photo);
    emit(state.copyWith(
      selectedPhotos: photos,
    ));
  }

  void resetSelection() {
    emit(state.copyWith(
      selectedPhotos: [],
    ));
  }

  bool get isEmpty => state.selectedPhotos.isEmpty;
  int get selectedPhotosCount => state.selectedPhotos.length;

  bool isSelected({
    required Photo photo,
  }) =>
      state.selectedPhotos.contains(photo);
}
