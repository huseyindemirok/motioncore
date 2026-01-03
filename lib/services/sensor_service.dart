import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/motion_core_provider.dart';

class SensorService {
  late StreamSubscription<StepCount> _stepCountStream;
  late StreamSubscription<AccelerometerEvent> _accelerometerStream;
  final MotionCoreProvider provider;

  SensorService(this.provider);

  Future<void> startListening() async {
    try {
      // Pedometer stream
      _stepCountStream = Pedometer.stepCountStream.listen(
        (StepCount event) {
          provider.updateSteps(event.steps);
        },
        onError: (error) {
          print('Pedometer error: $error');
        },
      );

      // Accelerometer stream (opsiyonel, gelecekte kullanılabilir)
      _accelerometerStream = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          // Şimdilik kullanmıyoruz ama gelecekte hareket kalitesini ölçmek için kullanılabilir
        },
        onError: (error) {
          print('Accelerometer error: $error');
        },
      );
    } catch (e) {
      print('Sensor initialization error: $e');
    }
  }

  void stopListening() {
    _stepCountStream.cancel();
    _accelerometerStream.cancel();
  }

  Future<int> getInitialStepCount() async {
    try {
      // Stream'den ilk değeri al
      final completer = Completer<int>();
      late StreamSubscription<StepCount> tempSubscription;
      
      tempSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (!completer.isCompleted) {
            completer.complete(event.steps);
            tempSubscription.cancel();
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.complete(0);
            tempSubscription.cancel();
          }
        },
      );
      
      // Timeout ekle
      Future.delayed(const Duration(seconds: 2), () {
        if (!completer.isCompleted) {
          completer.complete(0);
          tempSubscription.cancel();
        }
      });
      
      return await completer.future;
    } catch (e) {
      print('Error getting initial step count: $e');
      return 0;
    }
  }
}

