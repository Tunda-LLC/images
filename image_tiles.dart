import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:influencer/views/colors.dart';

class ImageSlide extends StatefulWidget {
  ImageSlide(
      {@required this.width,
      @required this.v16,
      @required this.imagesLength,
      @required this.timerDuration,
      @required this.images,
      @required this.height});

  int timerDuration;
  int imagesLength;
  double width;
  double height;
  double v16;
  List<Widget> images;

  @override
  _ImageSlideState createState() => _ImageSlideState();
}

class _ImageSlideState extends State<ImageSlide> {
  int pageIndex = 0;
  Timer _timer;
  int _timerDuration = 7;
  int imagesLength = 3;
  double width;
  double height;
  double v16;
  List<Widget> images;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    v16 = widget.v16;
    width = widget.width;
    height = widget.height;
    imagesLength = widget.imagesLength;
    _timerDuration = widget.timerDuration;
    _timer = Timer.periodic(Duration(seconds: _timerDuration), _timerCallback);
    images = widget.images;
  }

  _timerCallback(Timer timer) {
    if (pageIndex < (imagesLength - 1)) {
      pageIndex++;
    } else {
      pageIndex = 0;
    }

    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(color: REAL_WHITE),
      height: height / 1.6,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onLongPressStart: (details) {
                setState(() {
                  _timer.cancel();
                });
              },
              onLongPressEnd: (details) {
                setState(() {
                  _timer = Timer.periodic(
                      Duration(seconds: _timerDuration), _timerCallback);
                });
              },
              child: PageView(
                controller: _pageController,
                children: images,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: v16 * 0.5,
            child: DotsIndicator(
              dotsCount: imagesLength,
              position: pageIndex.toDouble(),
              decorator: DotsDecorator(
                color: REAL_WHITE,
                activeColor: APP_BLACK,
                size: const Size.square(5.0),
                activeSize: const Size(10.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget CustomNetworkImage(String url) {
  return Image.network(
    url,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: Theme(
          data: ThemeData(primaryColor: APP_BLACK),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(APP_BLACK),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        ),
      );
    },
  );
}
