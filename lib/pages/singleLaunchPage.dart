import 'package:flutter/material.dart';
import 'package:spacegaze_bap_normal/theme/color.dart';

import '../models/Launch.dart';

class SingleLaunchPage extends StatelessWidget {
  // SingleLaunchPage({super.key, required this.launch2});
  SingleLaunchPage({Key? key}) : super(key: key);

  final Launch launch = Launch(
    id: '1',
    name: 'Starlink Group 6-22',
    net: '2024-10-12T18:26:00Z',
    status: LaunchStatus(
        name: 'Scheduled', abbrev: 'TBD', description: 'On Schedule'),
    rocket: Rocket(configuration: RocketConfiguration(name: 'Falcon 9')),
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
              Text(launch.rocket.configuration?.name ?? "",
                  style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(launch.mission!.name ?? "",
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),

        if (imageUrl != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: ColorConstants.surfaceGray,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LaunchDetailInfo(
                        title: "Time", value: launch.net.substring(11, 16)),
                    LaunchDetailInfo(
                        title: "Date", value: launch.net.substring(5, 10)),
                    LaunchDetailInfo(
                        title: "Status", value: launch.status?.abbrev ?? ""),
                  ],
                ),
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
                    ),
                    const SizedBox(height: 16),
                    Text("Lsp" ?? "",
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      launch.lsp?.name ?? "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// A reusable info widget for time, date, and status
class LaunchDetailInfo extends StatelessWidget {
  final String title;
  final String value;

  const LaunchDetailInfo({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
