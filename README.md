Language: [English](README.md) | [中文简体](README.md)

# Dynamic List View
  
[![License][license-image]][license-url] 
[![Pub](https://img.shields.io/pub/v/dynamic_list_view.svg?style=flat-square)](https://pub.dartlang.org/packages/dynamic_list_view)

A list component that can refreshes and adds more data for Flutter App. 🚀

[github](https://github.com/leyan95/dynamic_list_view)

![Dynamic List View](https://upload-images.jianshu.io/upload_images/3646846-c2ecb2db27600296.gif?imageMogr2/auto-orient/strip|imageView2/2/w/216/format/webp)


## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
 dynamic_list_view: ^0.2.1
```

## Usage example
```dart
import 'package:dynamic_list_view/dynamic_list.dart';
import 'package:flutter/material.dart';

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
          child: DynamicList.build(
            controller: _dynamicListController,
            itemBuilder: _itemBuilder,
            dataRequester: _dataRequester,
            initRequester: _initRequester,
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
```

## Contribute

We would ❤️ to see your contribution!

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

## About

Created by Shusheng.

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
