import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/screens/providers/cart_provider.dart';
import 'package:myapp/screens/providers/order_provider.dart';
import 'package:provider/provider.dart';

class ModalSheetPay extends StatefulWidget {
  final ScrollController scrollController;
  const ModalSheetPay({super.key, required this.scrollController});

  @override
  State<ModalSheetPay> createState() => _ModalSheetPayState();
}

class _ModalSheetPayState extends State<ModalSheetPay> {
  Set<String> selected = {'Qr'};
  void updateSelected(Set<String> method) {
    setState(() {
      selected = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final cartProvider = context.watch<CartProvider>();
    orderProvider.currentOrder.paymentMethod = selected.first;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(27)),

      child: ListView(
        controller: widget.scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Seleccione el método de pago',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderProvider.currentOrder.orderDetails.length,
            itemBuilder: (context, index) {
              final detail = orderProvider.currentOrder.orderDetails[index];
              final product = cartProvider.cart[index];
              return ListTile(
                title: Text(
                  '${detail.quantity}x ${product.product.name.toLowerCase()} ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '${(product.product.price * detail.quantity).toStringAsFixed(2)} Bs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Precio unitario: ${product.product.price.toStringAsFixed(2)} Bs',
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              // Calculate total price
              '\$${cartProvider.totalPrice.toStringAsFixed(2)} Bs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pagar con',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              segments: [
                ButtonSegment(
                  value: 'Qr',
                  label: Text('QR Code'),
                  icon: Icon(Icons.qr_code_scanner),
                ),
                ButtonSegment(
                  value: 'Wallet',
                  label: Text('Efectivo'),
                  icon: Icon(Icons.account_balance_wallet),
                ),
              ],
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.fromMap({
                  WidgetState.selected: AppContessa.contessa200,
                  WidgetState.disabled: AppContessa.contessa50,
                }),
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: AppContessa.contessa950),
                ),
              ),
              selected: selected,
              onSelectionChanged: updateSelected,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppContessa.contessa500,
                foregroundColor: AppContessa.contessa50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Handle payment action
                Navigator.pushNamed(context, '/pay');
              },
              child: Text(
                'Paga ahora ${cartProvider.totalPrice.toStringAsFixed(2)} Bs',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
