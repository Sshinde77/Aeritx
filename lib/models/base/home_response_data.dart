import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';

class HomeResponseData {
  HomeResponseData({
    required this.banners,
    required this.categories,
    required this.brands,
    required this.todayDeals,
    required this.newArrival,
    required this.bestSelling,
    required this.campaigns,
    required this.digitalProducts,
    required this.suggestedProducts,
    required this.stores,
    required this.flash,
    required this.dynamicCategory,
  });

  factory HomeResponseData.fromJson(String source) =>
      HomeResponseData.fromMap(json.decode(source));

  factory HomeResponseData.fromMap(Map<String, dynamic> map) {
    // Normalize possible shapes of paged sections (direct data/pagination, nested products, etc.)
    Map<String, dynamic> paged(dynamic src) {
      try {
        if (src == null) return <String, dynamic>{'data': <dynamic>[]};

        // If backend returns a plain list (no pagination wrapper)
        if (src is List) return <String, dynamic>{'data': src};

        if (src is Map<String, dynamic>) {
          // Direct paged shape: { data: [...], pagination: {...} }
          final dataVal = src['data'];
          if (dataVal is List) return src;

          // Handle nested { "data": { "data": [...] } } shape
          if (dataVal is Map<String, dynamic>) {
            final innerData = dataVal['data'];
            if (innerData is List) {
              return <String, dynamic>{
                'data': innerData,
                if (dataVal['pagination'] != null)
                  'pagination': dataVal['pagination'],
              };
            }
            // Look for lists under alternate keys inside nested data
            const innerKeys = [
              'items',
              'list',
              'rows',
              'records',
              'result',
              'payload',
              'content',
              'products'
            ];
            for (final k in innerKeys) {
              final v = dataVal[k];
              if (v is List) return <String, dynamic>{'data': v};
            }
          }

          // Nested under common container keys
          Map<String, dynamic>? nestedMap;
          List<dynamic>? nestedList;

          final products = src['products'];
          if (products is Map<String, dynamic>) {
            nestedMap = products;
          } else if (products is List) {
            nestedList = products;
          }

          // Other common list keys used by various backends
          const listKeys = [
            'items',
            'list',
            'rows',
            'records',
            'result',
            'payload',
            'content'
          ];
          for (final k in listKeys) {
            if (nestedMap == null && src[k] is Map<String, dynamic>) {
              nestedMap = src[k] as Map<String, dynamic>;
            }
            if (nestedList == null && src[k] is List) {
              nestedList = src[k] as List;
            }
          }

          // If we found a nested list directly
          if (nestedList != null) {
            return <String, dynamic>{
              'data': nestedList,
              if (src['pagination'] != null) 'pagination': src['pagination'],
            };
          }

          // If we found a nested map, try to extract its list
          if (nestedMap != null) {
            final nmData = nestedMap['data'];
            if (nmData is List) {
              return <String, dynamic>{
                'data': nmData,
                if (nestedMap['pagination'] != null)
                  'pagination': nestedMap['pagination'],
              };
            }
            for (final k in listKeys) {
              final v = nestedMap[k];
              if (v is List) {
                return <String, dynamic>{
                  'data': v,
                  if (nestedMap['pagination'] != null)
                    'pagination': nestedMap['pagination'],
                };
              }
            }
          }

          // Last resort: find the first List value that looks like products
          for (final entry in src.entries) {
            final v = entry.value;
            if (v is List && v.isNotEmpty && v.first is Map) {
              return <String, dynamic>{'data': v};
            }
          }

          return <String, dynamic>{'data': <dynamic>[]};
        }

        return <String, dynamic>{'data': <dynamic>[]};
      } catch (e, s) {
        talk.error('HomeResponseData.paged error: $e', e, s);
        return <String, dynamic>{'data': <dynamic>[]};
      }
    }

    // Pre-parse New Arrivals so we can log the parsed length. Try alt keys too.
    final dynamic naSource = map['new_arrival'] ??
        map['new_arrivals'] ??
        map['new_products'] ??
        map['newProducts'] ??
        map['newArrival'] ??
        map['latest_products'] ??
        map['latestProducts'] ??
        map['latest'] ??
        map['new'];

    final naRaw = paged(naSource);
    final naItem =
        PagedItem<ProductsData>.fromMap(naRaw, (x) => ProductsData.fromMap(x));

    return HomeResponseData(
      banners: Banners.fromMap(map['banners']),
      categories: CategoriesBase.fromMap(map['categories']),
      brands: Brands.fromMap(map['brands']),
      todayDeals: PagedItem<ProductsData>.fromMap(
          paged(map['today_deals']), (x) => ProductsData.fromMap(x)),
      newArrival: naItem,
      bestSelling: PagedItem<ProductsData>.fromMap(
          paged(map['best_selling']), (x) => ProductsData.fromMap(x)),
      campaigns: PagedItem<CampaignModel>.fromMap(
          paged(map['campaigns']), (x) => CampaignModel.fromMap(x)),
      digitalProducts: PagedItem<DigitalProduct>.fromMap(
          paged(map['digital_product']), (x) => DigitalProduct.fromMap(x)),
      suggestedProducts: PagedItem<ProductsData>.fromMap(
          paged(map['suggested_products']), (x) => ProductsData.fromMap(x)),
      stores: PagedItem<StoreModel>.fromMap(
          paged(map['shops']), (x) => StoreModel.fromMap(x)),
      flash: map['flash_deals'] == null || map['flash_deals'].isEmpty
          ? null
          : FlashDeal.fromMap(map['flash_deals']),
      dynamicCategory: map['home_category'] == null
          ? []
          : List<CategoryDetails>.from(map['home_category']['data']
              .map((x) => CategoryDetails.fromMap(x))),
    );
  }

