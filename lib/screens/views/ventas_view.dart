import 'package:flutter/material.dart';
import 'package:myapp/repository/repository.dart';
import 'package:myapp/domain/order_response.dart';
import 'package:intl/intl.dart';

class VentasView extends StatefulWidget {
  const VentasView({super.key});

  @override
  State<VentasView> createState() => _VentasViewState();
}

enum PeriodType { day, month, year }

class _VentasViewState extends State<VentasView> {
  final Repository _repository = Repository();
  late DateTime _selectedDate;
  List<Data> _orders = [];
  bool _isLoading = true;
  PeriodType _periodType = PeriodType.day;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    try {
      final allOrders = await _repository.listOrders();

      List<Data> filteredOrders;
      switch (_periodType) {
        case PeriodType.day:
          filteredOrders = allOrders.where((order) {
            final orderDate = order.createdAt.toLocal();
            return orderDate.year == _selectedDate.year &&
                orderDate.month == _selectedDate.month &&
                orderDate.day == _selectedDate.day;
          }).toList();
          break;
        case PeriodType.month:
          filteredOrders = allOrders.where((order) {
            final orderDate = order.createdAt.toLocal();
            return orderDate.year == _selectedDate.year &&
                orderDate.month == _selectedDate.month;
          }).toList();
          break;
        case PeriodType.year:
          filteredOrders = allOrders.where((order) {
            final orderDate = order.createdAt.toLocal();
            return orderDate.year == _selectedDate.year;
          }).toList();
          break;
      }

      setState(() {
        _orders = filteredOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar órdenes: $e')));
      }
    }
  }

  double get _totalVentas {
    return _orders.fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  double get _ventasQR {
    final ordersQR = _orders.where((order) {
      final method = order.paymentMethod.toLowerCase();
      return method == 'qr';
    }).toList();

    return ordersQR.fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  double get _ventasEfectivo {
    final ordersEfectivo = _orders.where((order) {
      final method = order.paymentMethod.toLowerCase();
      return method == 'efectivo' ||
          method == 'transferencia' ||
          method == 'tarjeta' ||
          method == 'wallet';
    }).toList();

    return ordersEfectivo.fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  String _getPercentageChange(double amount) {
    if (_totalVentas == 0) return '+0%';
    final percentage = (amount / _totalVentas * 100).toStringAsFixed(0);
    return '+$percentage%';
  }

  bool _isCurrentPeriod() {
    final now = DateTime.now();
    switch (_periodType) {
      case PeriodType.day:
        return _selectedDate.year == now.year &&
            _selectedDate.month == now.month &&
            _selectedDate.day == now.day;
      case PeriodType.month:
        return _selectedDate.year == now.year &&
            _selectedDate.month == now.month;
      case PeriodType.year:
        return _selectedDate.year == now.year;
    }
  }

  String _getPeriodLabel() {
    switch (_periodType) {
      case PeriodType.day:
        return _isCurrentPeriod()
            ? 'Hoy, ${DateFormat('dd \'de\' MMMM', 'es').format(_selectedDate)}'
            : DateFormat('EEEE, dd \'de\' MMMM', 'es').format(_selectedDate);
      case PeriodType.month:
        return _isCurrentPeriod()
            ? 'Este mes, ${DateFormat('MMMM yyyy', 'es').format(_selectedDate)}'
            : DateFormat('MMMM yyyy', 'es').format(_selectedDate);
      case PeriodType.year:
        return _isCurrentPeriod()
            ? 'Este año, ${_selectedDate.year}'
            : '${_selectedDate.year}';
    }
  }

  Future<void> _selectPeriod(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Por Día'),
              selected: _periodType == PeriodType.day,
              onTap: () {
                Navigator.pop(context);
                setState(() => _periodType = PeriodType.day);
                _selectDate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_month),
              title: const Text('Por Mes'),
              selected: _periodType == PeriodType.month,
              onTap: () {
                Navigator.pop(context);
                setState(() => _periodType = PeriodType.month);
                _selectMonth(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Por Año'),
              selected: _periodType == PeriodType.year,
              onTap: () {
                Navigator.pop(context);
                setState(() => _periodType = PeriodType.year);
                _selectYear(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      final normalizedDate = DateTime(picked.year, picked.month, picked.day);
      setState(() => _selectedDate = normalizedDate);
      _loadOrders();
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      final normalizedDate = DateTime(picked.year, picked.month, 1);
      setState(() => _selectedDate = normalizedDate);
      _loadOrders();
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Año'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: DateTime.now().year - 2020 + 1,
            itemBuilder: (context, index) {
              final year = DateTime.now().year - index;
              return ListTile(
                title: Text('$year'),
                selected: year == _selectedDate.year,
                onTap: () => Navigator.pop(context, year),
              );
            },
          ),
        ),
      ),
    );
    if (picked != null) {
      final normalizedDate = DateTime(picked, 1, 1);
      setState(() => _selectedDate = normalizedDate);
      _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y calendario
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Panel de Ventas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                          onPressed: () => _selectPeriod(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Fecha/Período
                    Text(
                      _getPeriodLabel(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _periodType == PeriodType.day
                          ? 'Total de Ventas del Día'
                          : _periodType == PeriodType.month
                          ? 'Total de Ventas del Mes'
                          : 'Total de Ventas del Año',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),

                    // Total de ventas
                    Text(
                      '\$${_totalVentas.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tarjetas de ventas por método
                    Row(
                      children: [
                        Expanded(
                          child: _buildSalesCard(
                            icon: Icons.qr_code,
                            iconColor: Colors.orange,
                            title: 'Ventas por\nQR',
                            amount: _ventasQR,
                            percentage: _getPercentageChange(_ventasQR),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSalesCard(
                            icon: Icons.payments_outlined,
                            iconColor: Colors.orange,
                            title: 'Ventas en\nEfectivo',
                            amount: _ventasEfectivo,
                            percentage: _getPercentageChange(_ventasEfectivo),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Actividad reciente
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de transacciones
                    ..._orders.reversed.take(10).map((order) {
                      return _buildTransactionItem(order);
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSalesCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double amount,
    required String percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Data order) {
    final method = order.paymentMethod.toLowerCase();
    final isQR = method == 'qr';
    final time = DateFormat('HH:mm').format(order.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isQR ? Icons.qr_code : Icons.payments_outlined,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isQR ? 'Pago con QR' : 'Pago en Efectivo',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Text(
            '+\$${order.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
