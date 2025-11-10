import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CarouserProduct extends StatefulWidget {
  const CarouserProduct({super.key});

  @override
  CarouserProductState createState() => CarouserProductState();
}

class CarouserProductState extends State<CarouserProduct> {
  PageController controllerSlides = PageController(initialPage: 0);

  int currentPageSlideImages = 0;
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentPageSlideImages < 2) {
        currentPageSlideImages++;
      } else {
        currentPageSlideImages = 0;
      }
      if (currentPage == 0) {
        controllerSlides.animateToPage(
          currentPageSlideImages,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: PageView(
            controller: controllerSlides,
            onPageChanged: (value) {
              setState(() {
                currentPageSlideImages = value;
              });
            },
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.whitePure,
                    // image: const DecorationImage(
                    //   image: AssetImage('assets/img/1.png'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          color: AppColors.primaryMain,
                          size: 32,
                        ),
                        Text('producto 1')
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.whitePure,

                    // image: const DecorationImage(
                    //   image: AssetImage('assets/img/2.png'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          color: AppColors.primaryMain,
                          size: 32,
                        ),
                        Text('producto 2')
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.whitePure,

                    // image: const DecorationImage(
                    //   image: AssetImage('assets/img/3.png'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          color: AppColors.primaryMain,
                          size: 32,
                        ),
                        Text('producto 3')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: 32,
            child: AppPageViewIndicator(
              length: 3,
              currentIndex: currentPageSlideImages,
              otherColor: AppColors.primaryMain,
              currentColor: AppColors.primaryMain,
            ),
          ),
        ),
      ],
    );
  }
}
