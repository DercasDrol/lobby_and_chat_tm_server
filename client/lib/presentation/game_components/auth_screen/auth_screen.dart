import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/stars_background.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatelessWidget {
  final ValueNotifier<String?> authUrl;
  const AuthScreen(this.authUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          StarsBackground(),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 500,
                  height: 500,
                  child: Center(
                    child: Text(
                      'To use this application you need to be logged in with Discord account.\n'
                      'Click the button below to log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: this.authUrl,
                  builder: (context, url, widget) => MaterialButton(
                    onPressed:
                        url == null ? null : () => launchUrl(Uri.parse(url)),
                    color: Colors.white,
                    disabledColor: Colors.grey[600],
                    hoverColor: Colors.grey[400],
                    minWidth: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 19.0, vertical: 19.0),
                    child: Text('Log in'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
