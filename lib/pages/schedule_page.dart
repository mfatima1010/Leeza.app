import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'cal_booking_page.dart'; // Ensure this file exists.

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // The selected service.
  String? selectedService;

  // The selected date.
  late DateTime selectedDate;

  // The selected time slot.
  String? selectedTimeSlot;

  // List of service options.
  final List<String> services = [
    "Consultation",
    "Therapy Session",
    "Assessment Evaluation",
    "Other",
  ];

  // Available time slots for Monday to Friday (10 AM to 3 PM).
  final List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
  ];

  // Calendar variables.
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;

  // A map that holds booked slots.
  // Key: date string in "yyyy-MM-dd" format, Value: list of booked time slots.
  static final Map<String, List<String>> bookedSlots = {};

  // Add these new controllers and variables
  late ScrollController _scrollController;
  bool _isScrolled = false;

  // Helper to get the date key.
  String getDateKey(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    DateTime now = DateTime.now();
    // If today is Saturday or Sunday, set selectedDate to next Monday.
    if (now.weekday == DateTime.saturday) {
      selectedDate = now.add(const Duration(days: 2));
    } else if (now.weekday == DateTime.sunday) {
      selectedDate = now.add(const Duration(days: 1));
    } else {
      selectedDate = now;
    }
    _focusedDay = selectedDate;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 20 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 20 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = getDateKey(selectedDate);
    List<String> bookedForDate = bookedSlots[dateKey] ?? [];

    // Define our custom colors
    final Color pinkishColor = const Color(0xFFE5A0FF);
    final Color yellowishColor = const Color(0xFFFFD27A);

    return Scaffold(
      backgroundColor: Color.alphaBlend(
        yellowishColor.withOpacity(0.1),
        Colors.white,
      ), // Blend the colors properly
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Gradient header with safe area
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [pinkishColor, yellowishColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 32, 60, 32),
                  child: Text(
                    "Book Your Session",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      context, "Select a Service", Icons.medical_services),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: services.map((service) {
                      final bool isSelected = service == selectedService;
                      return Material(
                        elevation: isSelected ? 4 : 1,
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedService =
                                  service == selectedService ? null : service;
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: isSelected ? pinkishColor : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : pinkishColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                service,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : pinkishColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(
                      context, "Select a Date", Icons.calendar_today),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: pinkishColor.withOpacity(0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) =>
                            isSameDay(selectedDate, day),
                        onDaySelected: (selected, focused) {
                          setState(() {
                            selectedDate = selected;
                            _focusedDay = focused;
                            // Reset time slot when date changes.
                            selectedTimeSlot = null;
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            color: pinkishColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: pinkishColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: pinkishColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(
                      context, "Select a Time Slot", Icons.access_time),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      final bool isBooked = bookedForDate.contains(slot);
                      final bool isSelected = slot == selectedTimeSlot;
                      return Card(
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: isSelected
                            ? pinkishColor
                            : isBooked
                                ? Colors.grey.shade200
                                : Colors.white,
                        child: InkWell(
                          onTap: isBooked
                              ? null
                              : () {
                                  setState(() {
                                    selectedTimeSlot = slot;
                                  });
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: Text(
                              isBooked ? "$slot\n(Booked)" : slot,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : isBooked
                                        ? Colors.grey
                                        : pinkishColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          (selectedService != null && selectedTimeSlot != null)
                              ? () {
                                  // Construct a URL for Cal.com.
                                  // Here, we use the public page link you provided.
                                  String dateParam = getDateKey(selectedDate);
                                  String url = "https://cal.com/leeza.app"
                                      "?service=${Uri.encodeComponent(selectedService!)}"
                                      "&date=${Uri.encodeComponent(dateParam)}"
                                      "&time=${Uri.encodeComponent(selectedTimeSlot!)}";

                                  // Optionally, simulate local booking by marking the slot as booked.
                                  setState(() {
                                    final key = getDateKey(selectedDate);
                                    if (bookedSlots.containsKey(key)) {
                                      bookedSlots[key]!.add(selectedTimeSlot!);
                                    } else {
                                      bookedSlots[key] = [selectedTimeSlot!];
                                    }
                                  });

                                  // Navigate to the CalBookingPage to complete the booking.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CalBookingPage(url: url),
                                    ),
                                  );
                                }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkishColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Schedule It",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE5A0FF)),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE5A0FF),
              ),
        ),
      ],
    );
  }
}
