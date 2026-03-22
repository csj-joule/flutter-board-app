import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  // TODO: Google Cloud Console에서 발급받은 macOS 클라이언트 ID로 교체하세요.
  // https://console.cloud.google.com → API 및 서비스 → 사용자 인증 정보
  static const String _clientId = 'YOUR_MACOS_CLIENT_ID.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _clientId,
    scopes: ['email', 'profile'],
  );

  GoogleSignInAccount? _user;
  bool _isLoading = false;
  String? _errorMessage;

  GoogleSignInAccount? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _trySilentSignIn();
  }

  /// 앱 시작 시 이전 로그인 세션 복원 시도
  Future<void> _trySilentSignIn() async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _googleSignIn.signInSilently();
    } catch (_) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Google 로그인
  Future<void> signIn() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final account = await _googleSignIn.signIn();
      _user = account;
    } catch (e) {
      _errorMessage = '로그인에 실패했습니다.\n다시 시도해주세요.';
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } finally {
      _user = null;
      notifyListeners();
    }
  }
}
