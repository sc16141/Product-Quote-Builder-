import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meru_flutter/view/bloc/quotes_bloc.dart';
import 'package:meru_flutter/view/bloc/quotes_event.dart';
import 'package:meru_flutter/view/bloc/quotes_state.dart';
import 'package:meru_flutter/view/screens/preview_screen.dart';
import 'package:meru_flutter/view/screens/screens.dart';
import 'package:meru_flutter/view/widgets/quets.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Main business logic bloc
        BlocProvider<QuoteBloc>(
          create: (_) => QuoteBloc(QuoteLocalStore())..add(InitQuote()),
        ),
        // Add more blocs/cubits here if you need in future
        // BlocProvider<CurrencyCubit>(create: (_) => CurrencyCubit('INR')),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Quote Builder',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),

        // Initial route
        initialRoute: '/',
        routes: {
          '/': (_) => const _RootScaffold(child: QuoteFormScreen()),
          '/preview': (context) => BlocProvider.value(
            value: BlocProvider.of<QuoteBloc>(context),
            child: const QuotePreviewScreen(),
          ),
        },
      ),
    );
  }
}

/// Wraps every page to provide shared listeners / scaffolding.
/// You can put global SnackBars, BlocListeners, etc. here.
class _RootScaffold extends StatelessWidget {
  final Widget child;
  const _RootScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Example: show snackbar when a save finishes
        BlocListener<QuoteBloc, QuoteState>(
          listenWhen: (prev, next) => prev.isSaving != next.isSaving,
          listener: (context, state) {
            if (!state.isSaving) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quote saved locally.')),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
