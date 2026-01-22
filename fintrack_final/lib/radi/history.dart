import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0B2C4D),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const Text(
          'History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  HistoryItem(success: true, status: PengajuanStatus.approved),
                  HistoryItem(success: true, status: PengajuanStatus.rejected),
                  HistoryItem(success: false, status: PengajuanStatus.pending),
                  HistoryItem(success: true, status: PengajuanStatus.pending),
                  HistoryItem(success: false, status: PengajuanStatus.rejected),
                  HistoryItem(success: false, status: PengajuanStatus.approved),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        ),
      ),
    );
  }
}

enum PengajuanStatus { pending, approved, rejected }

class HistoryItem extends StatelessWidget {
  final bool success;
  final PengajuanStatus status;

  const HistoryItem({super.key, required this.success, required this.status});

  @override
  Widget build(BuildContext context) {
    final bgColor = success ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2);
    final iconBg = success ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA);
    final amountColor = success ? Colors.green.shade800 : Colors.red;
    final eventType = success ? 'transfer from' : 'transfer to';
    final IconData statusIcon;

    switch (status) {
      case PengajuanStatus.pending:
        statusIcon = Icons.refresh;
        break;

      case PengajuanStatus.approved:
        statusIcon = Icons.check_circle_outline;
        break;

      case PengajuanStatus.rejected:
        statusIcon = Icons.cancel_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: SvgPicture.asset(
                success
                    ? 'assets/images/card-receive.svg'
                    : 'assets/images/card-send.svg',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/oval_custom.svg', width: 10, height: 10,),
                      const SizedBox(width: 6),
                      Text(
                        '26 January 2026',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        '  12.00 PM',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(eventType, style: const TextStyle(fontSize: 10)),
                  const SizedBox(height: 4),
                  const Text(
                    'PT Maju Jaya Sejahtera',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Text(
                        'BRI ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '- 73982901801',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      size: 20,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  Text(
                    'Rp. 5.000.000,-',
                    style: TextStyle(
                      color: amountColor,
                      fontWeight: FontWeight.w600,
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
}
