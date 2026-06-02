import 'package:get/get.dart';

import '../models/image_model.dart';

class ImageProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Image.fromJson(map);
      if (map is List) return map.map((item) => Image.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Image?> getImage(int id) async {
    final response = await get('image/$id');
    return response.body;
  }

  Future<Response<Image>> postImage(Image image) async => await post('image', image);
  Future<Response> deleteImage(int id) async => await delete('image/$id');
}
