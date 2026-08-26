import 'app_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthSessionState {
  final AuthStatus status;
  final String? accessToken;
  final AppUser? user;

  const AuthSessionState({this.status = AuthStatus.unknown, this.accessToken, this.user});

  AuthSessionState copyWith({AuthStatus? status, String? accessToken, AppUser? user}) {
    return AuthSessionState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      user: user ?? this.user,
    );
  }
}
