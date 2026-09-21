// ignore_for_file: file_names

class Product {
  String image, title, category, description, sellerName;
  int id, price, sellerId, quantity;

  Product(
      {required this.image,
      required this.title,
      required this.id,
      required this.sellerId,
      required this.sellerName,
      required this.price,
      required this.category,
      required this.description,
      required this.quantity});
}
