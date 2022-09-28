import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
    const Locale('ru'),
    const Locale('it'),
    const Locale('fr'),
    const Locale('tr'),
    const Locale('de'),
    const Locale('hi'),
    const Locale('ja'),
    const Locale('ko'),
    const Locale('pt')
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'es':
        return 'Español 🇪🇸';
      case 'ru':
        return 'Русский 🇷🇺';
      case 'it':
        return 'Italiana 🇮🇹';
      case 'fr':
        return 'Français 🇫🇷';
      case 'tr':
        return 'Türk 🇹🇷';
      case 'de':
        return 'Dustch 🇩🇪';
      case 'hi':
        return 'हिन्दी 🇮🇳';
      case 'ja':
        return '日本語 🇯🇵 ';
      case 'ko':
        return '한국어 🇰🇷';
      case 'pt':
        return 'Português 🇵🇹';
      case 'en':
      default:
        return 'English 🇺🇸';
    }
  }
}
