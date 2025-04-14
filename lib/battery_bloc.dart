import 'package:flutter_bloc/flutter_bloc.dart';
import 'battery_event.dart';
import 'battery_state.dart';

class BatteryBloc extends Bloc<BatteryEvent, BatteryState> {
  BatteryBloc() : super(const BatteryState(powerLevel: 2, isCharging: false)) {
    on<IncrementPower>((event, emit) {
      final newPower = (state.powerLevel < 4) ? state.powerLevel + 1 : 4;
      emit(state.copyWith(powerLevel: newPower));
    });

    on<DecrementPower>((event, emit) {
      final newPower = (state.powerLevel > 0) ? state.powerLevel - 1 : 0;
      emit(state.copyWith(powerLevel: newPower));
    });

    on<ToggleCharging>((event, emit) {
      emit(state.copyWith(isCharging: !state.isCharging));
    });
  }
}
