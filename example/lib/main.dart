import 'package:dynamic_list_view/DynamicListView.dart';
import 'package:dynamic_list_view_example/custom_loading.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amber),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(200, 200, 200, 0.1)),
          child: DynamicListView.build(
            itemBuilder: _itemBuilder,
            dataRequester: _dataRequester,
            initRequester: _initRequester,
            moreLoadingWidget: CustomLoading(),
            initLoadingWidget: CustomLoading(),
          ),
        ),
      ),
    );
  }

  Future<List> _initRequester() async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(15, (i) => i);
    });
  }

  Future<List> _dataRequester() async {
    return Future.delayed(Duration(seconds: 5), () {
      return List.generate(10, (i) => 15 + i);
    });
  }

  Function _itemBuilder = (List dataList, BuildContext context, int index) {
    String title = dataList[index].toString();
    return ListTile(title: Text("Number $title"));
  };
}
