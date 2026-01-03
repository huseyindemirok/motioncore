import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/starry_background.dart';
import '../widgets/neon_container.dart';
import '../providers/motion_core_provider.dart';
import '../utils/formatters.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

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
              final energy = provider.energyUnits;
              final planet = provider.planetState;

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          color: Colors.cyanAccent,
                          size: isSmallScreen ? 24 : 28,
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Text(
                          'MISSIONS',
                          style: GoogleFonts.orbitron(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Missions List
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Daily Missions
                          Text(
                            'DAILY MISSIONS',
                            style: GoogleFonts.orbitron(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          
                          _buildMissionCard(
                            context: context,
                            title: 'Walk 5,000 Steps',
                            description: 'Complete your daily walking goal',
                            progress: energy.steps,
                            target: 5000,
                            reward: 500,
                            icon: Icons.directions_walk,
                            color: Colors.blue,
                            isSmallScreen: isSmallScreen,
                            missionId: 'walk_5000_steps',
                            isCompleted: provider.completedMissions.contains('walk_5000_steps'),
                            onClaim: () async {
                              if (energy.steps >= 5000 && !provider.completedMissions.contains('walk_5000_steps')) {
                                final success = await provider.claimMissionReward('walk_5000_steps', 500);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mission completed! +500 energy'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildMissionCard(
                            context: context,
                            title: 'Harvest 1,000 Energy',
                            description: 'Collect energy from your steps',
                            progress: energy.totalHarvested,
                            target: 1000,
                            reward: 200,
                            icon: Icons.bolt,
                            color: Colors.amber,
                            isSmallScreen: isSmallScreen,
                            missionId: 'harvest_1000_energy',
                            isCompleted: provider.completedMissions.contains('harvest_1000_energy'),
                            onClaim: () async {
                              if (energy.totalHarvested >= 1000 && !provider.completedMissions.contains('harvest_1000_energy')) {
                                final success = await provider.claimMissionReward('harvest_1000_energy', 200);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mission completed! +200 energy'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 24 : 30),

                          // Stage Missions
                          Text(
                            'STAGE PROGRESSION',
                            style: GoogleFonts.orbitron(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildMissionCard(
                            context: context,
                            title: 'Reach Stage 2: Blue Hope',
                            description: 'Unlock atmosphere (30%+)',
                            progress: (planet.atmosphere * 100).toInt(),
                            target: 30,
                            reward: 1000,
                            icon: Icons.water_drop,
                            color: Colors.blueAccent,
                            isSmallScreen: isSmallScreen,
                            missionId: 'reach_stage_2',
                            isCompleted: provider.completedMissions.contains('reach_stage_2') || planet.phase.index >= 1,
                            onClaim: () async {
                              if (planet.phase.index >= 1 && !provider.completedMissions.contains('reach_stage_2')) {
                                final success = await provider.claimMissionReward('reach_stage_2', 1000);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mission completed! +1000 energy'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildMissionCard(
                            context: context,
                            title: 'Reach Stage 3: Green Eden',
                            description: 'Unlock biosphere (30%+)',
                            progress: (planet.biosphere * 100).toInt(),
                            target: 30,
                            reward: 2000,
                            icon: Icons.eco,
                            color: Colors.greenAccent,
                            isSmallScreen: isSmallScreen,
                            missionId: 'reach_stage_3',
                            isCompleted: provider.completedMissions.contains('reach_stage_3') || planet.phase.index >= 2,
                            onClaim: () async {
                              if (planet.phase.index >= 2 && !provider.completedMissions.contains('reach_stage_3')) {
                                final success = await provider.claimMissionReward('reach_stage_3', 2000);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mission completed! +2000 energy'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          _buildMissionCard(
                            context: context,
                            title: 'Complete Terraforming',
                            description: 'Reach 100% total progress',
                            progress: (planet.totalProgress * 100).toInt(),
                            target: 100,
                            reward: 5000,
                            icon: Icons.rocket_launch,
                            color: Colors.orange,
                            isSmallScreen: isSmallScreen,
                            missionId: 'complete_terraforming',
                            isCompleted: provider.completedMissions.contains('complete_terraforming') || planet.totalProgress >= 1.0,
                            onClaim: () async {
                              if (planet.totalProgress >= 1.0 && !provider.completedMissions.contains('complete_terraforming')) {
                                final success = await provider.claimMissionReward('complete_terraforming', 5000);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mission completed! +5000 energy'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
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

  Widget _buildMissionCard({
    required BuildContext context,
    required String title,
    required String description,
    required int progress,
    required int target,
    required int reward,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
    required VoidCallback onClaim,
    String? missionId,
    bool isCompleted = false,
  }) {
    final progressPercent = (progress / target).clamp(0.0, 1.0);
    final isClaimable = progress >= target && !isCompleted;

    return NeonContainer(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      glowColor: isCompleted ? Colors.greenAccent : color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.orbitron(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.exo2(
                        fontSize: isSmallScreen ? 10 : 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Icon(Icons.check_circle, color: Colors.greenAccent, size: 24)
              else if (isClaimable)
                IconButton(
                  icon: Icon(Icons.celebration, color: Colors.amber),
                  onPressed: onClaim,
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$progress / $target',
                style: GoogleFonts.orbitron(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Reward: ${Formatters.formatNumberWithCommas(reward)}',
                style: GoogleFonts.orbitron(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Stack(
            children: [
              Container(
                height: isSmallScreen ? 6 : 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressPercent,
                child: Container(
                  height: isSmallScreen ? 6 : 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
