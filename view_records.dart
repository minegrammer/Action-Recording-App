import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'login.dart';

class ViewRecords extends StatefulWidget {
  ViewRecords(this.userInfo);
  UserInfo userInfo;

  @override
  _ViewRecords createState() => _ViewRecords(userInfo);
}

class _ViewRecords extends State<ViewRecords> {

  _ViewRecords(this.userInfo);
  UserInfo userInfo;

  late final List<charts.Series<SheetData, DateTime>> seriesList ;
  final bool animate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記録の閲覧'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '記録を閲覧する',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 200,
              width:300,
              child: charts.TimeSeriesChart(
                _createSheetData(sheetList),
                animate: animate,
                defaultRenderer: charts.BarRendererConfig<DateTime>(),
                defaultInteractions: false,
                behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
              ),
              // .BarChart
              // .TimeSeriesChart
            ),
          ],
        ),
      ),
    );
  }
  final sheetList = <SheetData>[
    SheetData(DateTime(2022, 3, 1), 1),
    SheetData(DateTime(2022, 3, 2), 1),
    SheetData(DateTime(2022, 3, 3), 1),
    SheetData(DateTime(2022, 3, 6), 1),
    SheetData(DateTime(2022, 3, 7), 1),
    SheetData(DateTime(2022, 3, 8), 1),
    SheetData(DateTime(2022, 3, 13), 1),
    SheetData(DateTime(2022, 3, 14), 1),
    SheetData(DateTime(2022, 4, 14), 1),
  ];

  List<charts.Series<SheetData, DateTime>> _createSheetData(
      List<SheetData> sheetList) {
    return [
      charts.Series<SheetData, DateTime>(
        id: 'value',
        data: sheetList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (SheetData sheetData, _) => sheetData.date,
        measureFn: (SheetData sheetData, _) => sheetData.value,
      )
    ];
  }
}

class SheetData {
  final DateTime date;
  final double value;

  SheetData(this.date, this.value);
}




