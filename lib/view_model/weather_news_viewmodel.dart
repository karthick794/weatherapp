import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/news_model.dart';
import 'package:weatherapp/model/weatherforecastmodel.dart';
import '../model/weather_model.dart';
import '../service/api_service.dart';

class WeatherNewsViewModel extends ChangeNotifier {
  late WeatherModel?weathermodel;
  late Weatherforecastmodel? weatherForecastModel;
  bool isLoading = false;
  late num lat;
  late num long;
  late String emotions;
  List<Article> newsArticles = [];
  String _preferredUnit = 'Celsius'; // Default unit


  String get preferredUnit => _preferredUnit;

  bool _isInitialized = false; // Track initialization
  WeatherNewsViewModel() {
  initialize();
  }

  Future<void> initialize() async {
    if (_isInitialized) return; // Prevent multiple initializations

    isLoading = true;
    notifyListeners(); // Notify listeners that loading has started

    try {
      await getCurrentLocation();
      if (lat != null && long != null) {
        await fetchWeather(lat, long);
        await fetchWeatherforecast(lat, long);
        await fetchNews();
      } else {
        throw Exception("Location data is not available.");
      }
    } catch (e) {
      print("Error during initialization: $e");
    } finally {
      isLoading = false; // Set loading to false after fetching
      _isInitialized = true; // Set initialized to true
      notifyListeners(); // Notify listeners that loading is complete
    }
  }


  Future<void> getCurrentLocation() async {
    // Check the current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // If permission is still denied after requesting
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('Location permissions are denied. Cannot access location.');
        }
        return; // Exit the function as we cannot access location
      }
    }

    // If permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print('Location permissions are permanently denied. Please enable them in settings.');
      }
      return; // Exit the function as we cannot access location
    }

    // If permission is granted, get the location
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude; // Store the latitude
      long = position.longitude; // Store the longitude
      print("Latitude: $lat, Longitude: $long");
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: ${e.toString()}');
      }
    }
  }


  Future<void> fetchWeather(num lat, num long) async {
    isLoading = true;
    notifyListeners(); // Notify listeners to indicate loading state
    try {
      WeatherModel fetchedWeather = await APIService().fetchWeather(lat, long);
      weathermodel = fetchedWeather;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    isLoading = false;
    notifyListeners(); // Notify listeners that loading is complete
  }

  Future<void> fetchWeatherforecast(num lat, num long) async {
    isLoading = true;
    notifyListeners(); // Notify listeners to indicate loading state
    try {
      Weatherforecastmodel weatherforecasts = await APIService().fetchWeatherforecast(lat, long);
      weatherForecastModel = weatherforecasts; // Store the fetched forecast model
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    isLoading = false;
    notifyListeners(); // Notify listeners that loading is complete
  }

  Future<void> fetchNews() async {
    emotions = weathermodel!.weather[0].main; // Get the current weather condition
    isLoading = true; // Set loading to true before fetching
    notifyListeners(); // Notify listeners about loading state
    try {
      NewsModel news = await APIService().getNews(emotions: emotions);
      newsArticles = news.articles; // Store fetched news articles
    } catch (e) {
      print(e); // Handle exceptions appropriately
    }finally {
      isLoading = false; // Set loading to false after fetching
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  Future<void> fetchNewscategory(String category) async {
    isLoading = true; // Set loading to true before fetching
    notifyListeners(); // Notify listeners about loading state
    try {
      NewsModel news = await APIService().getNewscategory(category: category);
      newsArticles = news.articles; // Store fetched news articles
    } catch (e) {
      print(e); // Handle exceptions appropriately
    } finally {
      isLoading = false; // Set loading to false after fetching
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  void setPreferredUnit(String unit) {
    _preferredUnit = unit; // Update the preferred unit
    notifyListeners(); // Notify listeners for UI update
  }


  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32; // Convert Celsius to Fahrenheit
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9; // Convert Fahrenheit to Celsius
  }


}
