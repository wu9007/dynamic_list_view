Language: [English](README.md) | [中文简体](README.md)

# Dynamic List View
  
[![License][license-image]][license-url] 
[![Pub](https://img.shields.io/pub/v/dynamic_list_view.svg?style=flat-square)](https://pub.dartlang.org/packages/dynamic_list_view)

A list component that can refreshes and adds more data for Flutter App. 🚀

[github](https://github.com/leyan95/dynamic_list_view)

![qrscan.gif](https://upload-images.jianshu.io/upload_images/3646846-b94b988311342c74.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/320/format/webp)

## Usage example
```dart
import 'package:dynamic_list_view/DynamicListView.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(200, 200, 200, 0.1)),
          child: DynamicListView.build(
            itemBuilder: _itemBuilder,
            dataRequester: _dataRequester,
            initRequester: _initRequester,
          ),
        ),
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

  Function _itemBuilder = (List dataList, BuildContext context, int index) {
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
