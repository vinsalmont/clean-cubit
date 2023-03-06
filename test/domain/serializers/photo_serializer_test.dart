import 'package:clean_cubit/domain/entities/photo.dart';
import 'package:clean_cubit/domain/serializers/photo_serializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final serializer = PhotoSerializer();
  final json = {
    'id': 2,
    'albumId': 1,
    'title': 'reprehenderit est deserunt velit ipsam',
    'url': 'https://via.placeholder.com/600/771796',
    'thumbnailUrl': 'https://via.placeholder.com/150/771796'
  };
  final photo = Photo(
    id: json['id'] as int,
    albumId: json['albumId'] as int,
    title: json['title'] as String,
    url: json['url'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String,
  );

  test('Should deserialize the json object', () {
    final expectedPhoto = serializer.from(json);

    expect(expectedPhoto, photo);
  });

  test('Should serialize the object to json', () {
    final expectedJson = serializer.to(photo);

    expect(json, expectedJson);
  });
}
