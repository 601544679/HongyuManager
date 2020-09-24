import 'package:event_bus/event_bus.dart';

/// 创建EventBus
EventBus eventBus = EventBus();

/// 触发搜索事件
class SearchEvent {
  String keywords;

  SearchEvent(this.keywords);
}

///删除搜索历史事件
class DelSearchKeyEvent {
  String keywords;

  DelSearchKeyEvent(this.keywords);
}
