import 'dart:async';
import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talentpitch_test/feature/banner/bloc/banner_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  CarouselBannerState createState() => CarouselBannerState();
}

class CarouselBannerState extends State<CarouselBanner> {
  PageController controllerSlides = PageController(initialPage: 0);
  int currentPageSlideImages = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(const LoadBanners());
  }

  @override
  void dispose() {
    timer?.cancel();
    controllerSlides.dispose();
    super.dispose();
  }

  void _startAutoSlide(int length) {
    timer?.cancel();
    if (length <= 1) return;

    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentPageSlideImages < length - 1) {
        currentPageSlideImages++;
      } else {
        currentPageSlideImages = 0;
      }

      if (controllerSlides.hasClients) {
        controllerSlides.animateToPage(
          currentPageSlideImages,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.whitePure,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryMain,
              ),
            ),
          );
        }

        if (state.banners == null || state.banners!.isEmpty) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.whitePure,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.primaryMain.withOpacity(0.5),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No hay banners disponibles',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryDark.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final banners = state.banners!;

        // Start auto-slide once we have banners
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoSlide(banners.length);
        });

        return Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: PageView.builder(
                controller: controllerSlides,
                onPageChanged: (value) {
                  setState(() {
                    currentPageSlideImages = value;
                  });
                },
                physics: const BouncingScrollPhysics(),
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return _buildBannerCard(banner);
                },
              ),
            ),
            if (banners.length > 1)
              AppPageViewIndicator(
                length: banners.length,
                currentIndex: currentPageSlideImages,
                otherColor: AppColors.secondary,
                currentColor: AppColors.primaryMain,
              ),
          ],
        );
      },
    );
  }

  Widget _buildBannerCard(BannerModel banner) {
    final settings = banner.settings;
    final backgroundColor = settings?.backgroundColor != null
        ? _parseColor(settings!.backgroundColor!)
        : AppColors.primaryMain;
    final textColor = settings?.textColor != null
        ? _parseColor(settings!.textColor!)
        : AppColors.whitePure;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryMain.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (banner.imageUrl.isNotEmpty)
                Image.network(
                  banner.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: backgroundColor,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: backgroundColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.whitePure,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),

              // Overlay gradient for better text readability
              if ((settings?.showTitle == true ||
                      settings?.showDescription == true) &&
                  banner.imageUrl.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),

              // Text content
              if (settings?.showTitle == true ||
                  settings?.showDescription == true)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settings?.showTitle == true)
                        Text(
                          banner.title,
                          style: APTextStyle.textLG.bold.copyWith(
                            color: banner.imageUrl.isNotEmpty
                                ? AppColors.whitePure
                                : textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (settings?.showDescription == true &&
                          banner.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          banner.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: banner.imageUrl.isNotEmpty
                                ? AppColors.whitePure.withOpacity(0.9)
                                : textColor.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return AppColors.primaryMain;
    } catch (e) {
      return AppColors.primaryMain;
    }
  }
}
