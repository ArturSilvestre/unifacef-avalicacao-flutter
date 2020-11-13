class Product {
  int id;
  String name;
  int price;
  int quantity;
  String description;

  Product({this.id, this.name, this.price, this.quantity, this.description});

  // Inserir dados no BD, é preciso convertelo em um "MAP"
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "description": description,
      };

  // Receber os Dados necessarios para passar de MAP para JSON
  factory Product.fromMap(Map<String, dynamic> json) => new Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        description: json["description"],
      );
}
