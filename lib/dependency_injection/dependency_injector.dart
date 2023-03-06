import 'package:clean_cubit/data/gateways/http_gateway.dart';
import 'package:clean_cubit/data/repositories/feed_repository.dart';
import 'package:clean_cubit/domain/serializers/photo_serializer.dart';
import 'package:get_it/get_it.dart';

class DependencyInjector {
  static final getIt = GetIt.instance;

  static void registerDependencies() {
    // Register the HTTPGateway implementation
    getIt.registerLazySingleton<HttpGateway>(
      () => HttpGatewayImpl(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        isDebug: true,
      ),
    );

    // Register the PhotoSerializer
    getIt.registerLazySingleton<PhotoSerializer>(
      PhotoSerializer.new,
    );

    // Register the FeedRepository
    getIt.registerLazySingleton<FeedRepository>(
      () => FeedRepository(
        getIt<HttpGateway>(),
        getIt<PhotoSerializer>(),
      ),
    );
  }
}
