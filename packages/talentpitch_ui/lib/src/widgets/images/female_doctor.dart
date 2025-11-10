import 'package:flutter/material.dart';

class FemaleDoctorImage extends StatelessWidget {
  const FemaleDoctorImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 455,
            height: 382,
            child: Image.asset(
              'lib/assets/images/female_doctor_background.png',
              package: 'swiss_ui',
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 313,
            height: 295,
            child: Image.asset(
              'lib/assets/images/female_doctor.png',
              package: 'swiss_ui',
            ),
          ),
        ),
      ],
    );
  }
}
