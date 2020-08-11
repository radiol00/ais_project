import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';

class ExpandableTile extends StatefulWidget {
  ExpandableTile({this.title, this.child});
  final String title;
  final Widget child;
  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool isExpanded = false;
  GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          trailing: isExpanded
              ? Icon(
                  Icons.keyboard_arrow_up,
                  color: Palette.aisred,
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: Palette.aisred,
                ),
          title: Center(child: Text(widget.title)),
        ),
        AnimatedContainer(
          onEnd: () {
            Scrollable.ensureVisible(context,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          },
          duration: Duration(milliseconds: 300),
          height: isExpanded ? 100 : 0,
          child: Center(
            child: SingleChildScrollView(
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }
}
