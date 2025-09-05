import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/router/route_helper_static.dart';
import 'package:flutter_demo/pages/task/taskdetailPage.dart';
import 'package:flutter_demo/pages/user/publish_task_page.dart';

/// 静态路由帮助类使用示例
class RouteHelperStaticExample {
  
  /// 示例1：基础页面跳转
  static Future<void> basicNavigationExample() async {
    // 跳转到任务详情页面
    await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
    
    // 跳转到发布任务页面，并传递参数
    await RouteHelperStatic.navigateToNonTab(
      PublishTaskPage, 
      arguments: {'from': 'home'}
    );
  }
  
  /// 示例2：页面替换
  static Future<void> replacePageExample() async {
    // 替换当前页面
    await RouteHelperStatic.replaceWith(TaskDetailPage);
  }
  
  /// 示例3：清空栈并跳转
  static Future<void> clearAndPushExample() async {
    // 清空所有页面并跳转到指定页面
    await RouteHelperStatic.clearAndPush(TaskDetailPage);
  }
  
  /// 示例4：页面栈管理
  static void stackManagementExample() {
    // 检查当前页面栈深度
    int depth = RouteHelperStatic.getStackDepth();
    print('当前页面栈深度: $depth');
    
    // 检查是否存在指定页面
    bool hasTaskDetail = RouteHelperStatic.hasRoute('TaskDetailPage');
    print('是否存在任务详情页面: $hasTaskDetail');
    
    // 打印当前页面栈信息
    RouteHelperStatic.printRouteStack();
    
    // 获取当前页面名称
    String? currentRoute = RouteHelperStatic.getCurrentRouteName();
    print('当前页面: $currentRoute');
  }
  
  /// 示例5：页面返回操作
  static void backNavigationExample() {
    // 检查是否可以返回
    if (RouteHelperStatic.canPop()) {
      // 返回上一页
      RouteHelperStatic.navigateBack();
      
      // 返回指定数量的页面
      RouteHelperStatic.popCount(2);
    }
  }
  
  /// 示例6：错误处理
  static void errorHandlingExample() {
    // 检查 Navigator 是否可用
    if (RouteHelperStatic.isNavigatorAvailable) {
      print('Navigator 可用');
      
      // 获取当前上下文
      BuildContext? context = RouteHelperStatic.currentContext;
      if (context != null) {
        print('当前上下文可用');
      } else {
        print('当前上下文不可用');
      }
    } else {
      print('Navigator 不可用');
    }
  }
  
  /// 示例7：在 ViewModel 中使用静态路由
  static Future<void> viewModelUsageExample() async {
    // 在 ViewModel 中可以直接使用，无需 context
    try {
      // 提交任务成功后跳转
      await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
      
      // 或者清空栈并跳转到首页
      await RouteHelperStatic.clearAndPush(TaskDetailPage);
      
    } catch (e) {
      print('路由跳转失败: $e');
    }
  }
  
  /// 示例8：条件跳转
  static Future<void> conditionalNavigationExample() async {
    // 根据条件决定跳转方式
    bool isLoggedIn = true; // 假设的登录状态
    
    if (isLoggedIn) {
      // 已登录，直接跳转
      await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
    } else {
      // 未登录，清空栈并跳转到登录页
      await RouteHelperStatic.clearAndPush(TaskDetailPage);
    }
  }
  
  /// 示例9：批量操作
  static Future<void> batchOperationsExample() async {
    // 批量跳转多个页面
    List<Type> pages = [TaskDetailPage, PublishTaskPage];
    
    for (Type page in pages) {
      await RouteHelperStatic.navigateToNonTab(page);
      // 可以添加延迟或其他逻辑
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  
  /// 示例10：页面栈监控
  static Timer? _monitoringTimer;
  
  static void startStackMonitoring() {
    // 定期检查页面栈状态
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (RouteHelperStatic.isNavigatorAvailable) {
        int depth = RouteHelperStatic.getStackDepth();
        String? currentRoute = RouteHelperStatic.getCurrentRouteName();
        
        print('页面栈监控 - 深度: $depth, 当前页面: $currentRoute');
        
        // 如果页面栈过深，可以清理
        if (depth > 10) {
          print('页面栈过深，建议清理');
          // 可以执行清理操作
        }
      }
    });
  }
  
  static void stopStackMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }
  
  /// 示例11：页面栈监控示例
  static void stackMonitoringExample() {
    // 开始监控
    startStackMonitoring();
    
    // 5秒后停止监控
    Timer(const Duration(seconds: 5), () {
      stopStackMonitoring();
    });
  }
}

/// 在 ViewModel 中的使用示例
class ExampleViewModel {
  
  /// 提交任务
  Future<void> submitTask() async {
    try {
      // 执行提交逻辑
      print('提交任务中...');
      
      // 提交成功后跳转
      await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
      
    } catch (e) {
      print('提交失败: $e');
      // 错误处理
    }
  }
  
  /// 取消操作
  void cancelOperation() {
    // 直接返回，无需 context
    if (RouteHelperStatic.canPop()) {
      RouteHelperStatic.navigateBack();
    }
  }
  
  /// 重置到首页
  Future<void> resetToHome() async {
    // 清空所有页面并跳转到首页
    await RouteHelperStatic.clearAndPush(TaskDetailPage);
  }
}

/// 在 Service 中的使用示例
class ExampleService {
  
  /// 处理推送通知
  Future<void> handlePushNotification(Map<String, dynamic> data) async {
    String? targetPage = data['target_page'];
    
    if (targetPage != null) {
      // 根据推送数据跳转到指定页面
      switch (targetPage) {
        case 'task_detail':
          await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
          break;
        case 'publish_task':
          await RouteHelperStatic.navigateToNonTab(PublishTaskPage);
          break;
        default:
          print('未知的推送页面: $targetPage');
      }
    }
  }
  
  /// 处理深度链接
  Future<void> handleDeepLink(String url) async {
    // 解析深度链接
    if (url.contains('/task/')) {
      await RouteHelperStatic.navigateToNonTab(TaskDetailPage);
    } else if (url.contains('/publish/')) {
      await RouteHelperStatic.navigateToNonTab(PublishTaskPage);
    }
  }
}