  final Banners banners;
  final Brands brands;
  final CategoriesBase categories;
  final FlashDeal? flash;
  final PagedItem<CampaignModel> campaigns;
  final PagedItem<ProductsData> bestSelling;
  final PagedItem<DigitalProduct> digitalProducts;
  final PagedItem<ProductsData> newArrival;
  final PagedItem<ProductsData> todayDeals;
  final PagedItem<ProductsData> suggestedProducts;
  final PagedItem<StoreModel> stores;
  final List<CategoryDetails> dynamicCategory;

  Map<String, dynamic> toMap() => {
        'banners': banners.toMap(),
        'categories': categories.toMap(),
        'brands': brands.toMap(),
        'today_deals': todayDeals.toMap((data) => data.toMap()),
        'new_arrival': newArrival.toMap((data) => data.toMap()),
        'best_selling': bestSelling.toMap((data) => data.toMap()),
        'campaigns': campaigns.toMap((data) => data.toMap()),
        'digital_product': digitalProducts.toMap((data) => data.toMap()),
        'suggested_products': suggestedProducts.toMap((data) => data.toMap()),
        'shops': stores.toMap((data) => data.toMap()),
        'flash_deals': flash?.toMap(),
        'home_category': {'data': dynamicCategory.map((data) => data.toMap())},
      };

  PagedItem? mappedForPaging(String? key) {
    final map = {
      CachedKeys.todaysProducts: todayDeals,
      CachedKeys.newProducts: newArrival,
      CachedKeys.bestSaleProducts: bestSelling,
      CachedKeys.campaigns: campaigns,
      CachedKeys.digitalProducts: digitalProducts,
      CachedKeys.suggestedProducts: suggestedProducts,
      CachedKeys.shops: stores,
    };
    return map[key];
  }

  bool get isTodaysDealNotEmpty => todayDeals.listData.isNotEmpty;
  bool get isNewArrivalNotEmpty => newArrival.listData.isNotEmpty;
  bool get isBestSellingNotEmpty => bestSelling.listData.isNotEmpty;
  bool get isCampaignsNotEmpty => campaigns.listData.isNotEmpty;
  bool get isDigitalProductsNotEmpty => digitalProducts.listData.isNotEmpty;
  bool get isSuggestedProductsNotEmpty => suggestedProducts.listData.isNotEmpty;
  bool get isStoresNotEmpty => stores.listData.isNotEmpty;
  bool get isSliderNotEmpty => banners.bannersData.isNotEmpty;
  bool get isCategoriesNotEmpty => categories.categoriesData.isNotEmpty;
  bool get isBrandsNotEmpty => brands.brandsData.isNotEmpty;
  bool get isFlashNotEmpty => flash != null;
}
