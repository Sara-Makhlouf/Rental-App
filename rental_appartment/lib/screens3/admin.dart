import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0F111A),
      ),
      home: AdminPanel(),
    );
  }
}

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Column(
              children: [
                Topbar(),
                Expanded(child: MainContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final items = [
    {'icon': Icons.dashboard, 'label': 'Dashboard', 'color': Colors.cyan},
    {'icon': Icons.person, 'label': 'Users', 'color': Colors.purpleAccent},
    {
      'icon': Icons.analytics,
      'label': 'Analytics',
      'color': Colors.orangeAccent,
    },
    {'icon': Icons.settings, 'label': 'Settings', 'color': Colors.greenAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      color: Color(0xFF1B1C2C),
      child: Column(
        children: [
          SizedBox(height: 40),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.cyan,
            child: Icon(
              Icons.admin_panel_settings,
              size: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          ...items.map(
            (item) => SidebarItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              color: item['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  SidebarItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      hoverColor: color.withOpacity(0.2),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class Topbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.search, color: Colors.white70),
              SizedBox(width: 20),
              Icon(Icons.notifications_none, color: Colors.white70),
              SizedBox(width: 20),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.cyan,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              ModernStatsCard(
                title: 'Users',
                value: '1.2K',
                color: Colors.cyan,
              ),
              ModernStatsCard(
                title: 'Revenue',
                value: '\$24K',
                color: Colors.purpleAccent,
              ),
              ModernStatsCard(
                title: 'Orders',
                value: '320',
                color: Colors.orangeAccent,
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            height: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1B1C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: LineChart(
              LineChartData(
                backgroundColor: Color(0xFF1B1C2C),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: Colors.white12),
                  getDrawingVerticalLine: (v) => FlLine(color: Colors.white12),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1),
                      FlSpot(1, 2),
                      FlSpot(2, 1.8),
                      FlSpot(3, 3.5),
                      FlSpot(4, 2.9),
                      FlSpot(5, 4.0),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Colors.cyan],
                    ),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModernStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  ModernStatsCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
