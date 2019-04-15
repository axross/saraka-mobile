import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './card_list_route.dart';
import './introduction_route.dart';
import './review_route.dart';
import './dashboard_route.dart';

class SignedInNavigator extends StatefulWidget {
  SignedInNavigator({
    Key key,
    @required this.cardList,
    @required this.introduction,
    @required this.review,
    @required this.dashboard,
  })  : assert(cardList != null),
        assert(introduction != null),
        assert(review != null),
        assert(dashboard != null),
        super(key: key);

  final Widget cardList;

  final Widget introduction;

  final Widget review;

  final Widget dashboard;

  @override
  State<SignedInNavigator> createState() => _SignedInNavigatorState();
}

class _SignedInNavigatorState extends State<SignedInNavigator>
    implements WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() async {
    assert(mounted);

    final NavigatorState navigator = _navigatorKey.currentState;

    return await navigator.maybePop();
  }

  @override
  Future<bool> didPushRoute(String route) async {
    assert(mounted);

    final NavigatorState navigator = _navigatorKey.currentState;

    navigator.pushNamed(route);

    return true;
  }

  @override
  void didChangeLocales(List<Locale> locales) {}

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  void didChangeTextScaleFactor() {
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, authenticationBloc) => StreamBuilder<User>(
              stream: authenticationBloc.user,
              initialData: authenticationBloc.user.value,
              builder: (context, snapshot) => Navigator(
                    key: _navigatorKey,
                    onGenerateRoute: (settings) {
                      switch (settings.name) {
                        case "/":
                          if (snapshot.requireData.isNew) {
                            return IntroductionRoute(
                              settings: settings,
                              child: widget.introduction,
                            );
                          }

                          return DashboardRoute(
                            settings: settings,
                            child: widget.dashboard,
                          );
                        case "/study":
                          return ReviewRoute(
                            settings: settings,
                            child: widget.review,
                          );
                        case "/cards":
                          return CardListRoute(
                            settings: settings,
                            child: widget.cardList,
                          );
                      }
                    },
                    initialRoute: "/",
                  ),
            ),
      );
}
