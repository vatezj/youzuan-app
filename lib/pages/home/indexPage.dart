import 'package:flutter/material.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/task/taskdetailPage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/home/task_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';
import 'package:flutter_demo/core/mvvm/direct_lifecycle.dart';

class IndexPage extends HookConsumerWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Hooks 管理状态
    final timerController = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    // 监听 ViewModel 状态
    final taskState = ref.watch(taskPageStateProvider);
    final taskViewModel = ref.read(taskViewModelProvider.notifier);

    // 直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: '首页',
      onResume: () {
        print('-------------------------首页 onResume');
        // 页面恢复时的逻辑
      },
      onInactive: () {
        print('-------------------------首页 onInactive');
        // 页面变为非活跃时的逻辑
      },
      onHide: () {
        print('-------------------------首页 onHide');
        // 页面隐藏时的逻辑
      },
      onShow: () {
        print('-------------------------首页 onShow');
        // 页面显示时的逻辑
      },
      onPause: () {
        print('-------------------------首页 onPause');
        // 页面暂停时的逻辑
      },
      onRestart: () {
        print('-------------------------首页 onRestart');
        // 页面重启时的逻辑
      },
      onDetach: () {
        print('-------------------------首页 onDetach');
        // 页面分离时的逻辑
      },
      onInit: () {
        print('-------------------------首页 onInit');
        // 页面初始化时的逻辑
        Future.microtask(() {
          taskViewModel.refreshRecommendedTasks();
        });
      },
      onDispose: () {
        print('-------------------------首页 onDispose');
        // 页面销毁时的逻辑
      },
      onPageShow: () {
        print('-------------------------首页 onPageShow (页面可见)');
        // 页面变为可见时的逻辑
      },
      onPageHide: () {
        print('-------------------------首页 onPageHide (页面不可见)');
        // 页面变为不可见时的逻辑
      },
    );

    // Tab 页面生命周期管理
    useEffect(() {
      // 注册 Tab 页面回调
      TabViewModel.registerPageCallbacks(
        'IndexPage',
        onPageShow: () {
          print('-------------------------首页 Tab onPageShow (从其他Tab切换过来)');
          // Tab 页面显示时的逻辑
        },
        onPageHide: () {
          print('-------------------------首页 Tab onPageHide (切换到其他Tab)');
          // Tab 页面隐藏时的逻辑
        },
      );

      return () {
        TabViewModel.unregisterPageCallbacks('IndexPage');
      };
    }, []);

    // 启动计时器
    useEffect(() {
      timerController.repeat();
      return () {
        timerController.stop();
      };
    }, []);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildActionButtons(taskState, taskViewModel),
                  _buildSprintPrize(),
                  _buildRecommendedTasks(context, taskState, taskViewModel),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF9A56),
            Color(0xFFFF6B35),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '发布任务',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.yellow.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '人人都是雇主',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      TaskPageState taskState, TaskViewModel taskViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: Icons.assignment,
            label: '独家任务',
            color: const Color(0xFF4FC3F7),
            onTap: () => taskViewModel.setSelectedIndex(0),
          ),
          _buildTimerButton(taskState, taskViewModel),
          _buildActionButton(
            icon: Icons.emoji_events,
            label: '冲刺大奖',
            color: const Color(0xFF9C27B0),
            onTap: () => taskViewModel.setSelectedIndex(2),
          ),
          _buildActionButton(
            icon: Icons.people,
            label: '收徒赚钱',
            color: const Color(0xFFE91E63),
            onTap: () => taskViewModel.setSelectedIndex(3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.8),
                  color,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerButton(
      TaskPageState taskState, TaskViewModel taskViewModel) {
    return GestureDetector(
      onTap: () => taskViewModel.toggleTimer(),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFB74D),
                  Color(0xFFFF9800),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_yen,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              taskState.countdownTime,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprintPrize() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFF9A56),
            Color(0xFFFF6B35),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.yellow,
            size: 32,
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2000人',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '冲刺大奖',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'GO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedTasks(
      BuildContext context, TaskPageState taskState, TaskViewModel taskViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '推荐任务',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => taskViewModel.refreshRecommendedTasks(),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (taskState.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else
          ...taskState.recommendedTasks.map((task) => _buildTaskItem(
                context,
                task,
                taskViewModel,
              )),
      ],
    );
  }

  Widget _buildTaskItem( BuildContext context, TaskItem task, TaskViewModel taskViewModel) {
    // 根据颜色字符串获取Color对象
    Color getAvatarColor(String colorString) {
      switch (colorString) {
        case 'blue':
          return Colors.blue;
        case 'red':
          return Colors.red;
        case 'purple':
          return Colors.purple;
        case 'green':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        context.navigateToNonTab(TaskDetailPage);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: getAvatarColor(task.avatarColor),
              child: const Icon(
                Icons.task_alt,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: task.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Text(
              task.reward,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "home_timer",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {},
          child: const Icon(Icons.access_time, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "home_chat",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {},
          child: const Icon(Icons.chat, color: Colors.white),
        ),
      ],
    );
  }
}
