import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 任务项数据模型
class TaskItem {
  final String id;
  final String title;
  final String subtitle;
  final String reward;
  final List<String> tags;
  final String avatarColor;
  final bool hasEarnButton;

  const TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.tags,
    required this.avatarColor,
    this.hasEarnButton = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      reward: json['reward'] as String,
      tags: List<String>.from(json['tags'] as List),
      avatarColor: json['avatarColor'] as String,
      hasEarnButton: json['hasEarnButton'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'reward': reward,
      'tags': tags,
      'avatarColor': avatarColor,
      'hasEarnButton': hasEarnButton,
    };
  }
}

/// 任务页面状态类
class TaskPageState extends BaseState {
  final String countdownTime;
  final List<TaskItem> recommendedTasks;
  final int selectedIndex;
  final bool isTimerRunning;

  const TaskPageState({
    super.isLoading,
    super.errorMessage,
    required this.countdownTime,
    required this.recommendedTasks,
    required this.selectedIndex,
    required this.isTimerRunning,
  });

  factory TaskPageState.initial() => TaskPageState(
        countdownTime: "09:25:55",
        recommendedTasks: _getDefaultTasks(),
        selectedIndex: 0,
        isTimerRunning: false,
      );

  static List<TaskItem> _getDefaultTasks() {
    return [
      TaskItem(
        id: '1',
        title: '🔥微信简单',
        subtitle: '161人已赚，剩余39个',
        reward: '+0.60元',
        tags: ['网页注册', '可乐阅读'],
        avatarColor: 'blue',
      ),
      TaskItem(
        id: '2',
        title: '微信到账2元',
        subtitle: '69人已赚，剩余336个',
        reward: '+0.70元',
        tags: ['网页注册', '云扫码'],
        avatarColor: 'red',
      ),
      TaskItem(
        id: '3',
        title: '金领冠爱儿',
        subtitle: '43人已赚，剩余20个',
        reward: '+2.76元',
        tags: ['网页注册', '伊利爱儿俱乐部'],
        avatarColor: 'blue',
      ),
      TaskItem(
        id: '4',
        title: '高价9条🔥',
        subtitle: '117人已赚，剩余18个',
        reward: '+5.79元',
        tags: ['注册下载', '晓光数据猫'],
        avatarColor: 'purple',
      ),
      TaskItem(
        id: '5',
        title: '30卷银卡，新的一月',
        subtitle: '28人已赚，剩余18个',
        reward: '',
        tags: ['电商回收', '网络兼职计划'],
        avatarColor: 'red',
        hasEarnButton: true,
      ),
      TaskItem(
        id: '6',
        title: '做过的不要来',
        subtitle: '331人已赚，剩余2个',
        reward: '',
        tags: ['游戏试玩', '推广拉新'],
        avatarColor: 'blue',
      ),
    ];
  }

  @override
  TaskPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? countdownTime,
    List<TaskItem>? recommendedTasks,
    int? selectedIndex,
    bool? isTimerRunning,
  }) {
    return TaskPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      countdownTime: countdownTime ?? this.countdownTime,
      recommendedTasks: recommendedTasks ?? this.recommendedTasks,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskPageState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.countdownTime == countdownTime &&
        other.recommendedTasks == recommendedTasks &&
        other.selectedIndex == selectedIndex &&
        other.isTimerRunning == isTimerRunning;
  }

  @override
  int get hashCode => isLoading.hashCode ^
      errorMessage.hashCode ^
      countdownTime.hashCode ^
      recommendedTasks.hashCode ^
      selectedIndex.hashCode ^
      isTimerRunning.hashCode;
}

/// 任务页面 ViewModel
class TaskViewModel extends StateNotifier<TaskPageState> {
  TaskViewModel() : super(TaskPageState.initial());

  /// 更新倒计时时间
  void updateCountdownTime(String time) {
    state = state.copyWith(countdownTime: time);
  }

  /// 设置选中索引
  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  /// 开始/停止计时器
  void toggleTimer() {
    state = state.copyWith(isTimerRunning: !state.isTimerRunning);
  }

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

  /// 刷新推荐任务
  Future<void> refreshRecommendedTasks() async {
    await safeAsync(() async {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      // 这里可以调用API获取新任务
      // final tasks = await taskRepository.getRecommendedTasks();
      // state = state.copyWith(recommendedTasks: tasks);
    });
  }

  /// 完成任务
  Future<void> completeTask(String taskId) async {
    await safeAsync(() async {
      // 模拟完成任务
      await Future.delayed(const Duration(seconds: 1));
      
      // 更新任务状态
      final updatedTasks = state.recommendedTasks.map((task) {
        if (task.id == taskId) {
          return TaskItem(
            id: task.id,
            title: task.title,
            subtitle: task.subtitle,
            reward: task.reward,
            tags: task.tags,
            avatarColor: task.avatarColor,
            hasEarnButton: false,
          );
        }
        return task;
      }).toList();
      
      state = state.copyWith(recommendedTasks: updatedTasks);
    });
  }

  /// 获取任务详情
  Future<TaskItem?> getTaskDetail(String taskId) async {
    return await safeAsync(() async {
      // 模拟获取任务详情
      await Future.delayed(const Duration(milliseconds: 500));
      
      return state.recommendedTasks.firstWhere(
        (task) => task.id == taskId,
        orElse: () => throw Exception('Task not found'),
      );
    });
  }

  /// 重置状态
  void reset() {
    state = TaskPageState.initial();
  }
}

/// 任务页面 ViewModel Provider
final taskViewModelProvider = StateNotifierProvider<TaskViewModel, TaskPageState>((ref) {
  return TaskViewModel();
});

/// 任务页面状态 Provider
final taskPageStateProvider = Provider<TaskPageState>((ref) {
  return ref.watch(taskViewModelProvider);
});

/// 推荐任务 Provider
final recommendedTasksProvider = Provider<List<TaskItem>>((ref) {
  return ref.watch(taskPageStateProvider).recommendedTasks;
});

/// 倒计时时间 Provider
final countdownTimeProvider = Provider<String>((ref) {
  return ref.watch(taskPageStateProvider).countdownTime;
});

/// 选中索引 Provider
final selectedIndexProvider = Provider<int>((ref) {
  return ref.watch(taskPageStateProvider).selectedIndex;
});

/// 计时器状态 Provider
final isTimerRunningProvider = Provider<bool>((ref) {
  return ref.watch(taskPageStateProvider).isTimerRunning;
});
