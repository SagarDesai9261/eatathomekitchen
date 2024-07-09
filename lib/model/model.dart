class Review {
  final int id;
  final String review;
  final String rate;
  final int userId;
  final int restaurantId;
  final String createdAt;
  final String updatedAt;
  final User user;
  Review({
    required this.id,
    required this.review,
    required this.rate,
    required this.userId,
    required this.restaurantId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],

      rate: json['rate'],
      userId: json['user_id'],
      restaurantId: json['restaurant_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      review: json['review'],
      user: User.fromJson(json['user'])
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final List<Media> media;
/*
  final String phone;
  final String address;
*/
 // final List<String> mediaUrls;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.media,
/*    required this.phone,
    required this.address,*/
   // required this.mediaUrls,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Media> media = [];
    if (json['media'] != null) {
      //print(json);
      media = List<Media>.from(
        json['media'].map((mediaJson) => Media.fromJson(mediaJson)),
      );
    }

    /*List<String> mediaUrls = json['media'] != null
        ? List<String>.from(json['media'].map((media) => media['url']))
        : [];
*/
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
     /* phone: json['custom_fields']['phone']['value'],
      address: json['custom_fields']['address']['value'],*/
      media: media,
    //  mediaUrls: mediaUrls,
    );
  }
}
class DataModel {
  final Map<String, dynamic> counter;
  final List<Review> reviews;
  DataModel({
    required this.counter,
    required this.reviews,
  });
  factory DataModel.fromJson(Map<String, dynamic> json) {
    List<Review> reviews = [];
    if (json['reviews'] != null) {
      reviews = List<Review>.from(
        json['reviews'].map((review) => Review.fromJson(review)),
      );
    }
    return DataModel(
      counter: json['counter'],
      reviews: reviews,
    );
  }
}

class Media {
  final int id;
  final String url;
  final String thumbUrl;
  final String iconUrl;

  Media({
    required this.id,
    required this.url,
    required this.thumbUrl,
    required this.iconUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      url: json['url'],
      thumbUrl: json['thumb'],
      iconUrl: json['icon'],
    );
  }
}