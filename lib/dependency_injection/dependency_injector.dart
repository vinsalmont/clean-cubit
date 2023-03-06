import 'package:clean_cubit/data/gateways/http_gateway.dart';
import 'package:clean_cubit/data/repository/feed_repository.dart';
import 'package:clean_cubit/domain/serializers/photo_serializer.dart';
import 'package:get_it/get_it.dart';

class DependencyInjector {
  static final getIt = GetIt.instance;

  static void registerDependencies() {
    // Register the HTTPGateway implmentation
    getIt.registerLazySingleton<HttpGateway>(
      () => HttpGatewayImpl(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        isDebug: true,
      ),
    );

    getIt.registerLazySingleton<PhotoSerializer>(
      PhotoSerializer.new,
    );

    getIt.registerLazySingleton<FeedRepository>(
      () => FeedRepository(
        getIt<HttpGateway>(),
        getIt<PhotoSerializer>(),
      ),
    );
  }
}
