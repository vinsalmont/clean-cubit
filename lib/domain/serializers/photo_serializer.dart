import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:clean_cubit/domain/serializers/serializer.dart';

/// Keys for the fields in the photo JSON
class _Keys {
  static const albumId = 'albumId';
  static const id = 'id';
  static const title = 'title';
  static const url = 'url';
  static const thumbnailUrl = 'thumbnailUrl';
}

/// A serializer for [Photo] entities
class PhotoSerializer implements Serializer<Photo, Map<String, dynamic>> {
  @override
  Photo from(Map<String, dynamic> json) {
    final albumId = json[_Keys.albumId] as int;
    final id = json[_Keys.id] as int;
    final title = json[_Keys.title] as String;
    final url = json[_Keys.url] as String;
    final thumbnailUrl = json[_Keys.thumbnailUrl] as String;

    return Photo(
      albumId: albumId,
      id: id,
      title: title,
      url: url,
      thumbnailUrl: thumbnailUrl,
    );
  }

  @override
  Map<String, dynamic> to(Photo photo) => <String, dynamic>{
        _Keys.albumId: photo.albumId,
        _Keys.id: photo.id,
        _Keys.title: photo.title,
        _Keys.url: photo.url,
        _Keys.thumbnailUrl: photo.thumbnailUrl,
      };
}
