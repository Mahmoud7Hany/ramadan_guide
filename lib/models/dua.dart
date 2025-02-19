class Dua {
  final String id;
  final String text;
  final String description;
  final DateTime createdAt;
  final bool isFavorite;

  const Dua({
    required this.id,
    required this.text,
    this.description = '',
    required this.createdAt,
    this.isFavorite = false,
  });

  Dua copyWith({
    String? id,
    String? text,
    String? description,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Dua(
      id: id ?? this.id,
      text: text ?? this.text,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] as String,
      text: json['text'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}