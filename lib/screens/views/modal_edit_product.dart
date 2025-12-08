import 'package:flutter/material.dart';
import 'package:myapp/domain/app_colors.dart';
import 'package:myapp/domain/products.dart';
import 'package:myapp/repository/productos.dart';

class ModalEditProduct extends StatefulWidget {
  final ScrollController scrollController;
  final Product? product;
  const ModalEditProduct({
    super.key,
    required this.scrollController,
    this.product,
  });

  @override
  State<ModalEditProduct> createState() => _ModalEditProductState();
}

class _ModalEditProductState extends State<ModalEditProduct> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  final _repository = ProductosRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    // Validar campos vacíos
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Por favor completa todos los campos'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Validar que el precio sea un número válido
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ El precio debe ser un número mayor a 0'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Validar que el stock sea un número válido
    final stock = int.tryParse(_stockController.text.trim());
    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ La cantidad debe ser un número entero mayor o igual a 0',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: widget.product?.id ?? 0,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        image: widget.product?.image ?? '',
        stock: stock,
      );

      if (widget.product == null) {
        await _repository.createProduct(product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Producto "${product.name}" creado exitosamente'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        await _repository.updateProduct(product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Producto "${product.name}" actualizado exitosamente',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Ha ocurrido un error inesperado';

        if (e.toString().contains('SocketException') ||
            e.toString().contains('NetworkException')) {
          errorMessage =
              'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
        } else if (e.toString().contains('FormatException')) {
          errorMessage =
              'Error en el formato de los datos. Verifica que todos los campos sean correctos.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage =
              'La solicitud ha tardado demasiado. Intenta nuevamente.';
        } else {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${widget.product?.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _repository.deleteProduct(widget.product!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Producto "${widget.product?.name}" eliminado'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Ha ocurrido un error inesperado.';

        if (e.toString().contains('SocketException') ||
            e.toString().contains('NetworkException')) {
          errorMessage =
              'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage =
              'La solicitud ha tardado demasiado. Intenta nuevamente.';
        } else if (e.toString().contains('404')) {
          errorMessage = 'El producto no existe o ya fue eliminado.';
        } else {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(26)),
        child: ListView(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: Text(
                    widget.product == null
                        ? 'Agregar Producto'
                        : 'Editar Producto',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 55),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppContessa.contessa500,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _saveProduct,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(widget.product == null ? 'Crear' : 'Guardar'),
                  ),
                ),
                if (widget.product != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isLoading ? null : _deleteProduct,
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
