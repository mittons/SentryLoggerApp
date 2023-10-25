import 'package:flutter/material.dart';
import 'config.dart'; // This file will be dynamically created to hold your secret.
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry/sentry.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDNS;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Display',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Secret Display'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Super Secret Data: $superSecretData'),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: pressTheButton,
                  child: Text("Press me. Double dare you!")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pressTheButton() async {
    try {
      aMethodThatMightFail();
    } catch (exception, stacktrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
    }
  }

  void aMethodThatMightFail() {
    throw Exception("$notSoSecretData");
  }
}
