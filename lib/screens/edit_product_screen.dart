import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/packages/product_package.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void checkFocus() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  bool isLoading = false;

  Future<void> errorMessage() {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error occurred..!'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  void _saveForm() {
    final isValid = key.currentState!.validate();

    if (!isValid) {
      return;
    }

    key.currentState!.save();
  }

  var _newProduct =
      Product(title: '', id: '', description: '', imageUrl: '', price: 0);

  @override
  Widget build(BuildContext context) {
    final package = Provider.of<ProductProvider>(context, listen: false);

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    Product product = arg['product'];
    arg['title'] == 'Edit Product'
        ? _imageUrlController.text = product.imageUrl
        : 'a';

    final mediaquery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          arg['title'],
          style: TextStyle(fontFamily: 'dmsansbold'),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green[700],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: key,
                child: ListView(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                            title: value == null ? '' : value,
                            description: _newProduct.description,
                            id: product.id == ''
                                ? DateTime.now().toString()
                                : product.id,
                            imageUrl: _newProduct.imageUrl,
                            price: _newProduct.price);
                      },
                      initialValue: product.title,
                      decoration: InputDecoration(
                          helperText: 'Enter Product Title',
                          helperStyle: TextStyle(
                            fontFamily: 'dmsansregular',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 1, color: Colors.green),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                          labelText: 'Title',
                          hintText: 'Eg: Shoes',
                          labelStyle: TextStyle(fontFamily: 'dmsansregular')),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      initialValue: arg['title'] == 'Edit Product'
                          ? product.price.toString()
                          : null,
                      validator: (value) {
                        if (value!.isEmpty || double.tryParse(value) == null) {
                          return 'Please Enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid price';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                            title: _newProduct.title,
                            description: _newProduct.description,
                            id: product.id == ''
                                ? DateTime.now().toString()
                                : product.id,
                            imageUrl: _newProduct.imageUrl,
                            price: double.parse(value!));
                      },
                      decoration: InputDecoration(
                        helperText: 'Enter Product Price',
                        helperStyle: TextStyle(
                          fontFamily: 'dmsansregular',
                        ),
                        hintText: 'Eg: 9.99',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        labelText: 'Price',
                        labelStyle: TextStyle(
                          fontFamily: 'dmsansregular',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueGrey),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    TextFormField(
                      initialValue: product.description,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 12) {
                          return 'Description must be atleast 12 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                            title: _newProduct.title,
                            description: value == null ? '' : value,
                            id: product.id == ''
                                ? DateTime.now().toString()
                                : product.id,
                            imageUrl: _newProduct.imageUrl,
                            price: _newProduct.price);
                      },
                      decoration: InputDecoration(
                        helperText: 'Enter product description',
                        helperStyle: TextStyle(
                          fontFamily: 'dmsansregular',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontFamily: 'dmsansregular',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueGrey),
                        ),
                      ),
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: mediaquery.height * .2,
                          width: mediaquery.width * .35,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.orange)),
                          child: _imageUrlController.text.isEmpty ||
                                  (!_imageUrlController.text
                                          .startsWith('http') &&
                                      !_imageUrlController.text
                                          .startsWith('https'))
                              ? Center(child: Text('Enter valid image Url'))
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: mediaquery.width * .05,
                        ),
                        Expanded(
                            child: TextFormField(
                                onSaved: (value) {
                                  _newProduct = Product(
                                      title: _newProduct.title,
                                      description: _newProduct.description,
                                      id: product.id == ''
                                          ? DateTime.now().toString()
                                          : product.id,
                                      imageUrl: value == null ? '' : value,
                                      price: _newProduct.price);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Url';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid Url';
                                  }
                                  return null;
                                },
                                focusNode: _imageUrlFocusNode,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  helperText: 'Enter Image Url',
                                  helperStyle: TextStyle(
                                    fontFamily: 'dmsansregular',
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                  labelText: 'ImageUrl',
                                  labelStyle: TextStyle(
                                    fontFamily: 'dmsansregular',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blueGrey),
                                  ),
                                ),
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) async {
                                  print(_newProduct.title);
                                  _saveForm();
                                  if (key.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    if (arg['title'] == 'Edit Product') {
                                      try {
                                        await package.updateProduct(
                                            product, _newProduct);
                                      } catch (error) {
                                        errorMessage();
                                      } finally {
                                        isLoading = false;
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      try {
                                        await package.addProduct(_newProduct);
                                        //await package.fetchUserProducts();
                                      } catch (error) {
                                        await errorMessage();
                                      } finally {
                                        isLoading = false;
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }

                                  print(_newProduct.title);
                                }))
                      ],
                    ),
                    SizedBox(
                      height: mediaquery.height * .04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: 'dmsansbold',
                                fontSize: mediaquery.height * .025,
                                color: Colors.orange[700]),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print(_newProduct.title);
                            _saveForm();
                            if (key.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              if (arg['title'] == 'Edit Product') {
                                try {
                                  await package.updateProduct(
                                      product, _newProduct);
                                  //await package.fetchUserProducts();
                                } catch (error) {
                                  errorMessage();
                                } finally {
                                  isLoading = false;
                                  Navigator.of(context).pop();
                                }
                              } else {
                                try {
                                  await package.addProduct(_newProduct);
                                  //await package.fetchUserProducts();
                                } catch (error) {
                                  await errorMessage();
                                } finally {
                                  isLoading = false;
                                  Navigator.of(context).pop();
                                }
                              }
                            }

                            print(_newProduct.title);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.orange[700])),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaquery.width * .05),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'dmsansbold',
                                fontSize: mediaquery.height * .025,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
