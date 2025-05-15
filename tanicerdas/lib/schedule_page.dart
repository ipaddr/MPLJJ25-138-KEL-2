import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 25,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Kebun Budi",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "Kemarau",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "April 2025",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDatePicker(),
            const SizedBox(height: 20),
            const Text(
              "Schedule Hari Ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTaskItem(
              "Siram Tomat",
              "Lahan 3",
              LucideIcons.droplet,
              Colors.blue.shade100,
            ),
            _buildTaskItem(
              "Check Tanah",
              "Lahan 1 & 2",
              LucideIcons.sun,
              Colors.yellow.shade100,
            ),
            _buildTaskItem(
              "Komunitas Meeting",
              "2:00 PM",
              LucideIcons.users,
              Colors.purple.shade100,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analysis",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
    final dates = List<int>.generate(30, (index) => index + 1);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final weekdayIndex = (index + 1) % 7;
          final isSelected = dates[index] == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = dates[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  Text(
                    days[weekdayIndex],
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dates[index].toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.green : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(value: false, onChanged: (value) {}),
      ),
    );
  }
}
