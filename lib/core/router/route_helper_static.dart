import 'package:flutter/material.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';
import 'package:flutter_demo/core/router/route_helper.dart';
import 'package:flutter_demo/core/router/app_router.dart';

/// 静态路由帮助类 - 不需要 context 的路由操作
class RouteHelperStatic {
  static GlobalKey<NavigatorState>? _navigatorKey;
  
  /// 设置全局 Navigator Key
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
    print('RouteHelperStatic.setNavigatorKey - 设置 Navigator Key: $key');
  }
  
  /// 获取当前 Navigator 状态
  static NavigatorState? get _navigator {
    final navigator = _navigatorKey?.currentState;
    print('RouteHelperStatic._navigator - 获取 Navigator: $navigator');
    return navigator;
  }
  
  /// 获取当前 BuildContext
  static BuildContext? get _context {
    final context = _navigator?.context;
    print('RouteHelperStatic._context - 获取 Context: $context');
    return context;
  }

  // ==================== 基础路由操作 ====================

  /// 不带参数的跳转
  static Future<T?> routeTo<T extends Object?>(Type router) {
    if (_context == null) {
      print('RouteHelperStatic.routeTo - 错误：Navigator context 为空');
      return Future.value(null);
    }
    return CoreRouter.routeTo(_context!, router);
  }

  /// 跳转到应用内的某个页面，但不显示底部导航栏
  static Future<T?> navigateToNonTab<T extends Object?>(Type router, {Object? arguments}) {
    print('RouteHelperStatic.navigateToNonTab - 开始跳转');
    print('RouteHelperStatic.navigateToNonTab - _navigatorKey: $_navigatorKey');
    print('RouteHelperStatic.navigateToNonTab - _navigator: $_navigator');
    print('RouteHelperStatic.navigateToNonTab - _context: $_context');
    
    if (_context == null) {
      print('RouteHelperStatic.navigateToNonTab - 错误：Navigator context 为空');
      return Future.value(null);
    }
    
    final routeName = RouteHelper.typeName(router);
    print('RouteHelperStatic.navigateToNonTab - 跳转到非tabs页面: $routeName');

    // 检查是否是tabs页面
    if (TabRoute.isTabRoute(routeName)) {
      print('RouteHelperStatic.navigateToNonTab - 错误：不能使用navigateToNonTab跳转到tabs页面');
      return Future.value(null);
    } else {
      print('RouteHelperStatic.navigateToNonTab - 使用根Navigator跳转到非tabs页面');
      // 使用根Navigator跳转，避免显示底部导航栏
      return Navigator.of(_context!, rootNavigator: true).push<T>(
        CoreRouter.onGenerateRoute<T>(
          RouteSettings(name: routeName, arguments: arguments),
        ),
      );
    }
  }

  /// 关闭当前页面，跳转到应用内的某个页面
  static Future<T?> redirectTo<T extends Object?, TO extends Object?>(Type router,
      {Object? arguments, TO? result}) {
    if (_context == null) {
      print('RouteHelperStatic.redirectTo - 错误：Navigator context 为空');
      return Future.value(null);
    }
    return CoreRouter.redirectTo<T, TO>(_context!, router,
        arguments: arguments, result: result);
  }

  /// 关闭所有页面，打开到应用内的某个页面
  static Future<T?> reLaunch<T extends Object?>(Type router, {Object? arguments}) {
    if (_context == null) {
      print('RouteHelperStatic.reLaunch - 错误：Navigator context 为空');
      return Future.value(null);
    }
    return CoreRouter.reLaunch<T>(_context!, router, arguments: arguments);
  }

  /// 跳转到指定的tabBar页面，并关闭所有页面
  static Future<T?> switchTab<T extends Object?>(Type router, {Object? arguments}) {
    if (_context == null) {
      print('RouteHelperStatic.switchTab - 错误：Navigator context 为空');
      return Future.value(null);
    }
    
    final routeName = RouteHelper.typeName(router);
    print('RouteHelperStatic.switchTab - 跳转到指定的tabBar页面，并关闭所有页面: $routeName');
    
    if (TabRoute.isTabRoute(routeName)) {
      // 检查当前是否已经在tabs页面
      final currentRoute = ModalRoute.of(_context!)?.settings.name;
      if (TabRoute.isTabRoute(currentRoute ?? '')) {
        // 如果已经是tabs页面，就切换tabs
        print('RouteHelperStatic.switchTab - 已经是tabs页面，切换tabs');
        // 注意：这里需要在使用时通过 ProviderScope 获取 tabViewModel
        // 由于静态方法无法直接访问 Provider，这里暂时跳过
        // 实际使用时应该在 Widget 中通过 ref.read(tabViewModelProvider) 来调用
        return Future.value(null);
      } else {
        // 如果不是tabs页面，使用pushAndRemoveUntil确保页面栈一致性
        print('RouteHelperStatic.switchTab - 不是tabs页面，使用pushAndRemoveUntil跳转到BottomMenuBarPage');
        final route = AppRouter.onGenerateRoute(
          RouteSettings(name: 'BottomMenuBarPage', arguments: routeName),
        );
        if (route != null) {
          return Navigator.of(_context!).pushAndRemoveUntil<T>(
            route as Route<T>,
            (route) => false, // 移除所有页面
          );
        }
        return Future.value(null);
      }
    } else {
      // 非tabs页面，使用pushAndRemoveUntil确保页面栈一致性
      print('RouteHelperStatic.switchTab - 非tabs页面，使用pushAndRemoveUntil跳转到BottomMenuBarPage');
      final route = AppRouter.onGenerateRoute(
        RouteSettings(name: 'BottomMenuBarPage', arguments: routeName),
      );
      if (route != null) {
        return Navigator.of(_context!).pushAndRemoveUntil<T>(
          route as Route<T>,
          (route) => false, // 移除所有页面
        );
      }
      return Future.value(null);
    }
  }

  /// 获取当前页面栈信息
  static List<RouteInfo> getRouteStack() {
    if (_context == null) {
      print('RouteHelperStatic.getRouteStack - 错误：Navigator context 为空');
      return [];
    }
    return CoreRouter.getRouteStack(_context!);
  }

  /// 关闭当前页面，返回上一页面或多级页面
  static void navigateBack<T>([T? result]) {
    if (_context == null) {
      print('RouteHelperStatic.navigateBack - 错误：Navigator context 为空');
      return;
    }
    
    if (result != null) {
      Navigator.pop(_context!, result);
    } else {
      CoreRouter.navigateBack(_context!);
    }
  }

  /// 通过这种方式，可以先获取页面对象的实例
  /// 然后通过实例对象去调用 arguments 方法，最后调用 to 即可完成路由跳转
  static RT routeOf<RT extends RouterBridge>() {
    if (_context == null) {
      print('RouteHelperStatic.routeOf - 错误：Navigator context 为空');
      throw Exception('Navigator context 为空');
    }
    assert(RT != RouterBridge<dynamic>,
        "You must specify the route type, for example: \"RouteHelperStatic.routeOf<Page>()\";");
    return CoreRouter.of<RT>(_context!);
  }

  // ==================== 高级路由操作 ====================

  /// 检查当前页面栈中是否存在指定页面
  static bool hasRoute(String routeName) {
    if (_context == null) return false;
    final routeStack = getRouteStack();
    return routeStack.any((route) => route.name == routeName);
  }

  /// 返回到指定页面
  static Future<T?> popToRoute<T>(String routeName, {T? result}) {
    if (_context == null) {
      print('RouteHelperStatic.popToRoute - 错误：Navigator context 为空');
      return Future.value(null);
    }
    
    final routeStack = getRouteStack();
    final targetRoute = routeStack.firstWhere(
      (route) => route.name == routeName,
      orElse: () => routeStack.first,
    );
    
    if (targetRoute.name == routeName) {
      Navigator.of(_context!).popUntil((route) => route.settings.name == routeName);
      return Future.value(result);
    } else {
      print('RouteHelperStatic.popToRoute - 错误：未找到指定页面 $routeName');
      return Future.value(null);
    }
  }

  /// 替换当前页面
  static Future<T?> replaceWith<T extends Object?>(Type router, {Object? arguments}) {
    if (_context == null) {
      print('RouteHelperStatic.replaceWith - 错误：Navigator context 为空');
      return Future.value(null);
    }
    
    final routeName = RouteHelper.typeName(router);
    final route = CoreRouter.onGenerateRoute<T>(
      RouteSettings(name: routeName, arguments: arguments),
    );
    
    return Navigator.of(_context!).pushReplacement<T, dynamic>(
      route,
    );
  }

  /// 清空页面栈并跳转到指定页面
  static Future<T?> clearAndPush<T extends Object?>(Type router, {Object? arguments}) {
    if (_context == null) {
      print('RouteHelperStatic.clearAndPush - 错误：Navigator context 为空');
      return Future.value(null);
    }
    
    final routeName = RouteHelper.typeName(router);
    final route = CoreRouter.onGenerateRoute<T>(
      RouteSettings(name: routeName, arguments: arguments),
    );
    
    return Navigator.of(_context!).pushAndRemoveUntil<T>(
      route,
      (route) => false,
    );
  }

  /// 获取当前页面名称
  static String? getCurrentRouteName() {
    if (_context == null) return null;
    return ModalRoute.of(_context!)?.settings.name;
  }

  /// 获取当前页面参数
  static Object? getCurrentRouteArguments() {
    if (_context == null) return null;
    return ModalRoute.of(_context!)?.settings.arguments;
  }

  /// 检查是否可以返回
  static bool canPop() {
    if (_context == null) return false;
    return Navigator.of(_context!).canPop();
  }

  /// 返回指定数量的页面
  static void popCount(int count) {
    if (_context == null) {
      print('RouteHelperStatic.popCount - 错误：Navigator context 为空');
      return;
    }
    
    for (int i = 0; i < count && Navigator.of(_context!).canPop(); i++) {
      Navigator.of(_context!).pop();
    }
  }

  // ==================== 页面栈管理 ====================

  /// 获取页面栈深度
  static int getStackDepth() {
    return getRouteStack().length;
  }

  /// 打印当前页面栈信息
  static void printRouteStack() {
    final routeStack = getRouteStack();
    print('=== 当前页面栈信息 ===');
    for (int i = 0; i < routeStack.length; i++) {
      final route = routeStack[i];
      print('[$i] ${route.name} - ${route.arguments}');
    }
    print('==================');
  }

  /// 检查页面栈是否为空
  static bool isStackEmpty() {
    return getStackDepth() == 0;
  }

  // ==================== 错误处理 ====================

  /// 检查 Navigator 是否可用
  static bool get isNavigatorAvailable => _navigator != null;

  /// 获取 Navigator 状态
  static NavigatorState? get navigatorState => _navigator;

  /// 获取当前 BuildContext
  static BuildContext? get currentContext => _context;
}
