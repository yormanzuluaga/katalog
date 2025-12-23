import 'package:equatable/equatable.dart';

class BannerResponse extends Equatable {
  const BannerResponse({
    required this.success,
    required this.total,
    required this.banners,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      success: json['success'] as bool? ?? false,
      total: json['total'] as int? ?? 0,
      banners: (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final bool success;
  final int total;
  final List<BannerModel> banners;

  Map<String, dynamic> toJson() => {
        'success': success,
        'total': total,
        'banners': banners.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [success, total, banners];
}

class BannerModel extends Equatable {
  const BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.isActive,
    required this.position,
    required this.startDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.action,
    this.settings,
    this.stats,
    this.endDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      type: json['type'] as String,
      isActive: json['isActive'] as bool? ?? false,
      position: json['position'] as int? ?? 0,
      startDate: json['startDate'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      action: json['action'] != null
          ? BannerAction.fromJson(json['action'] as Map<String, dynamic>)
          : null,
      settings: json['settings'] != null
          ? BannerSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
      stats: json['stats'] != null
          ? BannerStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      endDate: json['endDate'] as String?,
    );
  }

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final bool isActive;
  final int position;
  final String startDate;
  final String? endDate;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final BannerAction? action;
  final BannerSettings? settings;
  final BannerStats? stats;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'type': type,
        'isActive': isActive,
        'position': position,
        'startDate': startDate,
        'endDate': endDate,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'action': action?.toJson(),
        'settings': settings?.toJson(),
        'stats': stats?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        type,
        isActive,
        position,
        startDate,
        endDate,
        createdBy,
        createdAt,
        updatedAt,
        action,
        settings,
        stats,
      ];
}

class BannerAction extends Equatable {
  const BannerAction({
    required this.type,
    this.products,
    this.categoryId,
    this.url,
  });

  factory BannerAction.fromJson(Map<String, dynamic> json) {
    return BannerAction(
      type: json['type'] as String,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      categoryId: json['categoryId'] as String?,
      url: json['url'] as String?,
    );
  }

  final String type;
  final List<String>? products;
  final String? categoryId;
  final String? url;

  Map<String, dynamic> toJson() => {
        'type': type,
        'products': products,
        'categoryId': categoryId,
        'url': url,
      };

  @override
  List<Object?> get props => [type, products, categoryId, url];
}

class BannerSettings extends Equatable {
  const BannerSettings({
    this.backgroundColor,
    this.textColor,
    this.showTitle,
    this.showDescription,
  });

  factory BannerSettings.fromJson(Map<String, dynamic> json) {
    return BannerSettings(
      backgroundColor: json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      showTitle: json['showTitle'] as bool?,
      showDescription: json['showDescription'] as bool?,
    );
  }

  final String? backgroundColor;
  final String? textColor;
  final bool? showTitle;
  final bool? showDescription;

  Map<String, dynamic> toJson() => {
        'backgroundColor': backgroundColor,
        'textColor': textColor,
        'showTitle': showTitle,
        'showDescription': showDescription,
      };

  @override
  List<Object?> get props =>
      [backgroundColor, textColor, showTitle, showDescription];
}

class BannerStats extends Equatable {
  const BannerStats({
    this.views,
    this.clicks,
    this.lastViewed,
  });

  factory BannerStats.fromJson(Map<String, dynamic> json) {
    return BannerStats(
      views: json['views'] as int?,
      clicks: json['clicks'] as int?,
      lastViewed: json['lastViewed'] as String?,
    );
  }

  final int? views;
  final int? clicks;
  final String? lastViewed;

  Map<String, dynamic> toJson() => {
        'views': views,
        'clicks': clicks,
        'lastViewed': lastViewed,
      };

  @override
  List<Object?> get props => [views, clicks, lastViewed];
}
