import 'package:dap_app_new/Screens/all_songs/song_tile.dart';
import 'package:dap_app_new/models/ImageModel.dart';

class CategoryModel extends TrackAbs {

  final String id;
  final String name;
  final String description;
  final List<ImageModel> images;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<ImageModel> images = [];
    if (json.containsKey('images')) {
      images = (json['images'] as List).map((it) => ImageModel.fromJson(it)).toList();
    }
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      images: images
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {};

    _map['_id'] = id;
    _map['name'] = name;
    _map['description'] = description;
    //_map['images'] = ;

    return _map;
  }

}