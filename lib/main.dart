import 'package:batt_guage/battery_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'battery_bloc.dart';
import 'battery_event.dart';
import 'circular_battery_level_indicator.dart';

void main() {
  runApp(BlocProvider(create: (context) => BatteryBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(title),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<BatteryBloc, BatteryState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularBatteryLevelIndicator(
                    level: state.powerLevel,
                    isCharging: state.isCharging,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => context.read<BatteryBloc>().add(DecrementPower()),
                    child: const Text('-'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => context.read<BatteryBloc>().add(IncrementPower()),
                    child: const Text('+'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => context.read<BatteryBloc>().add(ToggleCharging()),
                    child: const Text('Toggle Charging'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
