import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view/home.dart';
import 'view/detail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Game Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.amberAccent.shade400,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/detail': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;

          if (arguments is! int) {
            return Scaffold(
              appBar: AppBar(title: const Text('Detail Game')),
              body: const Center(
                child: Text('ID game tidak valid.'),
              ),
            );
          }

          return Detail(gameTerpilih: arguments);
        },
      },
    );
  }
}