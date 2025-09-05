import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 菜单项数据模型
class MenuItem {
  final String title;
  final IconData icon;
  final bool hasNotification;
  final String? notificationText;

  const MenuItem({
    required this.title,
    required this.icon,
    this.hasNotification = false,
    this.notificationText,
  });

  MenuItem copyWith({
    String? title,
    IconData? icon,
    bool? hasNotification,
    String? notificationText,
  }) {
    return MenuItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      hasNotification: hasNotification ?? this.hasNotification,
      notificationText: notificationText ?? this.notificationText,
    );
  }
}

/// 我的页面状态类
class MyPageState extends BaseState {
  final String username;
  final String uid;
  final String membershipLevel;
  final double progressValue;
  final double progressMax;
  final double taskEstimatedAmount;
  final double availableAmount;
  final String announcementText;
  final int myRegistrationCount;
  final int myStoreCount;
  final List<MenuItem> menuItems;

  const MyPageState({
    super.isLoading,
    super.errorMessage,
    required this.username,
    required this.uid,
    required this.membershipLevel,
    required this.progressValue,
    required this.progressMax,
    required this.taskEstimatedAmount,
    required this.availableAmount,
    required this.announcementText,
    required this.myRegistrationCount,
    required this.myStoreCount,
    required this.menuItems,
  });

  factory MyPageState.initial() => MyPageState(
        username: 'link_38',
        uid: '6753590',
        membershipLevel: 'V3黄金',
        progressValue: 5172,
        progressMax: 6999,
        taskEstimatedAmount: 0.00,
        availableAmount: 5.69,
        announcementText: '徒弟只要注册，奖您1.52-9.9元',
        myRegistrationCount: 0,
        myStoreCount: 0,
        menuItems: const [
          MenuItem(
            title: '发布任务',
            icon: Icons.add_task,
            hasNotification: false,
          ),
          MenuItem(
            title: '收徒赚钱',
            icon: Icons.people,
            hasNotification: true,
            notificationText: '领',
          ),
          MenuItem(
            title: '聊天消息',
            icon: Icons.chat,
            hasNotification: false,
          ),
          MenuItem(
            title: '举报维权',
            icon: Icons.report,
            hasNotification: false,
          ),
          MenuItem(
            title: '流水报表',
            icon: Icons.assessment,
            hasNotification: false,
          ),
          MenuItem(
            title: '客服与反馈',
            icon: Icons.headset_mic,
            hasNotification: false,
          ),
        ],
      );

  @override
  MyPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? username,
    String? uid,
    String? membershipLevel,
    double? progressValue,
    double? progressMax,
    double? taskEstimatedAmount,
    double? availableAmount,
    String? announcementText,
    int? myRegistrationCount,
    int? myStoreCount,
    List<MenuItem>? menuItems,
  }) {
    return MyPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      progressValue: progressValue ?? this.progressValue,
      progressMax: progressMax ?? this.progressMax,
      taskEstimatedAmount: taskEstimatedAmount ?? this.taskEstimatedAmount,
      availableAmount: availableAmount ?? this.availableAmount,
      announcementText: announcementText ?? this.announcementText,
      myRegistrationCount: myRegistrationCount ?? this.myRegistrationCount,
      myStoreCount: myStoreCount ?? this.myStoreCount,
      menuItems: menuItems ?? this.menuItems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyPageState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.username == username &&
        other.uid == uid &&
        other.membershipLevel == membershipLevel &&
        other.progressValue == progressValue &&
        other.progressMax == progressMax &&
        other.taskEstimatedAmount == taskEstimatedAmount &&
        other.availableAmount == availableAmount &&
        other.announcementText == announcementText &&
        other.myRegistrationCount == myRegistrationCount &&
        other.myStoreCount == myStoreCount &&
        listEquals(other.menuItems, menuItems);
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      username.hashCode ^
      uid.hashCode ^
      membershipLevel.hashCode ^
      progressValue.hashCode ^
      progressMax.hashCode ^
      taskEstimatedAmount.hashCode ^
      availableAmount.hashCode ^
      announcementText.hashCode ^
      myRegistrationCount.hashCode ^
      myStoreCount.hashCode ^
      menuItems.hashCode;
}

/// 我的页面 ViewModel
class MyPageViewModel extends StateNotifier<MyPageState> {
  MyPageViewModel() : super(MyPageState.initial());

  /// 安全执行异步操作
  Future<T?> safeAsync<T>(Future<T> Function() operation) async {
    try {
      state = state.copyWith(isLoading: true);
      state = state.copyWith(errorMessage: null);
      final result = await operation();
      return result;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 更新用户信息
  void updateUserInfo({
    String? username,
    String? uid,
    String? membershipLevel,
  }) {
    state = state.copyWith(
      username: username,
      uid: uid,
      membershipLevel: membershipLevel,
    );
  }

  /// 更新进度
  void updateProgress(double value, double max) {
    state = state.copyWith(
      progressValue: value,
      progressMax: max,
    );
  }

  /// 更新金额
  void updateAmounts({
    double? taskEstimatedAmount,
    double? availableAmount,
  }) {
    state = state.copyWith(
      taskEstimatedAmount: taskEstimatedAmount,
      availableAmount: availableAmount,
    );
  }

  /// 更新公告
  void updateAnnouncement(String text) {
    state = state.copyWith(announcementText: text);
  }

  /// 更新计数
  void updateCounts({
    int? myRegistrationCount,
    int? myStoreCount,
  }) {
    state = state.copyWith(
      myRegistrationCount: myRegistrationCount,
      myStoreCount: myStoreCount,
    );
  }

  /// 刷新用户数据
  Future<void> refreshUserData() async {
    await safeAsync(() async {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      // 这里可以添加实际的网络请求逻辑
      print('用户数据已刷新');
    });
  }

  /// 处理菜单项点击
  Future<void> handleMenuItemTap(String title) async {
    await safeAsync(() async {
      // 模拟处理逻辑
      await Future.delayed(const Duration(milliseconds: 500));
      print('点击了菜单项: $title');
    
      // 这里可以添加具体的处理逻辑
    });
  }

  /// 提现操作
  Future<void> withdraw() async {
    await safeAsync(() async {
      // 模拟提现逻辑
      await Future.delayed(const Duration(seconds: 2));
      print('提现操作完成');
      // 这里可以添加实际的提现逻辑
    });
  }

  /// 充值操作
  Future<void> recharge() async {
    await safeAsync(() async {
      // 模拟充值逻辑
      await Future.delayed(const Duration(seconds: 2));
      print('充值操作完成');
      // 这里可以添加实际的充值逻辑
    });
  }
}

/// 我的页面 ViewModel Provider
final myPageViewModelProvider = StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel();
});

/// 我的页面状态 Provider
final myPageStateProvider = Provider<MyPageState>((ref) {
  return ref.watch(myPageViewModelProvider);
});

// Helper for list comparison in operator ==
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
