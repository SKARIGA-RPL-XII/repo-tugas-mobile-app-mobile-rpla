import 'package:flutter/material.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0B2C4D),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const Text(
          'Detail Transaction',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _transactionCard(),
            const SizedBox(height: 20),
            _printButton(),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _centerTitle('NOTA TRANSAKSI'),
          _dashedDivider(),

          _row('Company Name', 'PT Maju Jaya Sejahtera'),
          _row('Address', '-'),
          _dashedDivider(),

          _row('Transaction No', 'TRX-000123'),
          _row('Date', '12 Januari 2026'),
          _row('Time', '09:15 PM'),
          _row('Created By', 'Jane Austin'),
          _dashedDivider(),

          _row('Transaction Type', 'Income'),
          _row('Description', 'Penjualan Produk'),
          _dashedDivider(),

          const Text('Rincian :'),
          const SizedBox(height: 8),
          _dashedDivider(),

          _row('Total Incoming', 'Rp 1.500.000,-'),
          _row('Total Outgoing', 'Rp 0'),
          _dashedDivider(),

          _row('Previous Balance', 'Rp 1.500.000,-'),
          _row('Ending Balance', 'Rp 5.000.000,-'),
          _dashedDivider(),

          _row('Last Update', '12 Januari 2026'),
          _dashedDivider(),
        ],
      ),
    );
  }

  Widget _printButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B2C4D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          (); // fungsi print sini
        },
        icon: const Icon(Icons.print, color: Colors.white),
        label: const Text(
          'Print PDF',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(label)),
          const Text(':  '),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }

  Widget _centerTitle(String text) {
    return Center(child: Text(text, style: const TextStyle(letterSpacing: 1)));
  }

  Widget _dashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: List.generate(
              (constraints.maxWidth / 8).floor(),
              (_) => Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey.shade700,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
