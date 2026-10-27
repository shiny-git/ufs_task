class ProductModel {
  String image;
  String title;
  double price;

  ProductModel({required this.image, required this.price, required this.title});

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
      image: json['image'],
      price: json['price'],
      title: json['title'],
    );
  }
}
