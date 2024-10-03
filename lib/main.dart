import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latimovies/firebase_options.dart';
import 'package:latimovies/helpers/notification_helper.dart';
import 'package:latimovies/providers/authentication_provider.dart';
import 'package:latimovies/providers/base_provider.dart';
import 'package:latimovies/providers/games_provider.dart';
import 'package:latimovies/screens/home_screen.dart';
import 'package:latimovies/screens/login_screen.dart';
import 'package:latimovies/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Future<void> firebaseMeassagingBackgroundHandler(
  RemoteMessage message,
) async {
  if (kDebugMode) {
    print("BACKGROUND MESSAGE");
    print("Handling a background message: ${message.messageId}");
    print("Notification Data : ${message.data}");
    print("message ----");
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMeassagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("FOREGROUND MESSAGE");
    }

    showFlutterNotification(message);
  });

  await setupFlutterNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseProvider>(
          create: (context) => BaseProvider(),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<GamesProvider>(
          create: (context) => GamesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "GAMER",
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class ScreenRouter extends StatefulWidget {
  const ScreenRouter({super.key});

  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return firebaseAuth.currentUser != null
        ? const HomeScreen()
        : const LoginScreen();
  }
}
