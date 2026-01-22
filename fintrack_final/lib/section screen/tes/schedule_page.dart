import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// =======================================================
/// SCHEDULE PAGE
/// =======================================================
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),

        /// ================= APP BAR =================
        appBar: _buildAppBar(),

        /// ================= BODY =================
        body: Column(
          children: [
            const SizedBox(height: 16),
            _calendarCard(),
            const SizedBox(height: 20),
            _addScheduleButton(context),
            const SizedBox(height: 20),
            _companyCard(),
            const SizedBox(height: 16),
            _scheduleList(),
          ],
        ),
      ),
    );
  }

  /// ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Schedule',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
              const SizedBox(width: 16),
              Column(
                children: const [
                  Text(
                    'Juli',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222B45),
                    ),
                  ),
                  Text(
                    '2025',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= CALENDAR CARD =================
  Widget _calendarCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [_weekDays(), const SizedBox(height: 8), _calendarDates()],
        ),
      ),
    );
  }

  Widget _weekDays() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _calendarDates() {
    final weeks = [
      [null, 30, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11, 12],
      [13, 14, 15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24, 25, 26],
      [27, 28, 29, 30, 31, 1, 2],
    ];

    return Column(
      children: weeks.map((week) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: week.map((date) {
            if (date == null) {
              return const SizedBox(width: 40, height: 38);
            }

            final isActive = date == 3;

            return SizedBox(
              width: 40,
              height: 38,
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? const Color(0xFF003366) : null,
                  ),
                  child: Center(
                    child: Text(
                      '$date',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// ================= ADD SCHEDULE BUTTON =================
  Widget _addScheduleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A3A5C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _showAddScheduleModal(context),
          child: const Text(
            'Add Schedule   +',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  /// ================= COMPANY CARD =================
  Widget _companyCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PT Maju Jaya Sejahtera',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "This data can be viewed with other's participants",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SCHEDULE LIST =================
  Widget _scheduleList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          ScheduleCard(time: '09.00 AM', title: 'Rapat Koordinasi Tim'),
          ScheduleCard(
            time: '02.00 PM',
            title: 'Penerimaan Pembayaran Klien A',
          ),
          ScheduleCard(time: '03.00 PM', title: 'Penerimaan Investor'),
        ],
      ),
    );
  }
}

/// =======================================================
/// ADD SCHEDULE MODAL
/// =======================================================
void _showAddScheduleModal(BuildContext parentContext) {
  List<String> selectedUsers = ['Ach. Zaeni', 'Asyifaul H.'];
  bool remindEnabled = true;
  List<String> reminderTimes = ['21', '0.5', '0.7'];

  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetaContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Center(
                  child: Text(
                    'Add New Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A5C),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Schedule Name
                _buildLabel('Schedule Name'),
                const SizedBox(height: 8),
                _buildTextField('Input Here...'),
                const SizedBox(height: 16),

                // Description
                _buildLabel('Description'),
                const SizedBox(height: 8),
                _buildTextField('Input Here...', maxLines: 3),
                const SizedBox(height: 16),

                // User
                _buildLabel('User'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedUsers.map((user) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Remind
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('Remind'),
                    Switch(
                      value: remindEnabled,
                      onChanged: (value) {
                        setState(() {
                          remindEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(0xFF1A3A5C),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Reminder time chips
                Wrap(
                  spacing: 8,
                  children: reminderTimes.map((time) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Create Schedule Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A5C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Tutup BottomSheet dulu
                      Navigator.pop(sheetaContext);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showConfirmScheduleDialog(
                          parentContext,

                          // CANCEL
                          () {
                            Navigator.pop(parentContext); // tutup confirm dialog
                            _showAddScheduleModal(
                              parentContext,
                            ); // buka lagi bottom sheet
                          },

                          // SUBMIT
                          () {
                            Navigator.pop(parentContext); // tutup confirm dialog
                            showSuccessScheduleModal(parentContext);
                          },
                        );
                      });
                    },

                    child: const Text(
                      'Create Schedule',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class SuccessScheduleDialog extends StatefulWidget {
  const SuccessScheduleDialog({super.key});

  @override
  State<SuccessScheduleDialog> createState() => _SuccessScheduleDialogState();
}

class _SuccessScheduleDialogState extends State<SuccessScheduleDialog> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Schedule Successfully Created',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your schedule has been successfully created and saved.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessScheduleModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const SuccessScheduleDialog(),
  );
}

Widget _buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1A3A5C),
    ),
  );
}

Widget _buildTextField(String hint, {int maxLines = 1}) {
  return TextField(
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1A3A5C)),
      ),
    ),
  );
}

class ConfirmScheduleDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const ConfirmScheduleDialog({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Are You sure?',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ensure the data is correct before saving!',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3A5C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showConfirmScheduleDialog(
  BuildContext context,
  VoidCallback onCancel,
  VoidCallback onSubmit,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) =>
        ConfirmScheduleDialog(onCancel: onCancel, onSubmit: onSubmit),
  );
}

/// =======================================================
/// SCHEDULE CARD
/// =======================================================
class ScheduleCard extends StatelessWidget {
  final String time;
  final String title;

  const ScheduleCard({super.key, required this.time, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset('assets/icons/delete.svg', width: 18),
        ],
      ),
    );
  }
}
