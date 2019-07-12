import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show IconButton;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class BackButton extends StatelessWidget {
  BackButton({Key key, @required this.controller})
      : assert(controller != null),
        super(key: key);

  final SwipableCardStackController controller;

  @override
  Widget build(BuildContext context) => Consumer<CardReviewBloc>(
        builder: (context, cardReviewBloc, _) => StreamBuilder(
              stream: cardReviewBloc.canUndo,
              initialData: cardReviewBloc.canUndo.value,
              builder: (context, snapshot) => IconButton(
                    icon: Icon(Feather.getIconData('corner-up-left')),
                    color: SarakaColors.white,
                    disabledColor: SarakaColors.darkGray,
                    onPressed:
                        snapshot.requireData ? () => _onPressed(context) : null,
                  ),
            ),
      );

  void _onPressed(BuildContext context) {
    Provider.of<CardReviewBloc>(context).undo();

    controller.previous();
  }
}