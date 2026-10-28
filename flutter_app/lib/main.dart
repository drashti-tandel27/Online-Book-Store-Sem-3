import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Mobile devices: portrait orientation only.
  // Web: browser controls the viewport/orientation.
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations(
      const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  // System UI configuration is mainly relevant to mobile.
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  runApp(
    const OnlineBookStoreApp(),
  );
}

class OnlineBookStoreApp extends StatelessWidget {
  const OnlineBookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BookProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
      ],

      child: MaterialApp(
        title: 'Online Book Store',

        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightTheme,

        home: const SplashScreen(),
      ),
    );
  }
}