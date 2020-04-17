import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget defaultLoadingWidget = SpinKitWave(
  size: 30,
  color: Colors.grey[350],
  duration: const Duration(milliseconds: 1000),
  itemCount: 7,
);

/// 下拉刷新，上拉加载更多数据
class DynamicList extends StatefulWidget {
  DynamicList.build({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        separated = false,
        super(key: key);

  DynamicList.separated({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.initLoadingWidget,
    this.moreLoadingWidget,
    this.controller,
    this.scrollDirection = Axis.vertical,
  })  : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        separated = true,
        super(key: key);

  final Function itemBuilder;
  final Function dataRequester;
  final Function initRequester;
  final Widget initLoadingWidget;
  final Widget moreLoadingWidget;
  final bool separated;
  final DynamicListController controller;
  final Axis scrollDirection;

  @override
  State createState() => new DynamicListState();
}

class DynamicListState extends State<DynamicList> {
  bool _isPerformingRequest = false;
  ScrollController _scrollController = new ScrollController();
  List _dataList;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
    if (this.widget.controller != null) {
      this.widget.controller.refresh = () => _onRefresh();
      this.widget.controller.scrollController = _scrollController;
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Theme.of(context).primaryColor;
    return this._dataList == null
        ? loadingProgress(
            loadingColor,
            initLoadingWidget: this.widget.initLoadingWidget,
          )
        : RefreshIndicator(
            displacement: 20,
            color: loadingColor,
            onRefresh: this._onRefresh,
            child: this.widget.separated
                ? ListView.separated(
                    scrollDirection: widget.scrollDirection,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                            height: 1.0, color: Theme.of(context).hintColor),
                    itemCount: _dataList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _dataList.length) {
                        return opacityLoadingProgress(
                          _isPerformingRequest,
                          loadingColor,
                          loadingWidget: this.widget.moreLoadingWidget,
                        );
                      } else {
                        return widget.itemBuilder(_dataList, context, index);
                      }
                    },
                    controller: _scrollController,
                  )
                : ListView.builder(
                    scrollDirection: widget.scrollDirection,
                    itemCount: _dataList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _dataList.length) {
                        return opacityLoadingProgress(
                          _isPerformingRequest,
                          loadingColor,
                          loadingWidget: this.widget.moreLoadingWidget,
                        );
                      } else {
                        return widget.itemBuilder(_dataList, context, index);
                      }
                    },
                    controller: _scrollController,
                  ),
          );
  }

  /// 刷新 数据初始化
  Future<Null> _onRefresh() async {
    List initDataList = await widget.initRequester();
    if (mounted) this.setState(() => this._dataList = initDataList);
    return;
  }

  /// 加载更多数据
  _loadMore() async {
    if (mounted) this.setState(() => _isPerformingRequest = true);
    List newDataList = await widget.dataRequester();
    if (newDataList == null || newDataList.length == 0) {
      double edge = 50.0;
      double offsetFromBottom = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        _scrollController.animateTo(
            _scrollController.offset - (edge - offsetFromBottom),
            duration: new Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    } else {
      _dataList.addAll(newDataList);
    }
    if (mounted) this.setState(() => _isPerformingRequest = false);
  }
}

Widget loadingProgress(loadingColor, {Widget initLoadingWidget}) {
  if (initLoadingWidget == null) {
    initLoadingWidget = defaultLoadingWidget;
  }
  return Center(
    child: initLoadingWidget,
  );
}

Widget opacityLoadingProgress(isPerformingRequest, loadingColor,
    {Widget loadingWidget}) {
  if (loadingWidget == null) {
    loadingWidget = defaultLoadingWidget;
  }
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: loadingWidget,
      ),
    ),
  );
}

class DynamicListController {
  Function refresh;
  ScrollController scrollController;

  fireRefresh() {
    if (refresh != null) {
      refresh();
      this.toTop();
    }
  }

  toTop() {
    if (scrollController.hasClients)
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
