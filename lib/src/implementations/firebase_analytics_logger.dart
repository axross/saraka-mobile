import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

class FirebaseAnalyticsLogger
    implements CardReviewLoggable, SignInOutLoggable, SynthesizeLoggable {
  FirebaseAnalyticsLogger({@required FirebaseAnalytics firebaseAnalytics})
      : assert(firebaseAnalytics != null),
        _firebaseAnalytics = firebaseAnalytics;

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> logCardReview({ReviewCertainty certainty}) =>
      _firebaseAnalytics.logEvent(
        name: 'card_review',
        parameters: {
          "certainty": certainty.toString(),
        },
      );

  @override
  Future<void> logCardReviewUndo() =>
      _firebaseAnalytics.logEvent(name: 'card_review_undo');

  @override
  Future<void> logSignIn() => _firebaseAnalytics.logLogin();

  @override
  Future<void> logSignOut() => _firebaseAnalytics.logEvent(name: 'logout');

  @override
  Future<void> logReviewStart({int cardLength}) => _firebaseAnalytics.logEvent(
        name: 'review_start',
        parameters: {
          "card_length": cardLength,
        },
      );

  @override
  Future<void> logReviewEnd({
    int cardLength,
    int reviewedCardLength,
  }) =>
      _firebaseAnalytics.logEvent(
        name: 'review_end',
        parameters: {
          "card_length": cardLength,
          "reviewed_card_length": reviewedCardLength,
          "remaining_card_length": cardLength - reviewedCardLength,
        },
      );

  @override
  Future<void> logSynthesize({String text}) => _firebaseAnalytics.logEvent(
        name: 'synthesize',
        parameters: {
          "text": text,
        },
      );
}
