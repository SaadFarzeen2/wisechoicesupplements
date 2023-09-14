import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:flutter/material.dart';

class RecentChat extends StatelessWidget with ChatMixin {
  final double padHorizontal;
  const RecentChat({
    Key? key,
    this.padHorizontal = layoutPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(padHorizontal, 0, padHorizontal, itemPaddingMedium),
          child: Text(
            'Recent Chat',
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: padHorizontal),
            children: List.generate(6, (index) {
              double padEnd = index < 5 ? itemPaddingMedium : 0;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: padEnd),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ChatDetailScreen.routeName),
                  child: buildImage(context, size: 60),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
