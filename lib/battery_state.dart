import 'package:equatable/equatable.dart';

class BatteryState extends Equatable {
  final int powerLevel; // de 0 à 3, par exemple
  final bool isCharging;

  const BatteryState({required this.powerLevel, required this.isCharging});

  @override
  List<Object> get props => [powerLevel, isCharging];

  BatteryState copyWith({int? powerLevel, bool? isCharging}) {
    return BatteryState(
      powerLevel: powerLevel ?? this.powerLevel,
      isCharging: isCharging ?? this.isCharging,
    );
  }
}
