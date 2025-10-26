import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/buttons/buttons_inspection.dart';

class InspectContent extends StatelessWidget {
  const InspectContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inspeksi Kendaraan", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              InspectionButton(title: "Cek APAR"),
              InspectionButton(title: "Cek Spill Kit"),
              InspectionButton(title: "Cek Ganjal Roda"),
              InspectionButton(title: "Cek Safety Cone"),
              InspectionButton(title: "Cek Safety Switch"),
              InspectionButton(title: "Cek Emergency Cut Off"),
              InspectionButton(title: "Cek Perlengkapan P3K"),
              InspectionButton(title: "Cek Grounding"),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InspectContent()),
                    ),
                  },
                  child: Text(
                    "Selanjutnya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
