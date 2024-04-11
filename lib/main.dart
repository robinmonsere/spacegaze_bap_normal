import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacegaze_bap_normal/pages/singleLaunchPage.dart';
import 'package:spacegaze_bap_normal/theme/color.dart';
import 'package:spacegaze_bap_normal/theme/theme.dart';

import 'helper.dart';
import 'models/Launch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter No Clean Architecture Demo',
      theme: SpaceGazeTheme.darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _previousScrollController = ScrollController();
  final ScrollController _upcomingScrollController = ScrollController();

  final StreamController<List<Launch>> _previousLaunchesController =
      StreamController.broadcast();
  final StreamController<List<Launch>> _upcomingLaunchesController =
      StreamController.broadcast();

  Timer? _timer;
  int _currentPageIndex = 0;
  Duration _countdownDuration = const Duration();

  final int _limit = 3;
  final _baseUrl = "https://lldev.thespacedevs.com/2.0.0/launch";

  Future<List<Launch>> fetchAndUpdatePreviousLaunches() async {
    return List<Launch>.empty();
    print("previous");
    final url = Uri.parse('$_baseUrl/previous?limit=5&offset=0&mode=normal');
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> launchesJson = json.decode(response.body)['results'];
      List<Launch> launches = launchesJson
          .map((json) => Launch.fromJson(json))
          .toList(); // Update the offset based on the number of items fetched
      print(launches);
      return launches;
    } else {
      throw Exception('Failed to load recent launches');
    }
  }

  Future<List<Launch>> fetchAndUpdateUpcomingLaunches() async {
    return List<Launch>.empty();
    final url = Uri.parse('$_baseUrl/upcoming?limit=5&offset=0&mode=normal');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> launchesJson = json.decode(response.body)['results'];
      List<Launch> launches = launchesJson
          .map((json) => Launch.fromJson(json))
          .toList(); // Update the offset based on the number of items fetched
      return launches;
    } else {
      throw Exception('Failed to load upcoming launches');
    }
  }

  void _onViewChange(int index) {
    setState(() {
      _currentPageIndex = index;
      /*
      if (_currentPageIndex != index) {
        // Only animate if the selected tab is different from the current page
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
       */
    });
  }

  void _updateCountdown(DateTime launchDate) {
    setState(() {
      final now = DateTime.now();
      if (launchDate.isAfter(now)) {
        _countdownDuration = launchDate.difference(now);
      } else {
        _countdownDuration = Duration.zero;
        _timer?.cancel(); // Stop the timer if the date has passed
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchAndUpdateUpcomingLaunches(),
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("Waiting");
                    print(snapshot.data);
                    // Show loader while waiting for data
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    // Show error if any
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    // Data is received
                    List<Launch>? upcomingLaunches = snapshot.data;
                    if (upcomingLaunches != null &&
                        upcomingLaunches.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              upcomingLaunches.first.mission!.name ??
                                  "no name provided",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          const Row(
                            children: [
                              Text("More info", style: TextStyle(fontSize: 20)),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // LaunchCountdown(launch: upcomingLaunches.first),
                        ],
                      );
                    } else {
                      return const Text("No upcoming launches found");
                    }
                  } else {
                    // No data received
                    return const Text("Waiting for data...");
                  }
                },
              ),
              const Spacer(),
              Text("Next", style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: fetchAndUpdateUpcomingLaunches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loader while waiting for data
                    return const SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasError) {
                    // Show error if any
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    // Data is received
                    List<Launch>? upcomingLaunches = snapshot.data;
                    if (upcomingLaunches != null &&
                        upcomingLaunches.isNotEmpty) {
                      return SizedBox(
                        height: 150,
                        child: ListView.builder(
                          controller: _upcomingScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingLaunches.sublist(1).length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Launch launch =
                                      upcomingLaunches.sublist(1)[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleLaunchPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      image: DecorationImage(
                                          image: NetworkImage(upcomingLaunches
                                                  .sublist(1)[index]
                                                  .image ??
                                              ""),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: const Color(0xFF4D54F0)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  width: 250,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            upcomingLaunches
                                                    .sublist(1)[index]
                                                    .mission!
                                                    .name ??
                                                "no name provided",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Text(upcomingLaunches
                                                .sublist(1)[index]
                                                .lsp
                                                ?.name ??
                                            ""),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(formatDateToDayMonth(
                                                    upcomingLaunches
                                                        .sublist(1)[index]
                                                        .net)),
                                                Text(formatDateToHourMinute(
                                                    upcomingLaunches
                                                        .sublist(1)[index]
                                                        .net))
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text("No upcoming launches found");
                    }
                  } else {
                    // No data received
                    return const Text("Waiting for data...");
                  }
                },
              ),
              const Spacer(),
              Text("Previous",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: fetchAndUpdatePreviousLaunches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loader while waiting for data
                    return const SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasError) {
                    // Show error if any
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    // Data is received
                    List<Launch>? previousLaunches = snapshot.data;
                    if (previousLaunches != null &&
                        previousLaunches.isNotEmpty) {
                      return SizedBox(
                        height: 150,
                        child: ListView.builder(
                          controller: _previousScrollController,
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: previousLaunches.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  //context.go("/launch");
                                  print("Tapped");
                                  //context.goNamed("/launch/${launch.id}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              previousLaunches[index].image ??
                                                  ""),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: const Color(0xFF4D54F0)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  width: 250,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            previousLaunches[index]
                                                    .mission!
                                                    .name ??
                                                "no name provided",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Text(
                                            previousLaunches[index].lsp?.name ??
                                                ""),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(formatDateToDayMonth(
                                                    previousLaunches[index]
                                                        .net)),
                                                Text(formatDateToHourMinute(
                                                    previousLaunches[index]
                                                        .net))
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text("No previous launches found");
                    }
                  } else {
                    // No data received
                    return const Text("Waiting for data...");
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: ColorConstants.accentColor,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => _onViewChange(index),
          currentIndex: _currentPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_currentPageIndex == 0
                  ? Icons.rocket_launch
                  : Icons.rocket_launch_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentPageIndex == 1
                  ? Icons.satellite_alt
                  : Icons.satellite_alt_outlined),
              label: 'Space Stations',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentPageIndex == 2
                  ? Icons.settings
                  : Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
