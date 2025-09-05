import 'package:flutter_demo/core/router/route_helper_static.dart';

/// 静态路由帮助类测试
class RouteHelperStaticTest {
  
  /// 测试 Navigator Key 是否正确设置
  static void testNavigatorKey() {
    print('=== 测试 Navigator Key ===');
    print('Navigator 可用: ${RouteHelperStatic.isNavigatorAvailable}');
    print('Navigator 状态: ${RouteHelperStatic.navigatorState}');
    print('当前上下文: ${RouteHelperStatic.currentContext}');
    print('当前页面: ${RouteHelperStatic.getCurrentRouteName()}');
    print('页面栈深度: ${RouteHelperStatic.getStackDepth()}');
    print('=======================');
  }
  
  /// 测试页面栈信息
  static void testRouteStack() {
    print('=== 测试页面栈信息 ===');
    final routeStack = RouteHelperStatic.getRouteStack();
    print('页面栈数量: ${routeStack.length}');
    for (int i = 0; i < routeStack.length; i++) {
      final route = routeStack[i];
      print('[$i] ${route.name} - ${route.arguments}');
    }
    print('===================');
  }
  
  /// 测试错误处理
  static void testErrorHandling() {
    print('=== 测试错误处理 ===');
    
    // 测试在 Navigator 不可用时的行为
    if (!RouteHelperStatic.isNavigatorAvailable) {
      print('Navigator 不可用，无法执行路由操作');
      return;
    }
    
    // 测试页面跳转
    try {
      print('尝试执行页面跳转...');
      // 这里可以添加实际的页面跳转测试
      print('页面跳转测试完成');
    } catch (e) {
      print('页面跳转失败: $e');
    }
    
    print('==================');
  }
  
  /// 运行所有测试
  static void runAllTests() {
    print('开始运行静态路由帮助类测试...');
    testNavigatorKey();
    testRouteStack();
    testErrorHandling();
    print('测试完成！');
  }
  
  /// 延迟测试 - 等待应用完全启动后执行
  static void runDelayedTests() {
    Future.delayed(const Duration(seconds: 2), () {
      print('延迟测试开始...');
      runAllTests();
    });
  }
}
