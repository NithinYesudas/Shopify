class Product {
  late final String title;
  late final String description;
  late final String id;
  late final double price;
  late final String imageUrl;
  late String userId;
   late int quantity;
  late bool? isFavorite;
  late final String favId,cartId;
  Product({required this.title,required this.id,required this.description,this.userId='', required this.imageUrl, required this.price, this.isFavorite = false, this.quantity=1,this.favId='',this.cartId=''});

}
