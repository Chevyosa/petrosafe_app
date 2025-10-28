import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/buttons/buttons_inspection.dart';
import 'package:petrosafe_app/widgets/inspection/content_apar.dart';
import 'package:petrosafe_app/widgets/inspection/content_emergencycutoff.dart';
import 'package:petrosafe_app/widgets/inspection/content_ganjalroda.dart';
import 'package:petrosafe_app/widgets/inspection/content_grounding.dart';
import 'package:petrosafe_app/widgets/inspection/content_p3k.dart';
import 'package:petrosafe_app/widgets/inspection/content_safetycone.dart';
import 'package:petrosafe_app/widgets/inspection/content_safetyswitch.dart';
import 'package:petrosafe_app/widgets/inspection/content_spillkit.dart';

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
              InspectionButton(
                title: "Cek APAR",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AparContent()),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Spill Kit",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpillkitContent()),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Ganjal Roda",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GanjalRodaContent(),
                    ),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Safety Cone",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafetyConeContent(),
                    ),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Safety Switch",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafetySwitchContent(),
                    ),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Emergency Cut Off",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyCutOffContent(),
                    ),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Perlengkapan P3K",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => P3KContent()),
                  ),
                },
              ),
              SizedBox(height: 8),
              InspectionButton(
                title: "Cek Grounding",
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroundingContent()),
                  ),
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {},
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
