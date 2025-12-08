import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';

class MyLoginCoffeePage extends StatefulWidget {
  const MyLoginCoffeePage({super.key});

  @override
  State<MyLoginCoffeePage> createState() => _MyLoginCoffeePageState();
}

class _MyLoginCoffeePageState extends State<MyLoginCoffeePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Simple icon
                Icon(Icons.coffee, size: 64, color: AppContessa.contessa500),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Coffee House',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 48),

                // Username field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: const TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppContessa.contessa500,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppContessa.contessa500,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppContessa.contessa500,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
