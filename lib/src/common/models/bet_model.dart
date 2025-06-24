import 'package:equatable/equatable.dart';

class BetModel extends Equatable {
  final String id;
  final String stake;
  final String type;
  final List<String> selections;

  const BetModel({
    required this.id,
    required this.stake,
    required this.type,
    required this.selections,
  });

  // copyWith method
  BetModel copyWith({
    String? id,
    String? stake,
    String? type,
    List<String>? selections,
  }) {
    return BetModel(
      id: id ?? this.id,
      stake: stake ?? this.stake,
      type: type ?? this.type,
      selections: selections ?? this.selections,
    );
  }

  // Factory from Firestore
  factory BetModel.fromJson(Map<String, dynamic> json, String id) {
    return BetModel(
      id: id,
      stake: json['stake']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      selections: json['selections'] is List
          ? (json['selections'] as List<dynamic>)
                .map((e) => e.toString())
                .toList()
          : [json['selections']?.toString() ?? ''], // ✅ fallback if string
    );
  }

  // Factory for empty
  factory BetModel.empty() {
    return const BetModel(id: '', stake: '', type: '', selections: []);
  }

  // To JSON for Firestore
  Map<String, dynamic> toJson() {
    return {'stake': stake, 'type': type, 'selections': selections};
  }

  @override
  List<Object?> get props => [id, stake, type, selections];
}
