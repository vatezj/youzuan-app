# 静态路由帮助类 (RouteHelperStatic)

## 概述

`RouteHelperStatic` 是一个不需要 `BuildContext` 的静态路由帮助类，可以在任何地方（包括 ViewModel、Service、工具类等）进行页面跳转操作。

## 特性

- ✅ **无需 Context**: 在任何地方都可以使用，不需要传递 `BuildContext`
- ✅ **全局访问**: 通过全局 Navigator Key 实现全局路由管理
- ✅ **类型安全**: 支持泛型，提供类型安全的路由操作
- ✅ **错误处理**: 完善的错误处理和状态检查
- ✅ **页面栈管理**: 提供丰富的页面栈管理功能
- ✅ **调试支持**: 内置调试日志和页面栈监控

## 安装配置

### 1. 在 main.dart 中设置全局 Navigator Key

```dart
import 'package:flutter_demo/core/router/route_helper_static.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // ... 其他配置
      builder: (context, child) {
        // 设置全局 Navigator Key
        RouteHelperStatic.setNavigatorKey(GlobalKey<NavigatorState>());
        return child!;
      },
    );
  }
}
```

### 2. 导入静态路由帮助类

```dart
import 'package:flutter_demo/core/router/route_helper_static.dart';
```

## 基础用法

### 1. 页面跳转

```dart
// 跳转到非 Tab 页面
await RouteHelperStatic.navigateToNonTab(TaskDetailPage);

// 带参数跳转
await RouteHelperStatic.navigateToNonTab(
  PublishTaskPage, 
  arguments: {'from': 'home'}
);
```

### 2. 页面替换

```dart
// 替换当前页面
await RouteHelperStatic.replaceWith(TaskDetailPage);
```

### 3. 清空栈并跳转

```dart
// 清空所有页面并跳转到指定页面
await RouteHelperStatic.clearAndPush(TaskDetailPage);
```

### 4. 页面返回

```dart
// 检查是否可以返回
if (RouteHelperStatic.canPop()) {
  // 返回上一页
  RouteHelperStatic.navigateBack();
  
  // 返回指定数量的页面
  RouteHelperStatic.popCount(2);
}
```

## 高级用法

### 1. 页面栈管理

```dart
// 获取页面栈深度
int depth = RouteHelperStatic.getStackDepth();

// 检查是否存在指定页面
bool hasTaskDetail = RouteHelperStatic.hasRoute('TaskDetailPage');

// 打印当前页面栈信息
RouteHelperStatic.printRouteStack();

// 获取当前页面名称
String? currentRoute = RouteHelperStatic.getCurrentRouteName();
```

### 2. 返回到指定页面

```dart
// 返回到指定页面
await RouteHelperStatic.popToRoute('TaskDetailPage', result: 'success');
```

### 3. 错误处理

```dart
// 检查 Navigator 是否可用
if (RouteHelperStatic.isNavigatorAvailable) {
  // 执行路由操作
  await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
} else {
  print('Navigator 不可用');
}
```

## 在 ViewModel 中使用

```dart
class TaskViewModel extends StateNotifier<TaskState> {
  
  /// 提交任务
  Future<void> submitTask() async {
    try {
      // 执行提交逻辑
      await _apiService.submitTask();
      
      // 提交成功后跳转 - 无需 context
      await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
      
    } catch (e) {
      print('提交失败: $e');
    }
  }
  
  /// 取消操作
  void cancelOperation() {
    if (RouteHelperStatic.canPop()) {
      RouteHelperStatic.navigateBack();
    }
  }
}
```

## 在 Service 中使用

```dart
class PushNotificationService {
  
  /// 处理推送通知
  Future<void> handlePushNotification(Map<String, dynamic> data) async {
    String? targetPage = data['target_page'];
    
    if (targetPage != null) {
      switch (targetPage) {
        case 'task_detail':
          await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
          break;
        case 'publish_task':
          await RouteHelperStatic.navigateToNonTab(PublishTaskPage);
          break;
      }
    }
  }
}
```

