import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/planet_state.dart';

class PhaseProgressWidget extends StatelessWidget {
  final PlanetState planetState;

  const PhaseProgressWidget({
    super.key,
    required this.planetState,
  });

  @override
  Widget build(BuildContext context) {
    final phase = planetState.phase;
    final progress = planetState.totalProgress;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.1),
            Colors.purpleAccent.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terraforming Progress',
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Faz Göstergeleri
          Row(
            children: [
              _buildPhaseIndicator(
                phase: PlanetPhase.deadRock,
                currentPhase: phase,
                title: 'Dead Rock',
                icon: Icons.circle_outlined,
                color: Colors.grey,
                objective: 'Stabilize Atmosphere',
              ),
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: phase.index >= 1
                          ? [Colors.blue, Colors.blue]
                          : [Colors.grey, Colors.grey],
                    ),
                  ),
                ),
              ),
              _buildPhaseIndicator(
                phase: PlanetPhase.blueHope,
                currentPhase: phase,
                title: 'Blue Hope',
                icon: Icons.water_drop,
                color: Colors.blue,
                objective: 'Create Oceans',
              ),
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: phase.index >= 2
                          ? [Colors.green, Colors.green]
                          : [Colors.grey, Colors.grey],
                    ),
                  ),
                ),
              ),
              _buildPhaseIndicator(
                phase: PlanetPhase.greenEden,
                currentPhase: phase,
                title: 'Green Eden',
                icon: Icons.eco,
                color: Colors.green,
                objective: 'Sustain Life',
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Genel İlerleme Çubuğu
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Progress',
                    style: GoogleFonts.exo2(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getPhaseColor(phase),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Element İlerlemeleri
          Row(
            children: [
              Expanded(
                child: _buildElementProgress(
                  'Hydrosphere',
                  planetState.hydrosphere,
                  Colors.cyanAccent,
                  Icons.water_drop,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildElementProgress(
                  'Atmosphere',
                  planetState.atmosphere,
                  Colors.blueAccent,
                  Icons.air,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildElementProgress(
                  'Biosphere',
                  planetState.biosphere,
                  Colors.greenAccent,
                  Icons.eco,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator({
    required PlanetPhase phase,
    required PlanetPhase currentPhase,
    required String title,
    required IconData icon,
    required Color color,
    required String objective,
  }) {
    final isActive = phase == currentPhase;
    final isCompleted = phase.index < currentPhase.index;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive
                  ? color.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              border: Border.all(
                color: isActive ? color : Colors.grey.withOpacity(0.3),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isCompleted || isActive ? color : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.exo2(
              fontSize: 10,
              color: isActive ? color : Colors.white54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          if (isActive)
            Text(
              objective,
              style: GoogleFonts.exo2(
                fontSize: 8,
                color: Colors.white38,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildElementProgress(
    String title,
    double value,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.exo2(
                  fontSize: 10,
                  color: Colors.white54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${(value * 100).toInt()}%',
          style: GoogleFonts.orbitron(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getPhaseColor(PlanetPhase phase) {
    switch (phase) {
      case PlanetPhase.deadRock:
        return Colors.grey;
      case PlanetPhase.blueHope:
        return Colors.blue;
      case PlanetPhase.greenEden:
        return Colors.green;
    }
  }
}

