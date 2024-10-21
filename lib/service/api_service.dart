import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weatherforecastmodel.dart';
import '../model/news_model.dart';
import '../model/weather_model.dart';

class APIService{

 Future<WeatherModel> fetchWeather(num lat,num long) async {
    final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=cfafe603576db3552d235b58240fc7c8'));
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future fetchWeatherforecast(num lat,num long) async {
    final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=cfafe603576db3552d235b58240fc7c8'));
    // now we can cange latitude and longitude and let's see how it perfrom.
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        return Weatherforecastmodel.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future getNews({required String emotions}) async {

    // Map weather condition to the corresponding emotion
    String emotion = mapWeatherToEmotion(emotions);
    final response = await http.get(
        Uri.parse('https://newsapi.org/v2/everything?q=$emotion&apiKey=5f3b0927a73d45d19e5201e3f779da4f'));
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(NewsModel.fromJson(json).toString());
        return NewsModel.fromJson(json);
      } else {
        throw Exception('Failed to load news data');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
 String mapWeatherToEmotion(String weatherCondition) {
   switch (weatherCondition.toLowerCase()) {
   // Depressing weather conditions
     case 'cold':
     case 'mist':
     case 'drizzle':
     case 'rain':
     case 'snow':
     case 'thunderstorm':
       return 'depressing';

   // Fear-inducing weather conditions
     case 'hot':
     case 'extreme heat':
     case 'haze':
     case 'dust':
     case 'sandstorm':
     case 'tornado':
       return 'fear';

   // Happy weather conditions
     case 'cool':
     case 'clear':
     case 'sunny':
     case 'partly cloudy':
       return 'happiness';

   // Neutral weather conditions
     case 'clouds':
     case 'fog':
     case 'breeze':
     case 'overcast':
       return 'neutral';

   // Default fallback if condition is unrecognized
     default:
       return 'neutral';
   }
 }

 Future getNewscategory({required String category}) async {
   final response = await http.get(
       Uri.parse('https://newsapi.org/v2/top-headlines?category=$category&apiKey=5f3b0927a73d45d19e5201e3f779da4f'));
   print(response);
   try {
     if (response.statusCode == 200) {
       var json = jsonDecode(response.body);
       print(NewsModel.fromJson(json).toString());
       return NewsModel.fromJson(json);
     } else {
       throw Exception('Failed to load news data');
     }
   } catch (e) {
     print(e.toString());
     rethrow;
   }
 }
}