import 'package:http/http.dart' as http;
// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/image_list_model.dart';
import 'dart:convert';

List<ImageListModel> imageListModelFromJson(String str) =>
    List<ImageListModel>.from(
        json.decode(str).map((x) => ImageListModel.fromJson(x)));

class ImageListViewModel extends ChangeNotifier {
  static ImageListViewModel read(BuildContext context) =>
      context.read<ImageListViewModel>();

  static ImageListViewModel watch(BuildContext context) =>
      context.watch<ImageListViewModel>();

  bool _isLoading = false;
  bool _isMoreLoading = false;
  List<ImageListModel> _imageListData = [];
  int pageIndex = 1;

  set isMoreLoading(bool value) {
    _isMoreLoading = value;
    notifyListeners();
  }

  Future<List<ImageListModel>> fetchImageListData({int pageIndex = 1}) async {
    var url = "https://api.thecatapi.com/v1/images/search?limit=10";
    var response = await http.get(Uri.parse(url));
    debugPrint("data ${response.body}");
    // if (response.statusCode == 200) {
    List<ImageListModel> data = imageListModelFromJson(response.body);
    return data;
    // }
  }

  Future<void> getImageListData() async {
    _isLoading = true;
    _imageListData = await fetchImageListData();
    isMoreLoading = false;
    notifyListeners();
  }

  Future<void> getMoreImageListData() async {
    pageIndex++;
    isMoreLoading = true;
    var res = await fetchImageListData(pageIndex: pageIndex);
    _imageListData.addAll(res);
    isMoreLoading = false;
    notifyListeners();
  }

  bool get isMoreLoading => _isMoreLoading;

  bool get isLoading => _isLoading;


  List<ImageListModel> get imageListData => _imageListData;
}
