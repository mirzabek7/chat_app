import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_chat_app/screens/home_screen.dart';
import 'package:test_chat_app/services/auth/auth_service.dart';
import 'package:test_chat_app/services/chat/chat_service.dart';
import 'package:test_chat_app/services/user/user_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: '*************',
      appId: '**************',
      messagingSenderId: '***********',
      projectId: '***********',
      storageBucket: '**************',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ChatService(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        routes: {
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
        },
      ),
    );
  }
}
