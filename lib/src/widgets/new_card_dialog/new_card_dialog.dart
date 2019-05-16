import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_create_bloc.dart';
import './add_button.dart';
import './synthesize_button.dart';
import './word_input.dart';

@immutable
class NewCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Material(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          color: SarakaColors.white,
          elevation: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WordInput(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: SynthesizeButton(),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16, right: 16),
                      child: AddButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> _onWillPop(BuildContext context) async {
    final cardCreateBloc = Provider.of<CardCreateBloc>(context);

    return cardCreateBloc.state.value == CardAddingState.initial;
  }
}
