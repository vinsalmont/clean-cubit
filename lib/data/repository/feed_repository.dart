import 'package:clean_cubit/core/exceptions/http_request_exception.dart';
import 'package:clean_cubit/data/gateways/http_gateway.dart';
import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:clean_cubit/domain/serializers/photo_serializer.dart';

class _Endpoints {
  static const photos = '/photos';
}

class FeedRepository {
  const FeedRepository(
    this._httpGateway,
    this._photoSerializer,
  );

  final HttpGateway _httpGateway;
  final PhotoSerializer _photoSerializer;

  Future<List<Photo>> loadFeed() async {
    try {
      final response = await _httpGateway.get(path: _Endpoints.photos);
      final rawPhotosJson = response['data'] as Iterable?;

      if (rawPhotosJson == null || rawPhotosJson.isEmpty) {
        return [];
      }

      final photosRawList =
          List<Map<String, dynamic>>.from(rawPhotosJson).toList();
      return photosRawList.map(_photoSerializer.from).toList();
    } on HttpRequestException catch (_) {
      rethrow;
    }
  }
}
