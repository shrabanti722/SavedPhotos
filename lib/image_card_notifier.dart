import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_app/image_list_model.dart';

class ImageCardNotifier extends AutoDisposeFamilyAsyncNotifier<String, ImageListModel> {
  late final ImageListModel _imageData;
  bool _hasError = false;
  bool _isRetrying = false;

  @override
  Future<String> build(ImageListModel arg) async {
    _imageData = arg;
    return _simulateInitialError();
  }

  Future<String> _simulateInitialError() async {
    final random = Random();
    _hasError = random.nextBool();

    if (_hasError) {
      return "https://invalid-url.com/image.jpg";
    } else {
      return "${_imageData.url}";
    }
  }

  Future<void> retryImage() async {
    _isRetrying = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      _hasError = false;
      _isRetrying = false;
      return "${_imageData.url}";
    });
  }

  bool get isRetrying => _isRetrying;
}

final imageCardNotifierProvider = AsyncNotifierProvider.autoDispose.family<ImageCardNotifier, String, ImageListModel>(
  ImageCardNotifier.new,
);