## 页面栈监控

```dart
class RouteMonitor {
  static Timer? _monitoringTimer;
  
  /// 开始监控页面栈
  static void startMonitoring() {
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (RouteHelperStatic.isNavigatorAvailable) {
        int depth = RouteHelperStatic.getStackDepth();
        String? currentRoute = RouteHelperStatic.getCurrentRouteName();
        
        print('页面栈监控 - 深度: $depth, 当前页面: $currentRoute');
        
        // 如果页面栈过深，可以清理
        if (depth > 10) {
          print('页面栈过深，建议清理');
        }
      }
    });
  }
  
  /// 停止监控
  static void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }
}
```

## API 参考

### 基础路由操作

| 方法 | 描述 | 返回值 |
|------|------|--------|
| `routeTo<T>(Type router)` | 不带参数的跳转 | `Future<T?>` |
| `navigateToNonTab<T>(Type router, {Object? arguments})` | 跳转到非 Tab 页面 | `Future<T?>` |
| `redirectTo<T, TO>(Type router, {Object? arguments, TO? result})` | 关闭当前页面并跳转 | `Future<T?>` |
| `reLaunch<T>(Type router, {Object? arguments})` | 关闭所有页面并跳转 | `Future<T?>` |
| `switchTab<T>(Type router, {Object? arguments})` | 跳转到 Tab 页面 | `Future<T?>` |

### 高级路由操作

| 方法 | 描述 | 返回值 |
|------|------|--------|
| `replaceWith<T>(Type router, {Object? arguments})` | 替换当前页面 | `Future<T?>` |
| `clearAndPush<T>(Type router, {Object? arguments})` | 清空栈并跳转 | `Future<T?>` |
| `popToRoute<T>(String routeName, {T? result})` | 返回到指定页面 | `Future<T?>` |

### 页面栈管理

| 方法 | 描述 | 返回值 |
|------|------|--------|
| `getRouteStack()` | 获取页面栈信息 | `List<RouteInfo>` |
| `hasRoute(String routeName)` | 检查是否存在指定页面 | `bool` |
| `getStackDepth()` | 获取页面栈深度 | `int` |
| `printRouteStack()` | 打印页面栈信息 | `void` |

### 页面返回操作

| 方法 | 描述 | 返回值 |
|------|------|--------|
| `navigateBack<T>([T? result])` | 关闭当前页面 | `void` |
| `canPop()` | 检查是否可以返回 | `bool` |
| `popCount(int count)` | 返回指定数量的页面 | `void` |

### 状态检查

| 方法 | 描述 | 返回值 |
|------|------|--------|
| `isNavigatorAvailable` | 检查 Navigator 是否可用 | `bool` |
| `navigatorState` | 获取 Navigator 状态 | `NavigatorState?` |
| `currentContext` | 获取当前 BuildContext | `BuildContext?` |
| `getCurrentRouteName()` | 获取当前页面名称 | `String?` |
| `getCurrentRouteArguments()` | 获取当前页面参数 | `Object?` |

## 注意事项

1. **初始化**: 必须在 `main.dart` 中设置全局 Navigator Key
2. **错误处理**: 建议在使用前检查 `isNavigatorAvailable`
3. **内存管理**: 页面栈监控需要手动停止，避免内存泄漏
4. **类型安全**: 使用泛型时确保类型正确
5. **调试**: 生产环境中可以关闭调试日志

## 最佳实践

1. **在 ViewModel 中使用**: 业务逻辑与 UI 分离
2. **错误处理**: 始终检查 Navigator 可用性
3. **页面栈管理**: 定期监控页面栈深度
4. **类型安全**: 使用强类型路由操作
5. **调试支持**: 开发时启用页面栈监控

## 示例项目

完整的使用示例请参考 `route_helper_static_example.dart` 文件。
