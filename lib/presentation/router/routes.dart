import 'dart:core';
import 'package:clean_cubit/presentation/pages/favorites/favorites_screen.dart';
import 'package:clean_cubit/presentation/pages/feed/feed_screen.dart';
import 'package:clean_cubit/presentation/pages/photo_detail/photo_detail_screen.dart';
import 'package:clean_cubit/presentation/router/arguments/favorites_arguments.dart';
import 'package:clean_cubit/presentation/router/arguments/photo_detail_arguments.dart';
import 'package:flutter/material.dart';

const String feed = 'feed';
const String favorites = '/favorites';
const String photoDetail = '/photoDetail';

PageRoute routeGeneration(RouteSettings settings) {
  WidgetBuilder builder = (_) => const FeedScreen();
  switch (settings.name) {
    case feed:
      builder = (_) => const FeedScreen();
      break;
    case favorites:
      if (settings.arguments is FavoritesArguments) {
        builder = (_) => FavoritesScreen(
              arguments: settings.arguments as FavoritesArguments,
            );
      }
      break;
    case photoDetail:
      if (settings.arguments is PhotoDetailArguments) {
        builder = (_) => PhotoDetailScreen(
              arguments: settings.arguments as PhotoDetailArguments,
            );
      }
      break;
    default:
      builder = (_) => const FeedScreen();
      break;
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}
