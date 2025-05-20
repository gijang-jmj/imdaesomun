import 'package:flutter/material.dart';
import 'package:imdaesomun/src/ui/widgets/dev_tools/dev_tools.dart';

class DevToolsOverlay extends StatelessWidget {
  final Widget child;

  const DevToolsOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 90,
          right: 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.only(left: 8, right: 0, top: 8, bottom: 8),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed:
                () => showModalBottomSheet(
                  context: context,
                  builder: (context) => DevTools(),
                ),
            child: Icon(Icons.bug_report),
          ),
        ),
      ],
    );
  }
}
