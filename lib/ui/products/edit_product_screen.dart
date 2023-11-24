import 'package:flutter/material.dart';
import 'package:myshop/ui/products/products_manager.dart';
import 'package:myshop/ui/shared/dialog_utils.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        price: 0,
        description: '',
        imageUrl: '',
      );
    } else {
      this.product = product;
    }
  }

  late final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.id != null) {
        await productsManager.updateProduct(_editedProduct);
      } else {
        await productsManager.addProduct(_editedProduct);
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Đã xảy ra lỗi.');
      }
    }
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật sản phẩm'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
                Icons.check), // Thay biểu tượng "Lưu" bằng biểu tượng "Check"
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildTitleField(),
                    buildPriceField(),
                    buildDescriptionField(),
                    buildProductPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: InputDecoration(
        labelText: 'Tên sản phẩm',
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng cung cấp một giá trị';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }

  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: InputDecoration(
        labelText: 'Giá',
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập giá.';
        }
        if (double.tryParse(value) == null) {
          return 'Vui lòng nhập một số hợp lệ';
        }
        if (double.parse(value) <= 0) {
          return 'Vui lòng nhập số lớn hơn 0';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: InputDecoration(
        labelText: 'Miêu tả',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập mô tả.';
        }
        if (value.length < 10) {
          return 'Phải dài ít nhất 10 ký tự.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  Widget buildProductPreview() {
    return Column(
      children: <Widget>[
        CircleAvatar(
          // Thay hình vuông bằng hình tròn
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: _imageUrlController.text.isEmpty
              ? null
              : NetworkImage(_imageUrlController.text),
          child: _imageUrlController.text.isEmpty
              ? Icon(Icons.image, size: 40, color: Colors.grey)
              : null,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'URL hình ảnh',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập URL hình ảnh';
        }
        if (!_isValidImageUrl(value)) {
          return 'Vui lòng nhập URL hình ảnh hợp lệ.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }
}
