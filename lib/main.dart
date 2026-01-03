import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/motion_core_provider.dart';
import 'services/sensor_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MotionCoreApp());
}

class MotionCoreApp extends StatelessWidget {
  const MotionCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = MotionCoreProvider();
        // Veriler otomatik yüklenecek (storage_service'den)
        // Provider constructor'da initialize() çağrılıyor
        return provider;
      },
      child: MaterialApp(
        title: 'MotionCore',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF000510),
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Colors.cyanAccent,
            secondary: Colors.purpleAccent,
          ),
        ),
        home: const MotionCoreHome(),
      ),
    );
  }
}

class MotionCoreHome extends StatefulWidget {
  const MotionCoreHome({super.key});

  @override
  State<MotionCoreHome> createState() => _MotionCoreHomeState();
}

class _MotionCoreHomeState extends State<MotionCoreHome> {
  SensorService? _sensorService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sensorService == null) {
      _initializeSensors();
    }
  }

  Future<void> _initializeSensors() async {
    final provider = Provider.of<MotionCoreProvider>(context, listen: false);
    _sensorService = SensorService(provider);
    
    try {
      // İlk adım sayısını al
      final initialSteps = await _sensorService!.getInitialStepCount();
      if (initialSteps > 0) {
        provider.updateSteps(initialSteps);
      }
      
      // Sensor stream'lerini başlat
      await _sensorService!.startListening();
    } catch (e) {
      // Sensor erişimi yoksa veya hata varsa, demo modunda çalış
      print('Sensor initialization failed: $e');
      // Provider zaten başlangıç değerleriyle başlatıldı
    }
  }

  @override
  void dispose() {
    _sensorService?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      child: const DashboardScreen(),
    );
  }
}
