import 'package:dynamic_list_view/dynamic_list.dart';
import 'package:flutter/material.dart';
import 'custom_loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DynamicListController _dynamicListController = DynamicListController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          leading: Icon(Icons.accessibility, color: Colors.cyan),
          title: Text('Dynamic list', style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          child: DynamicList.separated(
            controller: _dynamicListController,
            itemBuilder: _itemBuilder,
            dataRequester: _dataRequester,
            initRequester: _initRequester,
            initLoadingWidget: CustomLoading(),
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: Colors.black54),
          ),
        ),
        persistentFooterButtons: <Widget>[
          MaterialButton(
              onPressed: () => this._dynamicListController.fireRefresh(),
              child: Icon(Icons.refresh)),
          MaterialButton(
              onPressed: () => this._dynamicListController.toTop(),
              child: Icon(Icons.vertical_align_top))
        ],
      ),
    );
  }

  Future<List> _initRequester() async {
    return Future.value(List.generate(15, (i) => i));
  }

  Future<List> _dataRequester() async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(10, (i) => 15 + i);
    });
  }

  final Function _itemBuilder =
      (List dataList, BuildContext context, int index) {
    String title = dataList[index].toString();
    return ListTile(title: Text("Number $title"));
  };
}
