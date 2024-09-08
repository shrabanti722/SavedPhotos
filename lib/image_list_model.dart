import 'dart:convert';

List<ImageListModel> imageListModelFromJson(String str) =>
    List<ImageListModel>.from(
        json.decode(str).map((x) => ImageListModel.fromJson(x)));

class ImageListModel {
  ImageListModel({
    this.id,
    this.width,
    this.height,
    this.url,
  });

  String? id;
  int? width;
  int? height;
  String? url;

  factory ImageListModel.fromJson(Map<String, dynamic> json) => ImageListModel(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
      );
   @override
  String toString() {
    return 'ImageListModel(id: $id, url: $url)';
  }
}
