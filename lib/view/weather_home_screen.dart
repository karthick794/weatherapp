import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/model/weatherforecastmodel.dart';
import 'package:weatherapp/view_model/weather_news_viewmodel.dart';

import '../model/weather_model.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Consumer<WeatherNewsViewModel>(
              builder: (context, weatherViewModel, child) {
            return weatherViewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : WeatherDetail(
                    weatherForecastModel: weatherViewModel.weatherForecastModel,
                    weatherModel: weatherViewModel.weathermodel,
                  );
          }),
        ),
      ),
    );
  }
}

Future<String?> _showSettingsBottomSheet(BuildContext context) async {
  final unitProvider =
      Provider.of<WeatherNewsViewModel>(context, listen: false);
  String? selectedUnit;
  await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text('Temperature Unit'),
              subtitle: const Text('Celsius or Fahrenheit'),
              trailing: Switch(
                value: unitProvider.preferredUnit == 'Celsius',
                onChanged: (bool value) {
                  selectedUnit = value ? 'Celsius' : 'Fahrenheit';
                  unitProvider.setPreferredUnit(selectedUnit!);
                  Navigator.of(context).pop(selectedUnit);
                },
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      );
    },
  );

  return selectedUnit;
}

class WeatherDetail extends StatefulWidget {
  final Weatherforecastmodel? weatherForecastModel;
  final WeatherModel? weatherModel;

  const WeatherDetail({
    super.key,
    required this.weatherForecastModel,
    required this.weatherModel,
  });

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  @override
  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherNewsViewModel>(context); // Listen to changes
    String temperatureString = weatherProvider.preferredUnit == 'Celsius'
        ? weatherProvider
            .celsiusToFahrenheit(widget.weatherModel!.temperature)
            .toStringAsFixed(2)
        : weatherProvider
            .fahrenheitToCelsius(widget.weatherModel!.temperature)
            .toStringAsFixed(2);

    // Use MediaQuery for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await _showSettingsBottomSheet(context);
              },
            ),
            Container(
              height: screenWidth > 600 ? 400 : 330,
              // Responsive height
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: weatherProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue) // Show loading spinner
                      : weatherProvider.weatherForecastModel != null &&
                              weatherProvider.weathermodel !=
                                  null // Check for initialization
                          ? Column(
                              children: [
                                // Get the temperature based on the preferred unit

                                Text(
                                  "$temperatureString °${weatherProvider.preferredUnit == 'Celsius' ? 'C' : 'F'}", // Add the unit here
                                  style: TextStyle(
                                    fontSize: screenWidth > 600 ? 60 : 40,
                                    // Responsive font size
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${widget.weatherModel?.weather[0].main}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "5 Day forecast",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Check if forecast is not empty
                                weatherProvider.weatherForecastModel!.forecast!
                                        .isNotEmpty
                                    ? Container(
                                        height:
                                            150, // Fixed height for the horizontal ListView
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: weatherProvider
                                                  .weatherForecastModel
                                                  ?.forecast
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            final forecast = weatherProvider
                                                .weatherForecastModel
                                                ?.forecast?[index];
                                            final weather =
                                                forecast?.weather?.isNotEmpty ==
                                                        true
                                                    ? forecast!.weather![0]
                                                    : null;
                                            final iconCode = weather?.icon;
                                            final iconUrl = iconCode != null
                                                ? "https://openweathermap.org/img/wn/$iconCode@2x.png"
                                                : null;

                                            return weather != null &&
                                                    forecast != null
                                                ? weatherInfoCard(
                                                    icon: iconUrl,
                                                    title: weather.main,
                                                    value: forecast.main?.temp
                                                            ?.toString() ??
                                                        'Unknown',
                                                  )
                                                : const Center(
                                                    child: Text(
                                                        'No data available'));
                                          },
                                        ),
                                      )
                                    : const Center(
                                        child:
                                            Text('No forecast data available')),
                                // Message if no forecast data
                              ],
                            )
                          : const Center(
                              child: Text(
                                  'No data available. Please try again later.')), // Display message if no data is available
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom weather info card
Widget weatherInfoCard({
  required String? icon,
  required String? title,
  required String? value,
}) {
  return Container(
    width: 120,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white30,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Image.network(icon, width: 50, height: 50),
        const SizedBox(height: 10),
        Text(
          title ?? 'Unknown',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'Unknown',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
