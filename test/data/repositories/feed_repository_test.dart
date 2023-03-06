import 'package:clean_cubit/core/exceptions/http_request_exception.dart';
import 'package:clean_cubit/data/gateways/http_gateway.dart';
import 'package:clean_cubit/data/repositories/feed_repository.dart';
import 'package:clean_cubit/domain/serializers/photo_serializer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpGateway extends Mock implements HttpGateway {}

void main() {
  late HttpGateway httpGateway;
  late PhotoSerializer photoSerializer;
  late FeedRepository feedRepository;

  setUp(() {
    httpGateway = MockHttpGateway();
    photoSerializer = PhotoSerializer();
    feedRepository = FeedRepository(httpGateway, photoSerializer);
  });

  tearDown(() {
    reset(httpGateway);
  });

  group('FeedRepository - ', () {
    test('loadFeed returns a list of photos when successful', () async {
      final photosJson = [
        {
          'id': 1,
          'albumId': 1,
          'title': 'accusamus beatae ad facilis cum similique qui sunt',
          'url': 'https://via.placeholder.com/600/92c952',
          'thumbnailUrl': 'https://via.placeholder.com/150/92c952'
        },
        {
          'id': 2,
          'albumId': 1,
          'title': 'reprehenderit est deserunt velit ipsam',
          'url': 'https://via.placeholder.com/600/771796',
          'thumbnailUrl': 'https://via.placeholder.com/150/771796'
        }
      ];

      final expectedPhotos = photosJson
          .map(
            (e) => photoSerializer.from(e),
          )
          .toList();

      when(() => httpGateway.get(path: any(named: 'path'))).thenAnswer(
        (_) async => {
          'data': photosJson,
        },
      );

      final photos = await feedRepository.loadFeed();

      expect(photos, expectedPhotos);
    });

    test('loadFeed returns empty list when data is empty', () async {
      when(() => httpGateway.get(path: any(named: 'path'))).thenAnswer(
        (_) async => {'data': []},
      );

      final photos = await feedRepository.loadFeed();

      expect(photos, []);
    });

    test('loadFeed throws HttpRequestException when HTTP request fails',
        () async {
      when(() => httpGateway.get(path: any(named: 'path'))).thenThrow(
        HttpRequestException.unknown(message: 'Failed to load data.'),
      );

      expect(
        () async => await feedRepository.loadFeed(),
        throwsA(isA<HttpRequestException>()),
      );
    });
  });
}
