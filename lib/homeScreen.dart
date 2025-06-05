import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _barcodeTextController = TextEditingController();
  String _currentBarcodeData = "1234567890";
  int _selectedBarcodeTypeIndex = 0;

  final List<BarcodeOption> _barcodeTypes = [
    BarcodeOption("Code 128", Barcode.code128()),
    BarcodeOption("Code 39", Barcode.code39()),
    BarcodeOption("Code 93", Barcode.code93()),
    BarcodeOption("EAN-13", Barcode.ean13()),
    BarcodeOption("EAN-8", Barcode.ean8()),
    BarcodeOption("UPC-E", Barcode.upcE()),
    BarcodeOption("Data Matrix", Barcode.dataMatrix()),
    BarcodeOption("PDF417", Barcode.pdf417()),
  ];

  Barcode get _selectedBarcode =>
      _barcodeTypes[_selectedBarcodeTypeIndex].barcode;

  @override
  void initState() {
    super.initState();
    _barcodeTextController.text = _currentBarcodeData;
  }

  void _updateBarcodeData() {
    setState(() {
      _currentBarcodeData = _barcodeTextController.text.trim().isEmpty
          ? "123456789"
          : _barcodeTextController.text;
    });
  }

  void _copyBarcodeDataToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentBarcodeData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Barcode data copied to clipboard")),
    );
  }

  Widget _buildBarcodeDisplayCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: BarcodeWidget(
        data: _currentBarcodeData,
        barcode: _selectedBarcode,
        width: 300,
        height: 150,
        style: const TextStyle(fontSize: 12),
        errorBuilder: (context, error) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              const Text(
                "Invalid data for selected barcode type",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please check your input or try to different barCode",
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Barcode Data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _barcodeTextController,
              onChanged: (_) => _updateBarcodeData(),
              decoration: InputDecoration(
                labelText: "Data for Barcode",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _barcodeTextController.clear());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Barcode Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedBarcodeTypeIndex,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (index) {
                    setState(() => _selectedBarcodeTypeIndex = index!);
                  },
                  items: _barcodeTypes
                      .asMap()
                      .entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Generated Barcode",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                IconButton(
                  onPressed: _copyBarcodeDataToClipboard,
                  icon: const Icon(Icons.copy),
                  tooltip: "Copy barcode data",
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBarcodeDisplayCard(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Barcode Generator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}

class BarcodeOption {
  final String name;
  final Barcode barcode;

  BarcodeOption(this.name, this.barcode);
}
