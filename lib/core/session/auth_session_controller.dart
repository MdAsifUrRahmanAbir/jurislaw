import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/cache_policy.dart';
import '../storage/secure_storage_service.dart';
import '../storage/local_cache_service.dart';
import 'app_user.dart';
import 'auth_session_state.dart';

const _currentUserCacheKey = 'current_user';

/// Single source of truth for "is someone logged in right now". Read this
/// from the splash flow to pick the initial route. Never duplicate a
/// token check anywhere else — everything routes through here.
class AuthSessionController extends Notifier<AuthSessionState> {
  SecureStorageService get _secureStorage => ref.read(secureStorageServiceProvider);
  LocalCacheService get _cache => ref.read(localCacheServiceProvider);
  ApiClient get _apiClient => ref.read(apiClientProvider);

  @override
  AuthSessionState build() => const AuthSessionState();

  /// Call once at startup. This only checks that a token exists locally —
  /// pair it with a lightweight `/auth/me` repository call if you need
  /// server-side validation (expired/revoked tokens), not just presence.
  Future<void> restoreSession() async {
    final token = await _secureStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    _apiClient.setAuthToken(token);
    final cachedUser = _cache.read<AppUser>(
      _currentUserCacheKey,
      CacheSensitivity.sensitive,
      AppUser.fromJson,
    );
    state = AuthSessionState(status: AuthStatus.authenticated, accessToken: token, user: cachedUser);
  }

  Future<void> onLoginSuccess({
    required String accessToken,
    String? refreshToken,
    AppUser? user,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    if (refreshToken != null) await _secureStorage.saveRefreshToken(refreshToken);
    _apiClient.setAuthToken(accessToken);
    if (user != null) await _cacheUser(user);
    state = AuthSessionState(status: AuthStatus.authenticated, accessToken: accessToken, user: user);
  }

  /// Update the cached profile after e.g. registration/edit-profile
  /// completes, without touching tokens.
  Future<void> updateUser(AppUser user) async {
    await _cacheUser(user);
    state = state.copyWith(user: user);
  }

  Future<void> _cacheUser(AppUser user) => _cache.write<AppUser>(
        _currentUserCacheKey,
        user,
        CachePolicy.sensitive(ttl: const Duration(days: 3650)),
        (u) => u.toJson(),
      );

  Future<void> logout() async {
    await _secureStorage.clearAuthTokens();
    _apiClient.setAuthToken(null);
    await _cache.clearOnLogout();
    state = const AuthSessionState(status: AuthStatus.unauthenticated);
  }
}

final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSessionState>(AuthSessionController.new);
