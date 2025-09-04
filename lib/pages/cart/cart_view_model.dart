import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 任务项数据模型
class CartTaskItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const CartTaskItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  CartTaskItem copyWith({
    String? title,
    String? subtitle,
    IconData? icon,
  }) {
    return CartTaskItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
    );
  }
}

/// 购物车页面状态类
class CartPageState extends BaseState {
  final double todayDividend;
  final double myDividendPoints;
  final String dividendReward;
  final bool canClaimReward;
  final String claimMessage;
  final List<CartTaskItem> tasks;

  const CartPageState({
    super.isLoading,
    super.errorMessage,
    required this.todayDividend,
    required this.myDividendPoints,
    required this.dividendReward,
    required this.canClaimReward,
    required this.claimMessage,
    required this.tasks,
  });

  factory CartPageState.initial() => const CartPageState(
        todayDividend: 5715.62,
        myDividendPoints: 0.5731,
        dividendReward: '0.0406',
        canClaimReward: true,
        claimMessage: '请领取0.0406元分红奖励',
        tasks: [],
      );

  @override
  CartPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    double? todayDividend,
    double? myDividendPoints,
    String? dividendReward,
    bool? canClaimReward,
    String? claimMessage,
    List<CartTaskItem>? tasks,
  }) {
    return CartPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      todayDividend: todayDividend ?? this.todayDividend,
      myDividendPoints: myDividendPoints ?? this.myDividendPoints,
      dividendReward: dividendReward ?? this.dividendReward,
      canClaimReward: canClaimReward ?? this.canClaimReward,
      claimMessage: claimMessage ?? this.claimMessage,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartPageState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.todayDividend == todayDividend &&
        other.myDividendPoints == myDividendPoints &&
        other.dividendReward == dividendReward &&
        other.canClaimReward == canClaimReward &&
        other.claimMessage == claimMessage &&
        listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      todayDividend.hashCode ^
      myDividendPoints.hashCode ^
      dividendReward.hashCode ^
      canClaimReward.hashCode ^
      claimMessage.hashCode ^
      tasks.hashCode;
}

/// 购物车页面 ViewModel
class CartViewModel extends StateNotifier<CartPageState> {
  CartViewModel() : super(CartPageState.initial());

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

  /// 刷新任务列表
  Future<void> refreshTasks() async {
    await safeAsync(() async {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      final mockTasks = const [
        CartTaskItem(
          title: '完成悬赏任务',
          subtitle: '1元=60分红积分',
          icon: Icons.task_alt,
        ),
        CartTaskItem(
          title: '领1次游戏奖励',
          subtitle: '+100分红积分',
          icon: Icons.games,
        ),
        CartTaskItem(
          title: '直推1人提现',
          subtitle: '1人=300分红积分',
          icon: Icons.person_add,
        ),
      ];
      state = state.copyWith(tasks: mockTasks);
    });
  }

  /// 领取分红奖励
  Future<void> claimDividendReward() async {
    await safeAsync(() async {
      // 模拟领取逻辑
      await Future.delayed(const Duration(seconds: 2));
      
      if (state.canClaimReward) {
        // 更新状态为已领取
        state = state.copyWith(
          canClaimReward: false,
          claimMessage: '今日您已领取，请明日再来吧',
        );
        print('分红奖励已领取');
      }
    });
  }

  /// 完成任务
  Future<void> completeTask(String taskTitle) async {
    await safeAsync(() async {
      // 模拟任务完成逻辑
      await Future.delayed(const Duration(seconds: 1));
      print('任务 $taskTitle 已完成');
      // 这里可以添加任务完成后的逻辑，比如更新积分等
    });
  }

  /// 更新分红数据
  void updateDividendData({
    double? todayDividend,
    double? myDividendPoints,
    String? dividendReward,
  }) {
    state = state.copyWith(
      todayDividend: todayDividend,
      myDividendPoints: myDividendPoints,
      dividendReward: dividendReward,
    );
  }

  /// 更新奖励状态
  void updateRewardStatus({
    bool? canClaimReward,
    String? claimMessage,
  }) {
    state = state.copyWith(
      canClaimReward: canClaimReward,
      claimMessage: claimMessage,
    );
  }

  /// 刷新分红数据
  Future<void> refreshDividendData() async {
    await safeAsync(() async {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      // 这里可以添加实际的网络请求逻辑
      print('分红数据已刷新');
    });
  }
}

/// 购物车页面 ViewModel Provider
final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartPageState>((ref) {
  return CartViewModel();
});

/// 购物车页面状态 Provider
final cartPageStateProvider = Provider<CartPageState>((ref) {
  return ref.watch(cartViewModelProvider);
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