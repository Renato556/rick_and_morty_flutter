class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String origin;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: _parseInt(json['id']),
      name: json['name'] ?? 'Desconhecido',
      status: json['status'] ?? 'Desconhecido',
      species: json['species'] ?? 'Desconhecido',
      type: json['type'] ?? '',
      gender: json['gender'] ?? 'Desconhecido',
      image: json['image'] ?? '',
      origin:
          (json['origin'] is Map ? json['origin']['name'] : json['origin']) ??
          'Desconhecido',
      location:
          (json['location'] is Map
              ? json['location']['name']
              : json['location']) ??
          'Desconhecido',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'origin': origin,
      'location': location,
    };
  }
}
