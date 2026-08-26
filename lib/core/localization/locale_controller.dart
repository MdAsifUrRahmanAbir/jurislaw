import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/cache_policy.dart';
import '../storage/local_cache_service.dart';

const _localeCacheKey = 'locale_code';
const _foreverTtl = Duration(days: 3650);

/// Holds the app's current [Locale] (en / bn) and persists the user's
/// explicit choice, mirroring core/theme/theme_controller.dart's shape.
/// Read it in main.dart to drive MaterialApp.router's `locale`, and update
/// it from the language-selection screen.
class LocaleController extends Notifier<Locale> {
  LocalCacheService get _cache => ref.read(localCacheServiceProvider);

  @override
  Locale build() {
    final cached = _readCachedCode();
    return cached != null ? Locale(cached) : const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _cache.write<String>(
      _localeCacheKey,
      locale.languageCode,
      CachePolicy.standard(ttl: _foreverTtl),
      (code) => {'code': code},
    );
  }

  /// Splash uses this (not [state], which always has a non-null default)
  /// to tell "never picked a language" apart from "picked English".
  bool hasChosenLocale() => _readCachedCode() != null;

  String? _readCachedCode() => _cache.read<String>(
        _localeCacheKey,
        CacheSensitivity.standard,
        (json) => json['code'] as String,
      );
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
