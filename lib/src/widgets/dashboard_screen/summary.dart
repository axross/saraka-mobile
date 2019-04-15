import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import './card_maturity_donut_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Summary extends StatelessWidget {
  Summary({this.totalCardsNumber, this.todayLearnNumber, this.cardsMaturity})
      : assert(totalCardsNumber != null),
        assert(todayLearnNumber != null),
        assert(cardsMaturity != null);

  final String totalCardsNumber;

  final String todayLearnNumber;

  final List cardsMaturity;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 280.0,
                    width: 280.0,
                    child: CardMaturityDonutChart(
                      seriesList: <charts.Series<MatureCount, int>>[
                        charts.Series(
                          id: 'CardMaturity',
                          domainFn: (MatureCount matures, _) =>
                              matures.maturity,
                          measureFn: (MatureCount matures, _) =>
                              matures.maturity,
                          colorFn: (MatureCount matures, i) => matures.color,
                          data: [
                            new MatureCount(
                                "> 80%",
                                cardsMaturity
                                    .where((iter) => iter.maturity * 100 >= 80)
                                    .toList()
                                    .length,
                                Color.lerp(SarakaColors.lightYellow,
                                    SarakaColors.lightRed, 1.0)),
                            new MatureCount(
                                "50%",
                                cardsMaturity
                                    .where((iter) =>
                                        iter.maturity * 100 >= 50 &&
                                        iter.maturity * 100 < 80)
                                    .toList()
                                    .length,
                                Color.lerp(SarakaColors.lightYellow,
                                    SarakaColors.lightRed, 0.8)),
                            new MatureCount(
                                "30%",
                                cardsMaturity
                                    .where((iter) =>
                                        iter.maturity * 100 >= 30 &&
                                        iter.maturity * 100 < 50)
                                    .toList()
                                    .length,
                                Color.lerp(SarakaColors.lightYellow,
                                    SarakaColors.lightRed, 0.6)),
                            new MatureCount(
                                "30% <",
                                cardsMaturity
                                    .where((iter) => iter.maturity * 100 < 30)
                                    .toList()
                                    .length,
                                Color.lerp(SarakaColors.lightYellow,
                                    SarakaColors.lightRed, 0.5)),
                          ],
                          labelAccessorFn: (MatureCount row, _) =>
                              '${row.title}',
                          outsideLabelStyleAccessorFn: (MatureCount row, _) =>
                              charts.TextStyleSpec(
                                  color: charts.MaterialPalette.black),
                        ),
                      ],
                      animate: true,
                    ),
                  ),
                ),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      totalCardsNumber,
                      overflow: TextOverflow.ellipsis,
                      style: SarakaTextStyles.body.copyWith(fontSize: 48),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 60.0),
                        ),
                        Text(
                          'Cards',
                          overflow: TextOverflow.ellipsis,
                          style: SarakaTextStyles.body2.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'See card list',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  SarakaTextStyles.body.copyWith(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: SarakaColors.darkGray,
                            ),
                          ],
                        ),
                        onTap: () => Navigator.of(context).pushNamed('/cards'),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  todayLearnNumber + ' cards you study for today',
                  overflow: TextOverflow.ellipsis,
                  style: SarakaTextStyles.body.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                )
              ],
            ),
          ),
        ],
      );
}
