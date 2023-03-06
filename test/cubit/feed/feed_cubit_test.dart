import 'package:clean_cubit/cubit/feed/feed_cubit.dart';
import 'package:clean_cubit/cubit/feed/feed_states.dart';
import 'package:clean_cubit/data/repository/feed_repository.dart';
import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late FeedRepository feedRepository;
  late FeedCubit feedCubit;

  const photos = [
    Photo(
      albumId: 1,
      id: 1,
      title: 'Photo 1',
      thumbnailUrl: 'https://via.placeholder.com/150/92c952',
      url: 'https://via.placeholder.com/600/92c952',
    ),
    Photo(
      albumId: 2,
      id: 2,
      title: 'Photo 2',
      thumbnailUrl: 'https://via.placeholder.com/150/92c952',
      url: 'https://via.placeholder.com/600/92c952',
    ),
  ];

  setUp(() {
    feedRepository = MockFeedRepository();
    feedCubit = FeedCubit(feedRepository);
  });

  tearDown(() {
    reset(feedRepository);
    feedCubit.close();
  });

  test('initial state is correct', () {
    expect(feedCubit.state, equals(FeedState.initial()));
  });

  group('loadFeed', () {
    test('emits FeedState with photos when loadFeed is successful', () {
      when(() => feedRepository.loadFeed()).thenAnswer(
        (_) => Future.value(photos),
      );

      final expectedStates = [
        const FeedState(feed: photos, selectedPhotos: []),
      ];

      expectLater(
        feedCubit.stream,
        emitsInOrder(expectedStates),
      );

      feedCubit.loadFeed();
    });
  });

  group('selectPhoto', () {
    final photo = photos.first;

    test('adds photo to selectedPhotos', () {
      feedCubit.selectPhoto(photo: photo);

      expect(feedCubit.state.selectedPhotos, equals([photo]));
    });
  });

  group('deselectPhoto', () {
    final photo = photos.first;

    test('removes photo from selectedPhotos', () {
      feedCubit.selectPhoto(photo: photo);
      feedCubit.deselectPhoto(photo: photo);

      expect(feedCubit.state.selectedPhotos, equals([]));
    });
  });

  group('resetSelection', () {
    final photo = photos.first;

    test('resets selectedPhotos', () {
      feedCubit.selectPhoto(photo: photo);
      feedCubit.resetSelection();

      expect(feedCubit.state.selectedPhotos, equals([]));
    });
  });

  group('isSelected', () {
    final photo = photos.first;

    test('returns true when photo is selected', () {
      feedCubit.selectPhoto(photo: photo);

      expect(feedCubit.isSelected(photo: photo), isTrue);
    });

    test('returns false when photo is not selected', () {
      expect(feedCubit.isSelected(photo: photo), isFalse);
    });
  });

  test('isEmpty is true when selectedPhotos is empty', () {
    expect(feedCubit.state.selectedPhotos, isEmpty);
    expect(feedCubit.isEmpty, isTrue);
  });

  test('selectedPhotosCount returns the length of selectedPhotos', () {
    feedCubit.selectPhoto(photo: photos.first);
    feedCubit.selectPhoto(photo: photos.last);

    expect(feedCubit.state.selectedPhotos.length, 2);
    expect(feedCubit.selectedPhotosCount, 2);
  });
}
