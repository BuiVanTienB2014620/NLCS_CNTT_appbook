import 'package:flutter/material.dart';

import 'app_banner.dart';
import 'auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://noithatluongson.vn/wp-content/uploads/2020/10/t%E1%BB%A7-s%C3%A1ch-e1602472783617.jpg'), // Đặt đường dẫn đến hình ảnh nền của bạn
                fit: BoxFit
                    .cover, // Có thể điều chỉnh để phù hợp với nhu cầu của bạn
              ),
            ),
          ),
        
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Flexible(
                    child: AppBanner(),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
