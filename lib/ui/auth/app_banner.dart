import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // Điều chỉnh chiều rộng
      height: 100, // Điều chỉnh chiều cao
      margin: const EdgeInsets.only(bottom: 70.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 59, 153, 143),
        borderRadius: BorderRadius.circular(10.0), // Điều chỉnh độ cong của góc
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.white,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Center(
        child: Text(
          'SHOP VT ',
          style: TextStyle(
            color: Color.fromARGB(255, 247, 137, 137),
            fontSize: 60,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
