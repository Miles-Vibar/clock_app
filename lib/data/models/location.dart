import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int? id;
  final String location;

  const Location({
    this.id,
    required this.location,
  });

  Location copyWith({
    int? id,
    String? location,
  }) {
    return Location(
      id: id ?? this.id,
      location: location ?? this.location,
    );
  }
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      location: json['location'],
    );
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "location": location,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      location,
    ];
  }
}
