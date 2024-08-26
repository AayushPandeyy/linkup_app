import 'package:chatapp_flutter/models/User.dart';
import 'package:chatapp_flutter/services/AuthService.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();
  User? _user;
  bool isLoggedIn = false;

  User? get user => _user;
  bool? get isLogged => isLoggedIn;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getUser() async {
    _isLoading = true;
    try {
      _user = (await authService.getUser())!;
      isLoggedIn = true;
    } catch (err) {
      _errorMessage = 'Failed to load user: $err';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verify_token() async {
    _isLoading = true;
    try {
      Map<String, dynamic> result = await authService.verifyToken();
      if (result['valid'] == true) {
        isLoggedIn = true;
        await getUser();
      }
    } catch (err) {
      _errorMessage = 'Failed to verify token: $err';
      print(_errorMessage);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> register(String email, String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    try {
      String? token = await authService.register(email, username, password);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        isLoggedIn = true;
      }
    } catch (err) {
      _errorMessage = 'Failed to register user: $err';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    try {
      
      String? token = await authService.login(email, password);
      print("Token : $token");
      if (token != null) {
        _errorMessage = "Authenticated";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        isLoggedIn = true;
      } else {
        _errorMessage =
            'Invalid email or password.'; // Specific failure message
      }
    } catch (err) {
      _errorMessage =
          'Failed to login user: $err'; // This handles network or other exceptions
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners here, but make sure no further logic can overwrite the success message
    }
  }
}
