class ImageModel {

  final String id;
  final int position;
  final String path;
  final String path_24;
  final String path_64;
  final String path_100;
  final String path_200;
  final String path_1000;

  ImageModel({
    required this.id,
    required this.position,
    required this.path,
    required this.path_24,
    required this.path_64,
    required this.path_100,
    required this.path_200,
    required this.path_1000});


  factory ImageModel.fromJson(Map<String, dynamic> json) {
    final links = json['image']['links'];
    return ImageModel(
      id: json['imageId'],
      position: json['position'],
      path: links['path']['default'],
      path_24: links['path-24x24']['default'],
      path_64: links['path-64x64']['default'],
      path_100: links['path-100x100']['default'],
      path_200: links['path-200x200']['default'],
      path_1000: links['path-1000x1000']['default']
    );
  }

}