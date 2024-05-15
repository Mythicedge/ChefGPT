import 'dart:convert';

class ImageResponseModel { // Handling output given by the OpenAI API for Image Generation
  final String url;

  ImageResponseModel({required this.url});

  factory ImageResponseModel.fromMap(Map<String, dynamic> map) {
  // Detailed error handling
  if (map.containsKey('data') && map['data'] is List) {
    var dataList = map['data'] as List;
    if (dataList.isNotEmpty && dataList[0] is Map) {
      var firstItem = dataList[0] as Map;
      if (firstItem.containsKey('url') && firstItem['url'] is String) {
        return ImageResponseModel(url: firstItem['url']);
      } else {
        throw FormatException("URL key is missing or not a string in the response.");
      }
    } else {
      throw FormatException("Data list is empty or not formatted correctly.");
    }
  } else {
    throw FormatException("'data' key is missing or not a list in the response.");
  }
}


  factory ImageResponseModel.fromJson(String source) {
    try {
      return ImageResponseModel.fromMap(json.decode(source));
    } catch (e) {
      print("Error parsing JSON: $e");
      rethrow; 
    }
  }

  @override
  String toString() {
    return 'ImageResponseModel(url: $url)';
  }
}
