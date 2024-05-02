import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'response_model.dart';

abstract class HomePageRepository {
  Future<dynamic> askAI(String prompt);
}

class HomePageRepo extends HomePageRepository {
  @override
  Future<dynamic> askAI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-instruct",
            "prompt": "Create a recipe from a list of ingredients: \n$prompt . Show allergy warnings at the end",
            "max_tokens": 250,
            "temperature": 0,
            "top_p": 1,
          },
        ),
      );
      print(response.body);
      return ResponseModel.fromJson(response.body).choices[0]['text'];
    } catch (e) {
      return e.toString();
    }
  }
  
  Future<dynamic> generateImage(String description) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}'
      },
      body: jsonEncode({
        "model": "dall-e-2",
        "prompt": description,
        "n": 1,
        "size": "1024x1024"
      }),
    );

    print("Full API Response: ${response.body}"); // Debugging the full response
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var imageUrl = jsonData['data'][0]['url'];
      return imageUrl;
    } else {
      return "API call failed with status: ${response.statusCode}";
    }
  } catch (e) {
    print("Error in generating image: $e");
    return e.toString();
  }
}



}