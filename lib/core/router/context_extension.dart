import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';
import 'package:flutter_demo/core/router/route_helper.dart';
import 'package:flutter_demo/pages/BottomMenuBarPage.dart';
import 'package:flutter_demo/core/router/app_router.dart';

extension Context on BuildContext {
  // 不带参数的跳转
  Future<T?> routeTo<T extends Object?>(Type router) {
    return CoreRouter.routeTo(this, router);
  }

  // 保留当前页面，跳转到应用内的某个页面
  // Future<T?> navigateTo<T extends Object?>(Type router, {Object? arguments}) {
  //   return CoreRouter.navigateTo<T>(this, router, arguments: arguments);
  // }

  // 跳转到应用内的某个页面，但不显示底部导航栏
  Future<T?> navigateToNonTab<T extends Object?>(Type router,
      {Object? arguments}) {
    final routeName = RouteHelper.typeName(router);

    // 检查是否是tabs页面
    if (TabRoute.isTabRoute(routeName)) {
      print('Context.navigateToNonTab - 错误：不能使用navigateToNonTab跳转到tabs页面');
      return Future.value(null);
    } else {
      print('Context.navigateToNonTab - 使用根Navigator跳转到非tabs页面');
      // 使用根Navigator跳转，避免显示底部导航栏
      return Navigator.of(this, rootNavigator: true).push<T>(
        CoreRouter.onGenerateRoute<T>(
          RouteSettings(name: routeName, arguments: arguments),
        ),
      );
    }
  }

  // 关闭当前页面，跳转到应用内的某个页面
  Future<T?> redirectTo<T extends Object?, TO extends Object?>(Type router,
      {Object? arguments, TO? result}) {
    return CoreRouter.redirectTo<T, TO>(this, router,
        arguments: arguments, result: result);
  }

  // 关闭所有页面，打开到应用内的某个页面
  Future<T?> reLaunch<T extends Object?>(Type router, {Object? arguments}) {
    return CoreRouter.reLaunch<T>(this, router, arguments: arguments);
  }

  // 跳转到指定的tabBar页面，并关闭所有页面
  Future<T?> switchTab<T extends Object?>(Type router, {Object? arguments}) {
    final routeName = RouteHelper.typeName(router);
    print('Context.switchTab - 跳转到指定的tabBar页面，并关闭所有页面: $routeName');
    
    if (TabRoute.isTabRoute(routeName)) {
      // 检查当前是否已经在tabs页面
      final currentRoute = ModalRoute.of(this)?.settings.name;
      if (TabRoute.isTabRoute(currentRoute ?? '')) {
        // 如果已经是tabs页面，就切换tabs
        print('Context.switchTab - 已经是tabs页面，切换tabs');
        // 注意：这里需要在使用时通过 ProviderScope 获取 tabViewModel
        // 由于 context 扩展方法无法直接访问 Provider，这里暂时跳过
        // 实际使用时应该在 Widget 中通过 ref.read(tabViewModelProvider) 来调用
        return Future.value(null);
      } else {
        // 如果不是tabs页面，使用pushAndRemoveUntil确保页面栈一致性
        print('Context.switchTab - 不是tabs页面，使用pushAndRemoveUntil跳转到BottomMenuBarPage');
        final route = AppRouter.onGenerateRoute(
          RouteSettings(name: 'BottomMenuBarPage', arguments: routeName),
        );
        if (route != null) {
          return Navigator.of(this).pushAndRemoveUntil<T>(
            route as Route<T>,
            (route) => false, // 移除所有页面
          );
        }
        return Future.value(null);
      }
    } else {
      // 非tabs页面，使用pushAndRemoveUntil确保页面栈一致性
      print('Context.switchTab - 非tabs页面，使用pushAndRemoveUntil跳转到BottomMenuBarPage');
      final route = AppRouter.onGenerateRoute(
        RouteSettings(name: 'BottomMenuBarPage', arguments: routeName),
      );
      if (route != null) {
        return Navigator.of(this).pushAndRemoveUntil<T>(
          route as Route<T>,
          (route) => false, // 移除所有页面
        );
      }
      return Future.value(null);
    }
  }

  // 获取当前页面栈信息
  List<RouteInfo> getRouteStack() {
    return CoreRouter.getRouteStack(this);
  }

  // 关闭当前页面，返回上一页面或多级页面
  void navigateBack<T>([T? result]) {
    if (result != null) {
      Navigator.pop(this, result);
    } else {
      CoreRouter.navigateBack(this);
    }
  }

  // 通过这种方式，可以先获取页面对象的实例
  // 然后通过实例对象去调用 arguments 方法，最后调用 to 即可完成路由跳转
  RT routeOf<RT extends RouterBridge>() {
    assert(RT != RouterBridge<dynamic>,
        "You must specify the route type, for example: \"context.routeOf<Page>()\";");
    return CoreRouter.of<RT>(this);
  }
}
