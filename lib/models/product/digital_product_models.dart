import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';

class DigitalProduct {
  DigitalProduct({
    required this.uid,
    required this.name,
    required this.attribute,
    required this.price,
    required this.shortDescription,
    required this.description,
    required this.featuredImage,
    required this.url,
    required this.store,
    required this.customInfo,
    required this.clubPoint,
    this.active = true,
  });

  factory DigitalProduct.fromJson(String source) =>
      DigitalProduct.fromMap(json.decode(source));

  factory DigitalProduct.fromMap(Map<String, dynamic> map) {
    return DigitalProduct(
      attribute: _parseAttribute(map),
      description: map['description'] ?? '',
      featuredImage: map['featured_image'] ?? '',
      name: map['name'] ?? '',
      price: intFromAny(map['price']),
      shortDescription: map['short_description'],
      uid: map['uid'] ?? '',
      url: map['url'] ?? '',
      store: map['seller'] == null ? null : StoreModel.fromMap(map['seller']),
      customInfo: _getCustomInfo(map['custom_information']),
      clubPoint: map.parseNum('club_point'),
      active: map.parseBool('active', true),
    );
  }

  final Map<String, Attribute> attribute;
  final Map<String, CustomInfo> customInfo;
  final String description;
  final String featuredImage;
  final String name;
  final int price;
  final String? shortDescription;
  final StoreModel? store;
  final String uid;
  final String url;
  final num clubPoint;
  final bool active;

  Map<String, dynamic> toMap() {
    return {
      'attribute': attribute.map((key, value) => MapEntry(key, value.toMap())),
      'description': description,
      'featured_image': featuredImage,
      'name': name,
      'price': price,
      'short_description': shortDescription,
      'uid': uid,
      'url': url,
      'seller': store?.toMap(),
      'custom_information': customInfo.map((k, v) => MapEntry(k, v.toMap())),
      'club_point': clubPoint,
      'active': active,
    };
  }

  String toJson() => json.encode(toMap());

  static Map<String, CustomInfo> _getCustomInfo(dynamic data) {
    if (data is! Map) return {};

    Map<String, CustomInfo> fieldMap = {};

    Map<String, Map<String, dynamic>>.from(data)
        .forEach((key, value) => fieldMap[key] = CustomInfo.fromMap(value));

    return fieldMap;
  }

  static Map<String, Attribute> _parseAttribute(Map<String, dynamic> map) {
    Map<String, Attribute> attributeMap = {};
    Map<String, Map<String, dynamic>>.from(map['attribute'])
        .forEach((key, value) => attributeMap[key] = Attribute.fromMap(value));

    return attributeMap;
  }
}

class Attribute {
  Attribute({
    required this.price,
    required this.productId,
    required this.shortDetails,
    required this.uid,
  });

  factory Attribute.fromJson(String source) =>
      Attribute.fromMap(json.decode(source));

  factory Attribute.fromMap(Map<String, dynamic> map) {
    return Attribute(
      productId: intFromAny(map['product_id']),
      price: intFromAny(map['price']),
      shortDetails: map['short_details'],
      uid: map['uid'] ?? '',
    );
  }

  final int price;
  final int productId;
  final String? shortDetails;
  final String uid;

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'price': price,
        'short_details': shortDetails,
        'uid': uid,
      };

  String toJson() => json.encode(toMap());
}
