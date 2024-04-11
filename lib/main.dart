import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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

  Stream<List<Launch>>? upcomingLaunchesStream;
  Stream<List<Launch>>? previousLaunchesStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: upcomingLaunchesStream,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Waiting");
                  print(snapshot.data);
                  // Show loader while waiting for data
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // Show error if any
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  // Data is received
                  List<Launch>? upcomingLaunches = snapshot.data;
                  if (upcomingLaunches != null && upcomingLaunches.isNotEmpty) {
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
                        LaunchCountdown(launch: upcomingLaunches.first),
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
            StreamBuilder(
              stream: upcomingLaunchesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loader while waiting for data
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // Show error if any
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  // Data is received
                  List<Launch>? upcomingLaunches = snapshot.data;
                  if (upcomingLaunches != null && upcomingLaunches.isNotEmpty) {
                    return scheduledLaunchesWidget(upcomingLaunches.sublist(1));
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
            Text("Previous", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: previousLaunchesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loader while waiting for data
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // Show error if any
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  // Data is received
                  List<Launch>? previousLaunches = snapshot.data;
                  if (previousLaunches != null && previousLaunches.isNotEmpty) {
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
                                context.go("/launch");
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
                                      Text(previousLaunches[index].lsp?.name ??
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
                                                  launch.net)),
                                              Text(formatDateToHourMinute(
                                                  launch.net))
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
    );
  }
}
