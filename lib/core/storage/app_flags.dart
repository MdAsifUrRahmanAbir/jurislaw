import 'cache_policy.dart';
import 'local_cache_service.dart';

const _onboardingDoneKey = 'onboarding_done';
const _foreverTtl = Duration(days: 3650);

/// One-off completion flags that need to survive app restarts and don't
/// belong to any single feature (checked by splash before every feature
/// screen exists yet). Small enough to not warrant a Notifier of its own —
/// callers just read/write directly where the decision is made.
class AppFlags {
  AppFlags._();

  static bool isOnboardingDone(LocalCacheService cache) =>
      cache.read<bool>(_onboardingDoneKey, CacheSensitivity.standard, (json) => json['v'] as bool) ?? false;

  static Future<void> setOnboardingDone(LocalCacheService cache) => cache.write<bool>(
        _onboardingDoneKey,
        true,
        CachePolicy.standard(ttl: _foreverTtl),
        (v) => {'v': v},
      );
}
