import 'my_painter.dart';
import 'search_bar.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  DefaultAppBar({
    Key key,
    @required this.onCancelSearch,
    @required this.onSearchQueryChanged,
  }) : super(key: key);

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  AnimationController _controller;
  Animation _animation;
  bool isInSearchMode = false;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        isInSearchMode = true;
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    //print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancelSearch() {
    setState(() {
      isInSearchMode = false;
    });
    onSearchQueryChange('');
    _controller.reverse();

    widget.onCancelSearch;
  }

  onSearchQueryChange(String query) {
    widget.onSearchQueryChanged(query);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
        children: [
          GradientAppBar(
            title: new Text('Explore',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Raleway')),
            centerTitle: false,
            backgroundColorStart: FintnessAppTheme.grad[0],
            backgroundColorEnd: FintnessAppTheme.grad[1],
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: FintnessAppTheme.white,
                      size: 23,
                    ),
                  ),
                ),
                onTapUp: onSearchTapUp,
              ),

            ],
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: MyPainter(
                  containerHeight: widget.preferredSize.height,
                  center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                  radius: _animation.value * screenWidth,
                  context: context,
                ),
              );
            },
          ),

          isInSearchMode ? (
              SearchBar(
                onCancelSearch: cancelSearch,
                onSearchQueryChanged: onSearchQueryChange,
              )
          ) : (
              Container()
          )
        ]
    );
  }
}