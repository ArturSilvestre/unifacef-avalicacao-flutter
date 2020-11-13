import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:autopecas/model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductDatabaseProvider {
  ProductDatabaseProvider._();

  static final ProductDatabaseProvider db = ProductDatabaseProvider._();
  Database _database;

  // Evitar que abra varias conexoes.
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "product.db");
    var database = openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Product ("
          "id integer primary key,"
          "name TEXT,"
          "price TEXT,"
          "quantity TEXT,"
          "description TEXT"
          ")");
    });
    return await database;
  }

  //Query
  // Mostra todos os Produtos da base de dados
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    var response = await db.query("Product");
    List<Product> list = response.map((p) => Product.fromMap(p)).toList();
    return list;
  }

  //Query
  // Mostra um o Produto por ID da base de dados
  Future<Product> getProductWithId(int id) async {
    final db = await database;
    var response = await db.query("Product", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Product.fromMap(response.first) : null;
  }

  //Inserir Dados na base de dados.
  addProductToDatabase(Product product) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Product");
    int id = table.first["id"];
    product.id = id;
    var raw = await db.insert(
      "Product",
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete produto por ID
  deleteProductWithId(int id) async {
    final db = await database;
    return db.delete("Product", where: "id = ?", whereArgs: [id]);
  }

  //Delete todos Produtos
  deleteAllProduct() async {
    final db = await database;
    db.delete("Product");
  }

  //Update
  updateProduct(Product product) async {
    final db = await database;
    var response = await db.update("Product", product.toMap(),
        where: "id = ?", whereArgs: [product.id]);
    return response;
  }
}
