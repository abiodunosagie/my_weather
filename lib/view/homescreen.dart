import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/bloc/weather_bloc_state.dart';

import '../bloc/weather_bloc_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again.
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  // When we reach here, permissions are granted, and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class _HomeScreenState extends State<HomeScreen> {
  //greetings variable
  late String greeting;

  @override
  void initState() {
    super.initState();
    // Initialize the greeting when the app starts
    updateGreeting();
    // Set up a timer to update the greeting every minute
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      updateGreeting();
    });
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        greeting = 'Good Morning';
      } else if (hour < 17) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }
    });
  }

  Widget getWeatherImage(int code) {
    switch (code) {
      case > 200 && <= 300:
        return Lottie.asset('assets/thunderstorm.json');
      case >= 300 && < 400:
        return Lottie.asset('assets/rain.json');
      case >= 500 && < 600:
        return Lottie.asset('assets/raining.json');
      case >= 600 && < 700:
        return Lottie.asset('assets/snow.json');
      case >= 700 && < 800:
        return Lottie.asset('assets/cloud.json');
      case == 800:
        return Lottie.asset('assets/sunset1.json');
      case > 800 && <= 804:
        return Lottie.asset('assets/sunset.json');

      default:
        return Lottie.asset('assets/rain.json');
    }
  }

  // Refresh function here
  Future<void> _handleRefresh() async {
    try {
      // Fetch the current position again
      Position currentPosition = await _determinePosition();

      // Dispatch the FetchWeather event with the new position to trigger the refresh
      context.read<WeatherBlocBloc>().add(FetchWeather(currentPosition));

      // Add any additional logic you might need after triggering the refresh

      // You can also add a delay or any asynchronous operation here if needed
      await Future.delayed(const Duration(seconds: 2));

      // If you need to stop the refresh indicator, you can use:
      // _refreshController.refreshCompleted();
    } catch (error) {
      // Handle any errors that occur during the refresh process
      if (kDebugMode) {
        print("Error during refresh: $error");
      }
      // If you need to stop the refresh indicator due to an error, you can use:
      // _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(4, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-4, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1.4),
                  child: Container(
                    height: 300,
                    width: 600,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 100.0,
                    sigmaY: 100.0,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                  builder: (context, state) {
                    if (state is WeatherBlocSuccessful) {
                      ///The refresh package on here refreshing the whole screen state.
                      return LiquidPullToRefresh(
                        color: Colors.transparent,
                        showChildOpacityTransition: true,
                        onRefresh: _handleRefresh,
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                            'assets/profile.json',
                                            width: 60,
                                            height: 60,
                                          ),
                                          Text(
                                            '📍 ${state.weather.areaName}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Gap(5),
                                          Text(
                                            greeting,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          getWeatherImage(state
                                              .weather.weatherConditionCode!),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Text(
                                            '${state.weather.temperature!.celsius?.round()}°C',
                                            style: const TextStyle(
                                              fontSize: 55,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            '${state.weather.weatherMain?.toUpperCase()}',
                                            style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            DateFormat('EEEE dd -')
                                                .add_jm()
                                                .format(state.weather.date!),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Lottie.asset(
                                                    'assets/sun.json',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Gap(5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Sunrise',
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const Gap(2),
                                                      Text(
                                                        DateFormat()
                                                            .add_jm()
                                                            .format(state
                                                                .weather
                                                                .sunrise!),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Lottie.asset(
                                                    'assets/sunset.json',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Gap(5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Sunset',
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const Gap(2),
                                                      Text(
                                                        DateFormat()
                                                            .add_jm()
                                                            .format(state
                                                                .weather
                                                                .sunset!),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Lottie.asset(
                                                    'assets/tempmax.json',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Gap(5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Temp Max',
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const Gap(2),
                                                      Text(
                                                        '${state.weather.tempMax?.celsius?.round()}°C',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Lottie.asset(
                                                    'assets/tempmin.json',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Gap(5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Temp Min',
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const Gap(2),
                                                      Text(
                                                        '${state.weather.tempMin?.celsius?.round()}°C',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Made with ❤️',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' Smith',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // bottom section
                                    // const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Lottie.asset(
                          'assets/loading.json',
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
