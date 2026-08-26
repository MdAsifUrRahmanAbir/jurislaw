import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/locale_controller.dart';

class LanguageSelectionController extends Notifier<void> {
  @override
  void build() {}

  Future<void> selectLocale(Locale locale) => ref.read(localeControllerProvider.notifier).setLocale(locale);
}

final languageSelectionControllerProvider =
    NotifierProvider<LanguageSelectionController, void>(LanguageSelectionController.new);
