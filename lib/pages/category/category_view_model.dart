import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 任务项数据模型
class CategoryTaskItem {
  final String title;
  final int completedCount;
  final int remainingCount;
  final double reward;
  final List<String> tags;
  final String avatar;
  final bool hasAnnualCard;

  const CategoryTaskItem({
    required this.title,
    required this.completedCount,
    required this.remainingCount,
    required this.reward,
    required this.tags,
    required this.avatar,
    required this.hasAnnualCard,
  });

  CategoryTaskItem copyWith({
    String? title,
    int? completedCount,
    int? remainingCount,
    double? reward,
    List<String>? tags,
    String? avatar,
    bool? hasAnnualCard,
  }) {
    return CategoryTaskItem(
      title: title ?? this.title,
      completedCount: completedCount ?? this.completedCount,
      remainingCount: remainingCount ?? this.remainingCount,
      reward: reward ?? this.reward,
      tags: tags ?? this.tags,
      avatar: avatar ?? this.avatar,
      hasAnnualCard: hasAnnualCard ?? this.hasAnnualCard,
    );
  }
}

/// 分类页面状态类
class CategoryPageState extends BaseState {
  final int selectedFilterIndex;
  final List<String> filterTabs;
  final List<CategoryTaskItem> tasks;
  final String featuredTaskTitle;
  final double featuredTaskReward;

  const CategoryPageState({
    super.isLoading,
    super.errorMessage,
    required this.selectedFilterIndex,
    required this.filterTabs,
    required this.tasks,
    required this.featuredTaskTitle,
    required this.featuredTaskReward,
  });

  factory CategoryPageState.initial() => const CategoryPageState(
        selectedFilterIndex: 1, // "最新" is selected by default
        filterTabs: ['选择分类', '最新', '置顶', '简单', '优选', '快赚'],
        tasks: [],
        featuredTaskTitle: '「创赢」🔥15条简单易过🔥',
        featuredTaskReward: 7.36,
      );

  @override
  CategoryPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? selectedFilterIndex,
    List<String>? filterTabs,
    List<CategoryTaskItem>? tasks,
    String? featuredTaskTitle,
    double? featuredTaskReward,
  }) {
    return CategoryPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      filterTabs: filterTabs ?? this.filterTabs,
      tasks: tasks ?? this.tasks,
      featuredTaskTitle: featuredTaskTitle ?? this.featuredTaskTitle,
      featuredTaskReward: featuredTaskReward ?? this.featuredTaskReward,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryPageState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.selectedFilterIndex == selectedFilterIndex &&
        listEquals(other.filterTabs, filterTabs) &&
        listEquals(other.tasks, tasks) &&
        other.featuredTaskTitle == featuredTaskTitle &&
        other.featuredTaskReward == featuredTaskReward;
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      selectedFilterIndex.hashCode ^
      filterTabs.hashCode ^
      tasks.hashCode ^
      featuredTaskTitle.hashCode ^
      featuredTaskReward.hashCode;
}

/// 分类页面 ViewModel
class CategoryViewModel extends StateNotifier<CategoryPageState> {
  CategoryViewModel() : super(CategoryPageState.initial());

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

  /// 设置选中的筛选标签
  void setSelectedFilterIndex(int index) {
    state = state.copyWith(selectedFilterIndex: index);
  }

  /// 刷新任务列表
  Future<void> refreshTasks() async {
    await safeAsync(() async {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      final mockTasks = [
        CategoryTaskItem(
          title: '人人都可以来🔥妙审',
          completedCount: 1798,
          remainingCount: 40,
          reward: 6.65,
          tags: ['电商回收', '南方航空', '推'],
          avatar: 'avatar1',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '🤖简单助力✅立马给钱',
          completedCount: 1195,
          remainingCount: 4,
          reward: 10.00,
          tags: ['注册下载', '快手极速版', '推'],
          avatar: 'avatar2',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '高价十条完整火！',
          completedCount: 21,
          remainingCount: 11,
          reward: 3.80,
          tags: ['注册下载', '魔法花苑', '推'],
          avatar: 'avatar3',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '新单🔥吉祥花',
          completedCount: 778,
          remainingCount: 22,
          reward: 0.48,
          tags: ['简单帮忙', '金融服务'],
          avatar: 'avatar4',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '微信1s助力',
          completedCount: 634,
          remainingCount: 196,
          reward: 0.50,
          tags: ['简单帮忙', '自知业主公众'],
          avatar: 'avatar5',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: 'Yz注册实名',
          completedCount: 596,
          remainingCount: 204,
          reward: 0.60,
          tags: ['网页注册', '无语平台'],
          avatar: 'avatar6',
          hasAnnualCard: false,
        ),
        CategoryTaskItem(
          title: '高价不用等短信',
          completedCount: 121,
          remainingCount: 59,
          reward: 13.30,
          tags: ['特单任务', '国泰君安期货', '推'],
          avatar: 'avatar7',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '人人可做🔥',
          completedCount: 266,
          remainingCount: 15,
          reward: 1.02,
          tags: ['网页注册', '百度优选推荐', '推'],
          avatar: 'avatar8',
          hasAnnualCard: true,
        ),
        CategoryTaskItem(
          title: '梦幻少女极速版',
          completedCount: 3799,
          remainingCount: 8,
          reward: 0.63,
          tags: ['游戏赚钱', '快赚0.63元', '推'],
          avatar: 'avatar9',
          hasAnnualCard: false,
        ),
      ];
      state = state.copyWith(tasks: mockTasks);
    });
  }

  /// 完成任务
  Future<void> completeTask(String taskTitle) async {
    await safeAsync(() async {
      // 模拟任务完成逻辑
      await Future.delayed(const Duration(seconds: 1));
      print('任务 $taskTitle 已完成');
      // 可以在这里更新任务列表或显示提示
    });
  }

  /// 更新特色任务
  void updateFeaturedTask(String title, double reward) {
    state = state.copyWith(
      featuredTaskTitle: title,
      featuredTaskReward: reward,
    );
  }
}

/// 分类页面 ViewModel Provider
final categoryViewModelProvider = StateNotifierProvider<CategoryViewModel, CategoryPageState>((ref) {
  return CategoryViewModel();
});

/// 分类页面状态 Provider
final categoryPageStateProvider = Provider<CategoryPageState>((ref) {
  return ref.watch(categoryViewModelProvider);
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