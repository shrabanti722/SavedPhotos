import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'image_list_model.dart';

part 'image_list_controller.g.dart';

class ImageListState {
  final List<ImageListModel> images;
  final bool isMoreLoading;

  ImageListState({required this.images, required this.isMoreLoading});
}

@riverpod
class ImageListController extends _$ImageListController {
  int pageIndex = 1;

  @override
  Future<ImageListState> build() async {
    final images = await getImageListData();
    return ImageListState(images: images, isMoreLoading: false);
  }

  Future<List<ImageListModel>> fetchImageListData({int pageIndex = 1}) async {
    var url =
        "https://api.thecatapi.com/v1/images/search?limit=10&page=$pageIndex";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return imageListModelFromJson(response.body);
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<List<ImageListModel>> getImageListData() async {
    state = const AsyncLoading();
    try {
      final data = await fetchImageListData(pageIndex: pageIndex);
      state = AsyncData(ImageListState(images: data, isMoreLoading: false));
      return data;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return [];
    }
  }

  Future<void> getMoreImageListData() async {
    if (!state.value!.isMoreLoading) {
      state = AsyncData(ImageListState(images: state.value!.images, isMoreLoading: true));

      final nextPageIndex = pageIndex + 1;
      try {
        final moreData = await fetchImageListData(pageIndex: nextPageIndex);
        state = AsyncData(ImageListState(images: [...state.value!.images, ...moreData], isMoreLoading: false));
        pageIndex = nextPageIndex;
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    }
  }
}
