import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sajilo/screens/userinfo/components/logout_button.dart';
import 'package:sajilo/screens/userinfo/components/profile_image.dart';
import '../../services/auth.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService data = Provider.of<AuthService>(context);
    ScreenScaler scale = ScreenScaler();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileImage(data: data, scale: scale),
            const SizedBox(height: 25),
            Text(
              data.userInfo ?? 'Anonymous',
              style: TextStyle(fontSize: scale.getFullScreen(8)),
            ),
            const SizedBox(height: 25),
            Text(
              data.message ?? 'no messages for anonymous users',
              style: TextStyle(fontSize: scale.getFullScreen(6.5)),
            ),
            const SizedBox(height: 50),
            LogoutButton(data: data, scale: scale),
            SizedBox(
              height: 5.0,
            ),
            //Text(data.userID)
          ],
        ),
      ),
    );
  }
}
