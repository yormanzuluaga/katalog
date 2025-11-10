import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/auth/widget/ap_page_view_indicator.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ApCarouser extends StatefulWidget {
  const ApCarouser({Key? key}) : super(key: key);

  @override
  ApCarouserState createState() => ApCarouserState();
}

class ApCarouserState extends State<ApCarouser> {
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
          height: 400,
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
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/2.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/3.png'),
                    fit: BoxFit.fill,
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
            child: APPageViewIndicator(
              length: 3,
              currentIndex: currentPageSlideImages,
              otherColor: AppColors.whiteTechnical,
              currentColor: AppColors.whiteTechnical,
            ),
          ),
        ),
      ],
    );
  }
}
