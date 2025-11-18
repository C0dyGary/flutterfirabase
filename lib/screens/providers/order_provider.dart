import 'package:flutter/material.dart';
import 'package:myapp/domain/order.dart';

class OrderProvider extends ChangeNotifier {
  final Order _currentOrder;
  OrderProvider(this._currentOrder);
  Order get currentOrder => _currentOrder;

  void setData(Order order) {
    _currentOrder.name = order.name;
    _currentOrder.status = order.status;
    _currentOrder.paymentMethod = order.paymentMethod;
    notifyListeners();
  }

  void addOrderDetail(OrderDetail orderDetail) {
    _currentOrder.orderDetails.add(orderDetail);
    notifyListeners();
  }

  void removeOrderDetail(OrderDetail orderDetail) {
    _currentOrder.orderDetails.remove(orderDetail);
    notifyListeners();
  }

  void clearOrder() {
    _currentOrder.orderDetails.clear();
    _currentOrder.name = '';
    _currentOrder.status = 'Pending';
    _currentOrder.paymentMethod = '';
    notifyListeners();
  }
}
