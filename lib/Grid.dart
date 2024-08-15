import 'package:flutter/material.dart';

class YearInPixelsGrid extends StatefulWidget {
  @override
  _YearInPixelsGridState createState() => _YearInPixelsGridState();
}

class _YearInPixelsGridState extends State<YearInPixelsGrid> {
  final int year = 2024;
  final Map<String, Color> moodColors = {
    'Amazing': Colors.red,
    'Productive': Colors.orange,
    'Annoying': Colors.yellow,
    'Sick': Colors.green,
    'Tired': Colors.blue,
    'Stressed': Colors.purple,
    'Bad': Colors.grey.shade700,
  };
  final Map<String, String> moodData = {};

  int getDaysInMonth(int year, int month) {
    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear(year)) {
      return 29;
    }
    return daysInMonth[month - 1];
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<String> namesOfMonth = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20.0, // Fixed width for date numbers
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: List.generate(
                          31,
                          (index) => Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(12, (monthIndex) {
                    int daysInMonth = getDaysInMonth(year, monthIndex + 1);

                    return Container(
                      width: (width - 16) / 13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            namesOfMonth[monthIndex],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 30.0, // Adjust width as needed
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable scrolling for individual months
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, // One day per row
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 2.0,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: daysInMonth,
                              itemBuilder: (context, dayIndex) {
                                String dateKey =
                                    '${monthIndex + 1}-${dayIndex + 1}';
                                Color color = moodColors[moodData[dateKey]] ??
                                    Colors.grey.shade200;

                                return GestureDetector(
                                  onTap: () {
                                    _showMoodSelectorDialog(context, dateKey,
                                        monthIndex, dayIndex + 1);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                    ),
                                    margin: const EdgeInsets.all(2.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMoodSelectorDialog(
      BuildContext context, String dateKey, int month, int day) {
        List<String> namesOfMonth = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How was your day?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:12.0),
                child: Text(
                    '${day.toString()} ${namesOfMonth[month]}, ${2024}',style: const TextStyle(fontSize: 15,color: Colors.grey),),
              ),
              ...moodColors.keys.map((mood) {
                return ListTile(
                  title: Text(mood),
                  leading: CircleAvatar(
                    backgroundColor: moodColors[mood],
                  ),
                  onTap: () {
                    setState(() {
                      moodData[dateKey] = mood;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList()
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
