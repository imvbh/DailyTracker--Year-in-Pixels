import 'package:flutter/material.dart';
import 'database_provider.dart'; // Import your database helper

class YearInPixelsGrid extends StatefulWidget {
  @override
  _YearInPixelsGridState createState() => _YearInPixelsGridState();
}

class _YearInPixelsGridState extends State<YearInPixelsGrid> {
  final int year = 2024;
  final Map<String, Color> moodColors = {
    'Amazing': const Color.fromARGB(255, 250, 106, 83),
    'Productive': const Color.fromARGB(255, 248, 156, 116),
    'Lazy': const Color.fromARGB(255, 246, 207, 117),
    'Sick': const Color.fromARGB(255, 135, 197, 95),
    'Tiring': const Color.fromARGB(255, 158, 185, 243),
    'Stressful': const Color.fromARGB(255, 204, 102, 255),
    'Bad': const Color.fromARGB(255, 180, 180, 180),
  };
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, Map<String, String>> dayData = {};

  @override
  void initState() {
    super.initState();
    _loadDayData();
  }

  Future<void> _loadDayData() async {
    for (int month = 1; month <= 12; month++) {
      int daysInMonth = getDaysInMonth(year, month);
      for (int day = 1; day <= daysInMonth; day++) {
        String dateKey = '${month}-${day}';
        final data = await _dbHelper.getMoodData(dateKey);
        if (data != null) {
          setState(() {
            dayData[dateKey] = data;
          });
        }
      }
    }
  }

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
    final screenWidth = MediaQuery.of(context).size.width;
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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (screenWidth - 16) / 13,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: List.generate(
                        31,
                        (index) => Container(
                          height: (screenWidth + 4) / 13,
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ...List.generate(12, (monthIndex) {
                  int daysInMonth = getDaysInMonth(year, monthIndex + 1);

                  return Container(
                    width: (screenWidth - 20) / 13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          namesOfMonth[monthIndex],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Container(
                          width: 100,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: daysInMonth,
                            itemBuilder: (context, dayIndex) {
                              String dateKey =
                                  '${monthIndex + 1}-${dayIndex + 1}';
                              Color color =
                                  moodColors[dayData[dateKey]?['mood']] ??
                                      Theme.of(context).colorScheme.primary;

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

    String? selectedMood = dayData[dateKey]?['mood'];
    String? moodNote = dayData[dateKey]?['note'];

    TextEditingController textController =
        TextEditingController(text: moodNote);
    bool isTyping = moodNote != null && moodNote.isNotEmpty;
    bool showMoodSelector = !isTyping;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AlertDialog(
                title: const Text('How was your day?'),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: const EdgeInsets.all(10.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        '${day.toString()} ${namesOfMonth[month]}, $year',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    if (showMoodSelector) ...[
                      ...moodColors.keys.map((mood) {
                        bool isSelected = mood == selectedMood;
                        return ListTile(
                          title: Text(
                            mood,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: moodColors[mood],
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                          onTap: () {
                            setState(() {
                              // Toggle mood selection
                              if (isSelected) {
                                selectedMood =
                                    null; // Deselect if it's already selected
                              } else {
                                selectedMood = mood;
                              }
                            });
                          },
                        );
                      }).toList(),
                      if (selectedMood != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.edit,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                showMoodSelector =
                                    false; // Switch to note input
                              });
                            },
                            label: Text('Wanna write about it?',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary)),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    if (!showMoodSelector) ...[
                      TextField(
                        controller: textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Write about your day (optional)',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        onChanged: (value) {
                          moodNote = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.color_lens,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          label: Text('Change in Mood?',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),
                          onPressed: () {
                            setState(() {
                              showMoodSelector =
                                  true; // Switch back to mood color selection
                            });
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        dayData[dateKey] = {
                          'mood': selectedMood ?? '',
                          'note': moodNote ?? ''
                        };
                      });
                      _dbHelper
                          .insertMoodData(
                              dateKey, selectedMood ?? '', moodNote ?? '')
                          .then((_) {
                        // Refresh the grid after saving
                        _loadDayData();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Save',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
