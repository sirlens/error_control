import 'package:error_control/results/failures.dart';
import 'package:error_control/models/user.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<Result<UserModel>> execute(String userId) async {

    if (userId.isEmpty) {
      return Result.failure(
        const ServerFailure('Credenciales vacias GAA'),
      );
    }

    final result = await repository.getUser(userId);

    if (result.isSuccess && result.data != null) {
      final userModel = UserModel.fromEntity(result.data!);
      return Result.success(userModel);
    }

    return Result.failure(result.error!);
  }
}


class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;
  final LocalDatabase localDb;

  UserRepositoryImpl(this.apiClient, this.localDb);

  @override
  Future<Result<User>> getUser(String id) async {
    try {
      // Intentar obtener de cache primero
      try {
        final localUser = await localDb.getUser(id);
        return Result.success(localUser);
      } on CacheException {
        // Si no está en cache, continuamos con API
      }

      final response = await apiClient.getUser(id);

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        // Guardar en cache
        await localDb.saveUser(user);
        return Result.success(user);
      } else {
        return Result.failure(
            ServerFailure('Error del servidor: ${response.statusCode}'));
      }
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure('Error inesperado: $e'));
    }
  }
}

abstract class UserRepository {
  Future<Result<User>> getUser(String id);
}






class ApiClient {
  Future<ApiResponse> getUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 350)); // Simulamos latencia

    final random = DateTime.now().microsecond % 2;
    
    switch (random) {
      case 0:
        return ApiResponse(200, {
          'id': id,
          'name': 'John Doe',
          'email': 'john@example.com',
        });
      case 1:
        throw NetworkException('No se pudo conectar al servidor');
      default:
        return ApiResponse(404, {'error': 'Usuario no encontrado'});
    }
  }
}

class LocalDatabase {
  final Map<String, User> _cache = {};

  Future<User> getUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final user = _cache[id];
    if (user != null) {
      return user;
    }
    throw CacheException('Usuario no encontrado en cache');
  }

  Future<void> saveUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cache[user.id] = user;
  }
}