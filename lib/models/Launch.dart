class LaunchList {
  final List<Launch> launches;

  LaunchList({required this.launches});

  factory LaunchList.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Launch> launchesList = list.map((i) => Launch.fromJson(i)).toList();
    return LaunchList(launches: launchesList);
  }
}

class Launch {
  final String id;
  final String name;
  final LaunchStatus? status;
  final String net;
  final LaunchServiceProvider? lsp;
  final Rocket rocket;
  final Mission? mission;
  final Pad? pad;
  final String? image;

  Launch(
      {required this.id,
      required this.name,
      this.status,
      required this.net,
      this.lsp,
      required this.rocket,
      this.mission,
      this.pad,
      this.image});

  factory Launch.fromJson(Map<String, dynamic> json) {
    print(json);
    return Launch(
      id: json['id'],
      name: json['name'],
      status:
          json['status'] != null ? LaunchStatus.fromJson(json['status']) : null,
      net: json['net'],
      lsp: json['launch_service_provider'] != null
          ? LaunchServiceProvider.fromJson(json['launch_service_provider'])
          : null,
      rocket: Rocket.fromJson(json['rocket']),
      mission:
          json['mission'] != null ? Mission.fromJson(json['mission']) : null,
      pad: json['pad'] != null ? Pad.fromJson(json['pad']) : null,
      image: json['image'],
    );
  }
}

class LaunchStatus {
  final String name;
  final String? abbrev;
  final String? description;

  LaunchStatus(
      {required this.name, required this.abbrev, required this.description});

  factory LaunchStatus.fromJson(Map<String, dynamic> json) {
    print(json);
    return LaunchStatus(
      name: json['name'],
      abbrev: json['abbrev'],
      description: json['description'],
    );
  }
}

class LaunchServiceProvider {
  final String name;
  final String? type;

  LaunchServiceProvider({required this.name, this.type});

  factory LaunchServiceProvider.fromJson(Map<String, dynamic> json) {
    return LaunchServiceProvider(
      name: json['name'],
      type: json['type'],
    );
  }
}

class Rocket {
  final RocketConfiguration? configuration;

  Rocket({this.configuration});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      configuration: json['configuration'] != null
          ? RocketConfiguration.fromJson(json['configuration'])
          : null,
    );
  }
}

class RocketConfiguration {
  final String name;
  final String? family;
  final String? fullName;

  RocketConfiguration({required this.name, this.family, this.fullName});

  factory RocketConfiguration.fromJson(Map<String, dynamic> json) {
    return RocketConfiguration(
      name: json['name'],
      family: json['family'],
      fullName: json['full_name'],
    );
  }
}

class Mission {
  final String? name;
  final String? description;

  Mission({this.name, this.description});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      name: json['name'],
      description: json['description'],
    );
  }
}

class Pad {
  final String? name;
  final String? mapUrl;
  final Location location;

  Pad({this.name, this.mapUrl, required this.location});

  factory Pad.fromJson(Map<String, dynamic> json) {
    return Pad(
      name: json['name'],
      mapUrl: json['map_url'],
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final String? name;

  Location({this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
    );
  }
}
