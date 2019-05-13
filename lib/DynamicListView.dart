import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 下拉刷新，上拉加载更多数据
class DynamicListView extends StatefulWidget {
  DynamicListView.build(
      {Key key,
      @required this.itemBuilder,
      @required this.dataRequester,
      @required this.initRequester})
      : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        super(key: key);

  final Function itemBuilder;
  final Function dataRequester;
  final Function initRequester;

  @override
  State createState() => new DynamicListViewState();
}

class DynamicListViewState extends State<DynamicListView> {
  bool isPerformingRequest = false;
  ScrollController _controller = new ScrollController();
  List _dataList;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this._dataList == null
        ? loadingProgress()
        : RefreshIndicator(
            onRefresh: this._onRefresh,
            backgroundColor: Colors.blue,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1.0, color: Colors.black54),
              itemCount: _dataList.length + 1,
              itemBuilder: (context, index) {
                if (index == _dataList.length) {
                  return opacityLoadingProgress(isPerformingRequest);
                } else {
                  return widget.itemBuilder(_dataList, context, index);
                }
              },
              controller: _controller,
            ),
          );
  }

  /// 刷新 数据初始化
  Future<Null> _onRefresh() async {
    List initDataList = await widget.initRequester();
    this.setState(() => this._dataList = initDataList);
    return;
  }

  /// 加载更多数据
  _loadMore() async {
    this.setState(() => isPerformingRequest = true);
    List newDataList = await widget.dataRequester();
    if (newDataList != null) {
      if (newDataList.length == 0) {
        double edge = 50.0;
        double offsetFromBottom =
            _controller.position.maxScrollExtent - _controller.position.pixels;
        if (offsetFromBottom < edge) {
          _controller.animateTo(_controller.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      } else {
        _dataList.addAll(newDataList);
      }
    }
    this.setState(() => isPerformingRequest = false);
  }
}

Widget loadingProgress() {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ),
  );
}

Widget opacityLoadingProgress(isPerformingRequest) {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    ),
  );
}
