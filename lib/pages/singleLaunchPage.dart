import 'package:flutter/material.dart';

import '../models/Launch.dart';

class SingleLaunchPage extends StatelessWidget {
  // SingleLaunchPage({super.key, required this.launch2});
  SingleLaunchPage({Key? key}) : super(key: key);

  final Launch launch = Launch(
    id: '1',
    name: 'Falcon 9',
    net: '2024-10-12T18:26:00Z',
    status: LaunchStatus(
        name: 'Scheduled', abbrev: 'TBD', description: 'On Schedule'),
    rocket:
        Rocket(configuration: RocketConfiguration(name: 'Starlink Group 6-22')),
    mission: Mission(
        name: 'Starlink Mission Group 6-22',
        description: 'Deployment of satellites into orbit'),
    pad: Pad(
      name: 'Space Launch Complex 40',
      mapUrl: 'https://www.example.com',
      location: Location(name: 'Cape Canaveral'),
    ),
    lsp: LaunchServiceProvider(name: 'SpaceX'),
    image:
        "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg",
  );

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = launch.image;
    return Column(
      children: [
        // Custom App Bar
        Container(
          padding: const EdgeInsets.only(
              top: 48.0, left: 8.0, right: 8.0, bottom: 8.0),
          color: Colors
              .black, // Adjust color to match your theme or remove for default theme color.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(launch.name,
                  style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),
        Row(
          children: [
            Text(launch.mission!.name ?? "",
                style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        if (imageUrl != null)
          Image.network(
            imageUrl,
            height: 250,
            fit: BoxFit.cover,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LaunchDetailInfo(
                    title: "Time", value: launch.net.substring(0, 10)),
                LaunchDetailInfo(
                    title: "Date", value: launch.net.substring(11, 16)),
                LaunchDetailInfo(
                    title: "Status", value: launch.status?.abbrev ?? ""),
              ],
            ),
            SizedBox(height: 16),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add to Calendar",
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Icon(Icons.calendar_today, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                Text("pad", style: Theme.of(context).textTheme.bodySmall),
                Text(launch.pad?.name ?? "",
                    style: Theme.of(context).textTheme.bodyLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("View pad location",
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Icon(Icons.location_on, color: Colors.white),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// A reusable row widget for launch details
class LaunchDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const LaunchDetailRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

// A reusable info widget for time, date, and status
class LaunchDetailInfo extends StatelessWidget {
  final String title;
  final String value;

  const LaunchDetailInfo({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
