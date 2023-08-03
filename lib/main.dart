import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multiple_localization/multiple_localization.dart';
import 'package:ui/ui.dart' as ui;

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  static const _localeEn = Locale('en');
  static const _localeEs = Locale('es');

  static final instance = LocaleNotifier._(_localeEn);

  LocaleNotifier._(super.value);

  Locale get _next => value == _localeEn ? _localeEs : _localeEn;

  void switchLocale() {
    value = _next;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    LocaleNotifier.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          _uiLocalizationsDelegate,
          _appLocalizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: <Locale>{
          ...ui.S.delegate.supportedLocales,
          ...S.delegate.supportedLocales,
        },
        locale: LocaleNotifier.instance.value,
        home: const Demo(),
      );
}

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ui.Greeting(),
              TextButton(
                onPressed: () => LocaleNotifier.instance.switchLocale(),
                child: Text(S.of(context).changeLanguage),
              ),
            ],
          ),
        ),
      );
}

class _LocalizationsDelegate<T> extends LocalizationsDelegate<T> {
  _LocalizationsDelegate({
    required this.isLocaleSupported,
    required this.initializeMessages,
    required this.builder,
  });

  bool Function(Locale locale) isLocaleSupported;
  Future<bool> Function(String) initializeMessages;
  FutureOr<T> Function(String locale) builder;

  @override
  bool isSupported(Locale locale) => isLocaleSupported(locale);

  @override
  Future<T> load(Locale locale) {
    return MultipleLocalizations.load(
      initializeMessages,
      locale,
      builder,
      setDefaultLocale: true,
    );
  }

  @override
  bool shouldReload(LocalizationsDelegate<T> old) => false;
}

LocalizationsDelegate<ui.S> _uiLocalizationsDelegate = _LocalizationsDelegate(
  isLocaleSupported: ui.S.delegate.isSupported,
  initializeMessages: ui.initializeMessages,
  builder: (locale) async {
    await ui.S.load(Locale(locale));
    return ui.S();
  },
);

LocalizationsDelegate<S> _appLocalizationsDelegate = _LocalizationsDelegate(
  isLocaleSupported: S.delegate.isSupported,
  initializeMessages: initializeMessages,
  builder: (locale) async {
    await S.load(Locale(locale));
    return S();
  },
);
