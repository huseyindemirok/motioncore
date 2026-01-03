import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/starry_background.dart';
import '../widgets/neon_container.dart';
import '../providers/motion_core_provider.dart';
import '../utils/formatters.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

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
                    Icons.analytics,
                    color: Colors.cyanAccent,
                    size: isSmallScreen ? 24 : 28,
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Text(
                    'STATISTICS',
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

            // Statistics Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          // Total Stats
                          _buildStatCard(
                            title: 'TOTAL STATS',
                            icon: Icons.trending_up,
                            color: Colors.cyanAccent,
                            isSmallScreen: isSmallScreen,
                            children: [
                              _buildStatItem(
                                label: 'Total Steps',
                                value: Formatters.formatNumberWithCommas(energy.steps),
                                icon: Icons.directions_walk,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              _buildStatItem(
                                label: 'Total Energy Harvested',
                                value: Formatters.formatNumberWithCommas(energy.totalHarvested),
                                icon: Icons.bolt,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              _buildStatItem(
                                label: 'Terraforming Progress',
                                value: '${(planet.totalProgress * 100).toInt()}%',
                                icon: Icons.public,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // Daily Steps Chart
                          _buildStatCard(
                            title: 'DAILY STEPS',
                            icon: Icons.calendar_today,
                            color: Colors.blueAccent,
                            isSmallScreen: isSmallScreen,
                            children: [
                              _buildDailyChart(
                                currentSteps: energy.steps,
                                provider: provider,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // Weekly Steps Chart
                          _buildStatCard(
                            title: 'WEEKLY STEPS',
                            icon: Icons.calendar_view_week,
                            color: Colors.purpleAccent,
                            isSmallScreen: isSmallScreen,
                            children: [
                              _buildWeeklyChart(
                                provider: provider,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // Planet Stats
                          _buildStatCard(
                            title: 'PLANET STATS',
                            icon: Icons.rocket_launch,
                            color: Colors.orange,
                            isSmallScreen: isSmallScreen,
                            children: [
                              _buildStatItem(
                                label: 'Hydrosphere',
                                value: '${(planet.hydrosphere * 100).toInt()}%',
                                icon: Icons.water_drop,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              _buildStatItem(
                                label: 'Atmosphere',
                                value: '${(planet.atmosphere * 100).toInt()}%',
                                icon: Icons.cloud,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              _buildStatItem(
                                label: 'Biosphere',
                                value: '${(planet.biosphere * 100).toInt()}%',
                                icon: Icons.eco,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
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

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
    required List<Widget> children,
  }) {
    return NeonContainer(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      glowColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isSmallScreen,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: isSmallScreen ? 18 : 20),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.exo2(
              fontSize: isSmallScreen ? 12 : 13,
              color: Colors.white70,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: isSmallScreen ? 13 : 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChart({
    required int currentSteps,
    required MotionCoreProvider provider,
    required bool isSmallScreen,
  }) {
    // Gerçek günlük veriler - FutureBuilder kullan
    return FutureBuilder<Map<String, int>>(
      future: provider.getDailySteps(7),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }
        
        final dailyData = snapshot.data!;
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final now = DateTime.now();
        
        // Günlük verileri gün adlarıyla eşleştir
        final Map<String, int> chartData = {};
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final dayName = days[date.weekday - 1];
          chartData[dayName] = dailyData[dateKey] ?? 0;
        }
        
        final maxSteps = chartData.values.isEmpty ? 1000 : (chartData.values.reduce((a, b) => a > b ? a : b));
        final maxStepsDisplay = maxSteps > 0 ? maxSteps : 1000;

        return Column(
          children: [
            // Chart bars
            SizedBox(
              height: isSmallScreen ? 120 : 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: chartData.entries.map((entry) {
                  final height = maxStepsDisplay > 0
                      ? (entry.value / maxStepsDisplay).clamp(0.0, 1.0)
                      : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Bar
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.cyanAccent,
                                  Colors.blueAccent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: (isSmallScreen ? 120.0 : 150.0) * height,
                          ),
                          SizedBox(height: 4),
                          // Day label
                          Text(
                            entry.key,
                            style: GoogleFonts.exo2(
                              fontSize: isSmallScreen ? 8 : 9,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            // Today's steps
            Text(
              'Today: ${Formatters.formatNumberWithCommas(currentSteps)} steps',
              style: GoogleFonts.orbitron(
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyChart({
    required MotionCoreProvider provider,
    required bool isSmallScreen,
  }) {
    // Gerçek haftalık veriler - FutureBuilder kullan
    return FutureBuilder<Map<String, int>>(
      future: provider.getWeeklySteps(4),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
        }
        
        final weeklyData = snapshot.data!;
        final maxSteps = weeklyData.values.isEmpty ? 5000 : (weeklyData.values.reduce((a, b) => a > b ? a : b));
        final maxStepsDisplay = maxSteps > 0 ? maxSteps : 5000;

        return Column(
          children: [
            // Chart bars
            SizedBox(
              height: isSmallScreen ? 120 : 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weeklyData.entries.map((entry) {
                  final height = maxStepsDisplay > 0
                      ? (entry.value / maxStepsDisplay).clamp(0.0, 1.0)
                      : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Bar
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.purpleAccent,
                                  Colors.pinkAccent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: (isSmallScreen ? 120.0 : 150.0) * height,
                          ),
                          SizedBox(height: 4),
                          // Week label
                          Text(
                            entry.key,
                            style: GoogleFonts.exo2(
                              fontSize: isSmallScreen ? 8 : 9,
                              color: Colors.white54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            // Average
            Text(
              'Weekly Average: ${Formatters.formatNumberWithCommas(weeklyData.values.isEmpty ? 0 : (weeklyData.values.reduce((a, b) => a + b) / weeklyData.length).toInt())} steps',
              style: GoogleFonts.orbitron(
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
          ],
        );
      },
    );
  }

}

