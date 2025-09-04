import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/category/category_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';
import 'package:flutter_demo/core/mvvm/direct_lifecycle.dart';

class CategoryPage extends HookConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 ViewModel 状态
    final categoryState = ref.watch(categoryPageStateProvider);
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);

    // 直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: '任务大厅',
      onResume: () {
        print('-------------------------任务大厅 onResume');
      },
      onInactive: () {
        print('-------------------------任务大厅 onInactive');
      },
      onHide: () {
        print('-------------------------任务大厅 onHide');
      },
      onShow: () {
        print('-------------------------任务大厅 onShow');
      },
      onPause: () {
        print('-------------------------任务大厅 onPause');
      },
      onRestart: () {
        print('-------------------------任务大厅 onRestart');
      },
      onDetach: () {
        print('-------------------------任务大厅 onDetach');
      },
      onInit: () {
        print('-------------------------任务大厅 onInit');
        // 页面初始化时刷新任务列表
        Future.microtask(() {
          categoryViewModel.refreshTasks();
        });
      },
      onDispose: () {
        print('-------------------------任务大厅 onDispose');
      },
      onPageShow: () {
        print('-------------------------任务大厅 onPageShow (页面可见)');
      },
      onPageHide: () {
        print('-------------------------任务大厅 onPageHide (页面不可见)');
      },
    );

    // Tab 页面生命周期管理
    useEffect(() {
      // 注册 Tab 页面回调
      TabViewModel.registerPageCallbacks('CategoryPage',
        onPageShow: () {
          print('-------------------------任务大厅 Tab onPageShow (从其他Tab切换过来)');
        },
        onPageHide: () {
          print('-------------------------任务大厅 Tab onPageHide (切换到其他Tab)');
        },
      );

      return () {
        TabViewModel.unregisterPageCallbacks('CategoryPage');
      };
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterTabs(categoryState, categoryViewModel),
          _buildFeaturedTask(categoryState),
          Expanded(
            child: _buildTaskList(categoryState, categoryViewModel),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF4FC3F7),
            Color(0xFF29B6F6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '任务大厅',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '筛选价格',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(CategoryPageState categoryState, CategoryViewModel categoryViewModel) {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categoryState.filterTabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == categoryState.selectedFilterIndex;
          return GestureDetector(
            onTap: () {
              categoryViewModel.setSelectedFilterIndex(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        categoryState.filterTabs[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.orange : Colors.black87,
                        ),
                      ),
                      if (index == 0)
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: isSelected ? Colors.orange : Colors.black87,
                        ),
                      if (index == 2) // 置顶 tab has notification
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '8',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 20,
                      color: Colors.orange,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedTask(CategoryPageState categoryState) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '头条',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              categoryState.featuredTaskTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '${categoryState.featuredTaskReward.toStringAsFixed(2)}元',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(CategoryPageState categoryState, CategoryViewModel categoryViewModel) {
    if (categoryState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categoryState.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(categoryState.tasks[index], categoryViewModel);
      },
    );
  }

  Widget _buildTaskCard(CategoryTaskItem task, CategoryViewModel categoryViewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              if (task.hasAnnualCard)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '年卡',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.completedCount}人已赚，剩余${task.remainingCount}个',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: task.tags.map((tag) {
                    final isPush = tag == '推';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPush ? Colors.green : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: isPush ? Colors.white : Colors.blue.shade700,
                          fontWeight: isPush ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Text(
            '+${task.reward.toStringAsFixed(2)}元',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "category_my_registration",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {},
          child: const Text(
            '我的\n报名',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "category_games",
          mini: true,
          backgroundColor: Colors.red,
          onPressed: () {},
          child: const Icon(
            Icons.games,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
