import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

export 'package:saraka/entities.dart' show NewCardText;

class CardAdderBlocFactory {
  CardAdderBlocFactory({
    @required Authenticatable authenticatable,
    @required CardAddable cardAddable,
  })  : assert(authenticatable != null),
        assert(cardAddable != null),
        _authenticatable = authenticatable,
        _cardAddable = cardAddable;

  final Authenticatable _authenticatable;

  final CardAddable _cardAddable;

  CardAdderBloc create() => _CardAdderBloc(
        authenticatable: _authenticatable,
        cardAddable: _cardAddable,
      );
}

abstract class CardAdderBloc {
  ValueObservable<NewCardText> get text;

  ValueObservable<CardAddingState> get state;

  void setText(String text);

  void save();
}

class _CardAdderBloc implements CardAdderBloc {
  _CardAdderBloc({
    @required Authenticatable authenticatable,
    @required CardAddable cardAddable,
  })  : assert(authenticatable != null),
        assert(cardAddable != null),
        _authenticatable = authenticatable,
        _cardAddable = cardAddable;

  final Authenticatable _authenticatable;

  final CardAddable _cardAddable;

  final _text = BehaviorSubject<NewCardText>.seeded(_NewCardText(""));

  @override
  BehaviorSubject<NewCardText> get text => _text;

  final _state =
      BehaviorSubject<CardAddingState>.seeded(CardAddingState.initial);

  @override
  ValueObservable<CardAddingState> get state => _state;

  @override
  void setText(String newText) => _text.add(_NewCardText(newText));

  @override
  Future<void> save() async {
    assert(text.value.isValid);

    _state.add(CardAddingState.processing);

    try {
      await _cardAddable.add(
        user: _authenticatable.user.value,
        text: text.value,
      );
    } on CardDuplicationException catch (error) {
      _state.add(CardAddingState.failedByDuplication);

      return;
    } catch (error) {
      _state.add(CardAddingState.failedUnknown);

      return;
    }

    _state.add(CardAddingState.completed);
  }
}

enum CardAddingState {
  initial,
  processing,
  completed,
  failedUnknown,
  failedByDuplication,
}

mixin CardAddable {
  Future<void> add({@required User user, @required NewCardText text});
}

class _NewCardText extends NewCardText {
  _NewCardText(this.text) : assert(text != null);

  @override
  final String text;
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` is already existing.';
}
