import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/motion_core_provider.dart';
import '../widgets/starry_background.dart';
import '../widgets/neon_container.dart';
import '../widgets/animated_button.dart';
import '../utils/formatters.dart';

class TerraformingConsoleScreen extends StatefulWidget {
  const TerraformingConsoleScreen({super.key});

  @override
  State<TerraformingConsoleScreen> createState() => _TerraformingConsoleScreenState();
}

class _TerraformingConsoleScreenState extends State<TerraformingConsoleScreen> {
  double _hydrosphereSlider = 0.0;
  double _atmosphereSlider = 0.0;
  double _biosphereSlider = 0.0;
  bool _biosphereLocked = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MotionCoreProvider>(context, listen: false);
    _hydrosphereSlider = provider.planetState.hydrosphere;
    _atmosphereSlider = provider.planetState.atmosphere;
    _biosphereSlider = provider.planetState.biosphere;
    _biosphereLocked = provider.planetState.hydrosphere < 0.5 || provider.planetState.atmosphere < 0.5;
  }

  int _calculateEnergyCost() {
    final provider = Provider.of<MotionCoreProvider>(context, listen: false);
    final current = provider.planetState;
    
    final hydroDiff = (_hydrosphereSlider - current.hydrosphere).abs();
    final atmosDiff = (_atmosphereSlider - current.atmosphere).abs();
    final bioDiff = _biosphereLocked ? 0 : (_biosphereSlider - current.biosphere).abs();
    
    // Her %1 değişiklik = 100 enerji birimi
    return ((hydroDiff + atmosDiff + bioDiff) * 100).toInt();
  }

  void _commitProcess() {
    final provider = Provider.of<MotionCoreProvider>(context, listen: false);
    final cost = _calculateEnergyCost();
    
    if (provider.energyUnits.totalHarvested < cost) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Insufficient energy! Need ${Formatters.formatNumberWithCommas(cost)} units.',
                  style: GoogleFonts.orbitron(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    final success = provider.commitTerraforming(
      hydrosphere: _hydrosphereSlider,
      atmosphere: _atmosphereSlider,
      biosphere: _biosphereLocked ? provider.planetState.biosphere : _biosphereSlider,
    );

    if (success) {
      setState(() {
        _biosphereLocked = _hydrosphereSlider < 0.5 || _atmosphereSlider < 0.5;
        if (_biosphereLocked) {
          _biosphereSlider = 0.0;
        }
      });

      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Terraforming committed! ${Formatters.formatNumberWithCommas(cost)} units spent.',
                  style: GoogleFonts.orbitron(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return Scaffold(
      backgroundColor: const Color(0xFF000510),
      body: StarryBackground(
        child: SafeArea(
          child: Consumer<MotionCoreProvider>(
            builder: (context, provider, child) {
              final current = provider.planetState;
              
              // Slider değerlerini mevcut state'e göre güncelle
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _hydrosphereSlider = current.hydrosphere;
                    _atmosphereSlider = current.atmosphere;
                    _biosphereSlider = current.biosphere;
                    _biosphereLocked = current.hydrosphere < 0.5 || current.atmosphere < 0.5;
                    if (_biosphereLocked && _biosphereSlider > 0) {
                      _biosphereSlider = 0.0;
                    }
                  });
                }
              });

              return Column(
                children: [
                  // Üst Header - X butonu ile
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.0 : 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Text(
                          'TERRAFORM CONSOLE.',
                          style: GoogleFonts.orbitron(
                            fontSize: isSmallScreen ? 14 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Available Energy - Görseldeki gibi
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.0 : 20.0,
                      vertical: 8.0,
                    ),
                    child: NeonContainer(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      glowColor: Colors.cyanAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AVAILABLE ENERGY:',
                            style: GoogleFonts.orbitron(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${Formatters.formatNumberWithCommas(provider.energyUnits.totalHarvested)} UNITS',
                            style: GoogleFonts.orbitron(
                              fontSize: isSmallScreen ? 14 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Slider'lar - Görseldeki gibi
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                      child: Column(
                        children: [
                          _buildResourceSlider(
                            title: 'HYDROSPHERE (Water)',
                            icon: Icons.water_drop,
                            value: _hydrosphereSlider,
                            color: Colors.blue,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              setState(() {
                                _hydrosphereSlider = value;
                                _biosphereLocked = _hydrosphereSlider < 0.5 || _atmosphereSlider < 0.5;
                                if (_biosphereLocked) {
                                  _biosphereSlider = 0.0;
                                }
                              });
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildResourceSlider(
                            title: 'ATMOSPHERE (Air)',
                            icon: Icons.cloud,
                            value: _atmosphereSlider,
                            color: Colors.lightBlue,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              setState(() {
                                _atmosphereSlider = value;
                                _biosphereLocked = _hydrosphereSlider < 0.5 || _atmosphereSlider < 0.5;
                                if (_biosphereLocked) {
                                  _biosphereSlider = 0.0;
                                }
                              });
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildResourceSlider(
                            title: 'BIOSPHERE',
                            subtitle: _biosphereLocked 
                                ? '(Flora - Locked)' 
                                : '(Flora - Unlocked)',
                            icon: Icons.eco,
                            value: _biosphereSlider,
                            color: Colors.green,
                            locked: _biosphereLocked,
                            isSmallScreen: isSmallScreen,
                            onChanged: (value) {
                              if (!_biosphereLocked) {
                                setState(() {
                                  _biosphereSlider = value;
                                });
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 24 : 30),

                          // COMMIT PROCESS Button - Görseldeki gibi (mavi)
                          Builder(
                            builder: (context) {
                              final cost = _calculateEnergyCost();
                              final hasEnoughEnergy = cost > 0 && cost <= provider.energyUnits.totalHarvested;
                              
                              return NeonContainer(
                                padding: EdgeInsets.zero,
                                glowColor: Colors.blueAccent,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: hasEnoughEnergy ? _commitProcess : null,
                                    borderRadius: BorderRadius.circular(8),
                                    child: AnimatedButton(
                                      text: 'COMMIT PROCESS',
                                      backgroundColor: Colors.blueAccent,
                                      disabledColor: Colors.grey.shade700,
                                      onPressed: hasEnoughEnergy ? _commitProcess : null,
                                      padding: EdgeInsets.symmetric(
                                        vertical: isSmallScreen ? 16 : 18,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResourceSlider({
    required String title,
    String? subtitle,
    required IconData icon,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
    required bool isSmallScreen,
    bool locked = false,
  }) {
    final provider = Provider.of<MotionCoreProvider>(context, listen: false);
    final current = provider.planetState;
    
    // Artış yüzdesini hesapla
    double increase = 0.0;
    if (title.contains('HYDROSPHERE')) {
      increase = ((value - current.hydrosphere) * 100);
    } else if (title.contains('ATMOSPHERE')) {
      increase = ((value - current.atmosphere) * 100);
    } else if (title.contains('BIOSPHERE')) {
      increase = ((value - current.biosphere) * 100);
    }

    return NeonContainer(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      glowColor: locked ? Colors.redAccent : Colors.cyanAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: locked ? Colors.redAccent : color,
                size: isSmallScreen ? 18 : 20,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.orbitron(
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w600,
                        color: locked ? Colors.redAccent : Colors.cyanAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: GoogleFonts.exo2(
                          fontSize: isSmallScreen ? 8 : 9,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
              ),
              if (locked)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.redAccent, size: isSmallScreen ? 14 : 16),
                    const SizedBox(width: 4),
                    Text(
                      'LOCKED',
                      style: GoogleFonts.orbitron(
                        fontSize: isSmallScreen ? 8 : 10,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          if (!locked)
            Padding(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: color,
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: color,
                  overlayColor: color.withOpacity(0.3),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
                  trackHeight: 10,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 32),
                ),
                child: Slider(
                  value: value,
                  onChanged: (newValue) {
                    HapticFeedback.selectionClick();
                    onChanged(newValue);
                  },
                  onChangeStart: (_) => HapticFeedback.lightImpact(),
                  onChangeEnd: (_) => HapticFeedback.mediumImpact(),
                  min: 0.0,
                  max: 1.0,
                  divisions: 100, // Daha hassas kontrol için
                ),
              ),
            )
          else
            // Locked durumunda görsel progress bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              child: Stack(
                children: [
                  // Arka plan çubuk
                  Container(
                    height: isSmallScreen ? 8 : 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  // Dolu kısım
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: isSmallScreen ? 8 : 10,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(value * 100).toInt()}%',
                style: GoogleFonts.orbitron(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: locked ? Colors.redAccent : color,
                ),
              ),
              if (increase > 0 && !locked)
                Text(
                  '+${increase.toInt()}% Increase',
                  style: GoogleFonts.exo2(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
