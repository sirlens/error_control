import 'package:error_control/data/control.dart';
import 'package:error_control/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final apiClient = ApiClient();
  final localDb = LocalDatabase();
  final repository = UserRepositoryImpl(apiClient, localDb);
  final useCase = GetUserUseCase(repository);
  final provider = UserProvider(useCase);

  runApp(
    ChangeNotifierProvider(
      create: (_) => provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error Control Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const UserScreen(),
    );
  }
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario'),
        actions: [
          // Añadimos un botón para probar la carga
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserProvider>().loadUser('');
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return CustomErrorWidget(
              mensaje: _getErrorMessage(state.error!),
              onRetry: () => provider.loadUser(''),
            );
          }

          if (state.user != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${state.user!.name}'),
                  Text('Email: ${state.user!.email}'),
                  Text('Display: ${state.user!.displayName}'),
                ],
              ),
            );
          }

          return const Center(child: Text('No hay datos'));
        },
      ),
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('NetworkFailure')) {
      return 'No hay conexión a Internet. Por favor, verifica tu conexión.';
    }
    if (error.contains('ServerFailure')) {
      return 'Error del servidor. Por favor, intenta más tarde.';
    }
    if (error.contains('CacheFailure')) {
      return 'No se encontraron datos guardados.';
    }
    return error;
  }
}

// Renombramos ErrorWidget a CustomErrorWidget para evitar conflictos
class CustomErrorWidget extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.mensaje,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ],
      ),
    );
  }
}