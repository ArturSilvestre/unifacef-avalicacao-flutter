import 'package:flutter/material.dart';
import 'package:autopecas/model/product_model.dart';
import 'package:autopecas/db/database.dart';

class AddEditProduct extends StatefulWidget {
  final bool edit;
  final Product product;

  AddEditProduct(this.edit, {this.product})
      : assert(edit == true || product == null);

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController quantityEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  set product(Product product) {}

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      nameEditingController.text = widget.product.name;
      descriptionEditingController.text = widget.product.description;
      priceEditingController.text = widget.product.price.toString();
      quantityEditingController.text = widget.product.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? "Editar Produto" : "Adicionar novo Produto"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: 300,
                ),
                textFormField(
                    nameEditingController,
                    "Nome produto",
                    "Informe com nome do produto",
                    Icons.grade,
                    widget.edit ? widget.product.name : "name"),
                textFormField(
                    descriptionEditingController,
                    "Descrição produto",
                    "Informe a descrição do produto",
                    Icons.description,
                    widget.edit ? widget.product.price : "description"),
                textFormField(
                    quantityEditingController,
                    "Quantidade produto",
                    "Informe a quantidade do produto",
                    Icons.loupe,
                    widget.edit ? widget.product.price : "quantity"),
                textFormField(
                    priceEditingController,
                    "Preço do produto",
                    "Informe o preço do produto",
                    Icons.attach_money,
                    widget.edit ? widget.product.price : "price"),
                RaisedButton(
                  color: Colors.green[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Salvar produto',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Carregando ....')));
                    } else if (widget.edit == true) {
                      product = new Product(
                          name: nameEditingController.text,
                          description: descriptionEditingController.text,
                          id: widget.product.id);
                      Navigator.pop(context);
                    } else {
                      await ProductDatabaseProvider.db
                          .addProductToDatabase(new Product(
                        name: nameEditingController.text,
                        description: descriptionEditingController.text,
                      ));
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFormField(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    var padding2 = Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor entrar apenas com letras';
          }
        },
        controller: t,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
    return padding2;
  }
}
