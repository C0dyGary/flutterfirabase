import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/domain/order_response.dart';
import 'package:myapp/repository/repository.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/providers/order_provider.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late final Repository _repository;
  late final TextEditingController _nameController;

  bool _isProcessing = false;
  OrderResponse? _orderResponse;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = Repository();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleOrderCreation(
    OrderProvider orderProvider,
    CartProvider cartProvider,
  ) async {
    // Validación del nombre
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Por favor ingresa tu nombre');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Actualizar datos de la orden
      orderProvider.currentOrder.name = _nameController.text.trim();
      orderProvider.currentOrder.status = 'Pending';

      // Crear orden
      final response = await _repository.createOrder(
        orderProvider.currentOrder,
      );

      // Esperar un momento para mejor UX
      await Future.delayed(const Duration(seconds: 1));

      if (response.message == 'Successfully created Order') {
        setState(() {
          _orderResponse = response;
        });

        // Limpiar providers
        orderProvider.clearOrder();
        cartProvider.clearCart();

        // Mostrar éxito por 2 segundos antes de navegar
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _errorMessage = response.message;
          _isProcessing = false;
        });
        _showErrorSnackBar(_errorMessage!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: ${e.toString()}';
        _isProcessing = false;
      });
      _showErrorSnackBar(_errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        backgroundColor: AppContessa.contessa500,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _isProcessing
                ? _buildProcessingView()
                : _buildPaymentForm(orderProvider, cartProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    if (_orderResponse != null) {
      return _buildSuccessView();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppContessa.contessa500,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Procesando tu orden...',
            style: TextStyle(
              fontSize: 18,
              color: AppContessa.contessa700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 120,
            color: Colors.green.shade600,
          ),
          const SizedBox(height: 32),
          Text(
            '¡Orden Creada con Éxito!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppContessa.contessa950,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppContessa.contessa50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppContessa.contessa200),
            ),
            child: Column(
              children: [
                Text(
                  'Número de Orden',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppContessa.contessa600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _orderResponse!.data.id.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppContessa.contessa700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Redirigiendo a inicio...',
            style: TextStyle(fontSize: 14, color: AppContessa.contessa500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm(
    OrderProvider orderProvider,
    CartProvider cartProvider,
  ) {
    final totalPrice = cartProvider.totalPrice;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icono de pago
          Icon(Icons.payment_rounded, size: 80, color: AppContessa.contessa500),
          const SizedBox(height: 32),

          // Campo de nombre
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre del Cliente',
              labelStyle: TextStyle(
                fontSize: 16,
                color: AppContessa.contessa700,
              ),
              hintText: 'Ingresa tu nombre completo',
              prefixIcon: Icon(
                Icons.person_rounded,
                color: AppContessa.contessa500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppContessa.contessa300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppContessa.contessa300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppContessa.contessa500,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 32),

          // Card de resumen
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppContessa.contessa50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppContessa.contessa200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen de Pago',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppContessa.contessa950,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.credit_card_rounded,
                  label: 'Método de Pago',
                  value: orderProvider.currentOrder.paymentMethod,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.shopping_cart_rounded,
                  label: 'Productos',
                  value: '${cartProvider.cart.length}',
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total a Pagar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppContessa.contessa950,
                      ),
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(2)} Bs',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppContessa.contessa700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Botón de confirmar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppContessa.contessa500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: _isProcessing
                ? null
                : () => _handleOrderCreation(orderProvider, cartProvider),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded),
                const SizedBox(width: 8),
                Text(
                  'Confirmar Pago de ${totalPrice.toStringAsFixed(2)} Bs',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Botón de cancelar
          TextButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppContessa.contessa600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppContessa.contessa600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: AppContessa.contessa700),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppContessa.contessa950,
          ),
        ),
      ],
    );
  }
}
