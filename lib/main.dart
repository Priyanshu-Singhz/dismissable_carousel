import 'package:flutter/material.dart';

void main() {
  runApp(Carousel());
}

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController controller;
  int currentPage = 0;
  List<String> listItem = ['Page 1', 'Page 2', 'Page 3', 'Page 4'];

  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.5,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: PageView.builder(
              itemCount: listItem.length,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              controller: controller,
              itemBuilder: (BuildContext context, int index) =>
                  pageBuilder(index),
            ),
          ),
        ),
      ),
    );
  }

  pageBuilder(int index) {
    var dismissibleKey = GlobalKey<State>();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page! - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: dismissibleKey,
        direction: DismissDirection.up,
        onDismissed: (DismissDirection direction) {
          /// Remove item from List
          setState(() {
            listItem.removeAt(index);
          });
        },
        child: InkWell(
          onLongPress: () {
            debugPrint('Delete! $index');
            setState(() {
              listItem.removeAt(index);
            });
          },
          onTap: () {
            controller.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            // color: index % 2 == 0 ? Colors.blue : Colors.red,
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text('${listItem[index]}'),
            ),
          ),
        ),
      ),
    );
  }
}
