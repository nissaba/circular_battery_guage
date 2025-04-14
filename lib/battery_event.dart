abstract class BatteryEvent {}

class IncrementPower extends BatteryEvent {}

class DecrementPower extends BatteryEvent {}

class ToggleCharging extends BatteryEvent {}
