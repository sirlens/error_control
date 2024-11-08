import 'package:error_control/data/control.dart';
import 'package:error_control/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  UserState _state = UserState.initial();
  UserState get state => _state;

  UserProvider(this.getUserUseCase);

  Future<void> loadUser(String userId) async {
    try {
      _state = UserState.loading();
      notifyListeners();

      final result = await getUserUseCase.execute(userId);

      if (result.isSuccess && result.data != null) {
        _state = UserState.loaded(result.data!);
      } else {
        _state = UserState.error(result.error!.message);
      }
    } catch (e) {
      _state = UserState.error('Error inesperado: $e');
    }

    notifyListeners();
  }
}
class UserState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  UserState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  factory UserState.initial() => UserState();
  factory UserState.loading() => UserState(isLoading: true);
  factory UserState.loaded(UserModel user) => UserState(user: user);
  factory UserState.error(String message) => UserState(error: message);
}