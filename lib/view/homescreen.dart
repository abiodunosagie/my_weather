import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/bloc/weather_bloc_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        return Lottie.asset('assets/rain.json');
      case == 800:
        return Lottie.asset('assets/rain.json');
      case > 800 && <= 804:
        return Lottie.asset('assets/rain.json');

      default:
        return Lottie.asset('assets/rain.json');
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
                      return ListView(
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
                                        Text(
                                          '📍 ${state.weather.areaName}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Gap(5),
                                        const Text(
                                          'Good Morning',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Lottie.asset(
                                          'assets/earth.json',
                                        ),
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
                                                  'assets/sunny.json',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const Gap(5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                          .format(state.weather
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
                                                  'assets/raining.json',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const Gap(5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                              .weather.sunset!),
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
                                                  'assets/thunderstorm.json',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const Gap(5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Temp Max',
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Gap(2),
                                                    Text(
                                                      '${state.weather.tempMax?.celsius?.roundToDouble()}°C',
                                                      style: TextStyle(
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
                                                  'assets/rain.json',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const Gap(5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Temp Min',
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Gap(2),
                                                    Text(
                                                      '${state.weather.tempMin?.celsius?.roundToDouble()}°C',
                                                      style: TextStyle(
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
