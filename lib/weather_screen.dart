import 'dart:convert'; // For JSON parsing
import 'dart:ui'; // For UI-related classes like ImageFilter
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:intl/intl.dart'; // For date formatting
import 'package:weather_app/additional_info_item.dart'; // Custom widget for additional info
import 'package:weather_app/hourly_weather_forecast_item.dart'; // Custom widget for hourly forecast
import 'package:http/http.dart' as http; // HTTP package for API calls
import 'package:weather_app/secrets.dart'; // Contains the OpenWeather API key

// Main WeatherScreen widget
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key}); // Constructor

  @override
  State<WeatherScreen> createState() =>
      _WeatherScreenState(); // State management
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController =
      TextEditingController(); // Controller for the search TextField
  String _cityName = 'Delhi'; // Default city name for weather data
  Future<Map<String, dynamic>>? _weatherFuture; // Future for weather data

  // Fetch current weather data from the OpenWeather API
  Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey&units=metric'),
      );

      final data = jsonDecode(res.body); // Decode the JSON response

      if (data['cod'] != '200') {
        throw data['message']; // Handle errors
      }
      return data; // Return the fetched data
    } catch (e) {
      throw e.toString(); // Catch and throw any errors
    }
  }

  // Update the state with the searched city name and fetch weather data
  void _searchWeather() {
    if (_cityController.text.isNotEmpty) {
      setState(() {
        _cityName = _cityController.text; // Update city name
        _weatherFuture = getCurrentWeather(_cityName); // Fetch new weather data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold), // App bar title style
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {}); // Refresh the weather data
              },
              icon: const Icon(Icons.refresh)) // Refresh icon button
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar (TextField) for city input
            TextField(
              controller: _cityController,
              style: const TextStyle(color: Color.fromARGB(255, 56, 47, 55)),
              decoration: InputDecoration(
                hintText: 'Enter City Name', // Placeholder text
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 135, 119, 119)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: _searchWeather, // Trigger search on button press
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded borders
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: Colors.blueAccent), // Border when focused
                ),
                filled: true,
                fillColor: Colors.white, // Fill color for the TextField
                contentPadding: const EdgeInsets.all(10),
              ),
              onSubmitted: (value) =>
                  _searchWeather(), // Trigger search on submit
            ),
            const SizedBox(height: 20), // Spacing between widgets

            // Display weather information using FutureBuilder
            Expanded(
              child: _weatherFuture != null
                  ? FutureBuilder<Map<String, dynamic>>(
                      future: _weatherFuture, // Future for weather data
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator
                                  .adaptive()); // Loading indicator
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  snapshot.error.toString())); // Error display
                        }

                        final data = snapshot.data!; // Unwrap the data

                        // Extract current weather data
                        final currentTemp = data['list'][0]['main']['temp'];
                        final currentSky =
                            data['list'][0]['weather'][0]['main'];
                        final currentPressure =
                            data['list'][0]['main']['pressure'];
                        final currentWindSpeed =
                            data['list'][0]['wind']['speed'];
                        final currentHumidity =
                            data['list'][0]['main']['humidity'];

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main card with current weather
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY:
                                            10, // Blur effect on the background
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '$currentTemp°C', // Display current temperature
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Icon(
                                              currentSky == 'Clouds' ||
                                                      currentSky == 'Rain'
                                                  ? Icons.cloud
                                                  : Icons
                                                      .sunny, // Weather icon based on condition
                                              size: 64,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              currentSky, // Display current weather condition
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Hourly Forecast', // Section title for hourly forecast
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Hourly forecast in ListView
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                    itemCount: 5, // Number of hourly items
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final hourlyForecast =
                                          data['list'][index + 1];
                                      final hourlySky =
                                          hourlyForecast['weather'][0]['main'];
                                      final time = DateTime.parse(
                                          hourlyForecast['dt_txt']);

                                      return HourlyForeCastItem(
                                          time: DateFormat.Hm()
                                              .format(time), // Format time
                                          icon: hourlySky == 'Clouds' ||
                                                  hourlySky == 'Rain'
                                              ? Icons.cloud
                                              : Icons.sunny,
                                          temperature: hourlyForecast['main']
                                                  ['temp']
                                              .toString()); // Display temperature
                                    }),
                              ),

                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Additional Information', // Section title for additional information
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Additional information row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AdditionalInfoItem(
                                    icon: Icons.water_drop,
                                    label: 'Humidity', // Humidity information
                                    value: currentHumidity.toString(),
                                  ),
                                  AdditionalInfoItem(
                                    icon: Icons.air,
                                    label: 'Wind', // Wind speed information
                                    value: currentWindSpeed.toString(),
                                  ),
                                  AdditionalInfoItem(
                                    icon: Icons.beach_access,
                                    label: 'Pressure', // Pressure information
                                    value: currentPressure.toString(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                          'Please enter a city name to see the weather.'), // Prompt for user input
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
