import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter/services.dart';
import 'dart:io';

// KeepAlive包装组件
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  final String routeName;

  const KeepAliveWrapper({
    Key? key,
    required this.child,
    required this.routeName,
  }) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用super.build
    print('KeepAliveWrapper build - ${widget.routeName}');
    return widget.child;
  }
}

class BottomMenuBarPage extends HookConsumerWidget {
  final String? initialRoute;
  
  const BottomMenuBarPage({
    Key? key, 
    this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Hooks 管理状态
    final pageController = usePageController();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    
    // 监听 Tab 状态
    final tabState = ref.watch(tabStateProvider);
    final tabViewModel = ref.read(tabViewModelProvider.notifier);
    
    // 初始化 Tab
    useEffect(() {
      if (!tabState.isInitialized) {
        Future.microtask(() {
          tabViewModel.initialize(initialRoute);
        });
      }
      return null;
    }, []);
    
    // 当 Tab 状态变化时，自动跳转到对应页面
    useEffect(() {
      if (tabState.isInitialized && pageController.hasClients) {
        final currentPage = pageController.page?.round() ?? 0;
        if (currentPage != tabState.currentIndex) {
          print('自动跳转到页面: ${tabState.currentIndex}');
          Future.microtask(() {
            pageController.jumpToPage(tabState.currentIndex);
          });
        }
      }
      return null;
    }, [tabState.currentIndex]);
    
    // 页面状态管理
    final navigatorKeys = useMemoized(() => [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ], []);
    
    // 保存所有页面的实例
    final pages = useMemoized(() => [
      Navigator(
        key: navigatorKeys[0],
        onGenerateRoute: (settings) => _generateRoute(context, settings, const IndexPage(), 'IndexPage'),
        initialRoute: 'IndexPage',
      ),
      Navigator(
        key: navigatorKeys[1],
        onGenerateRoute: (settings) => _generateRoute(context, settings, const CategoryPage(), 'CategoryPage'),
        initialRoute: 'CategoryPage',
      ),
      Navigator(
        key: navigatorKeys[2],
        onGenerateRoute: (settings) => _generateRoute(context, settings, const CartPage(), 'CartPage'),
        initialRoute: 'CartPage',
      ),
      Navigator(
        key: navigatorKeys[3],
        onGenerateRoute: (settings) => _generateRoute(context, settings, const MyPage(), 'MyPage'),
        initialRoute: 'MyPage',
      ),
    ], [navigatorKeys, context]);
    
    // 底部导航栏配置
    final navigationItems = useMemoized(() => const [
      NavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: '首页',
      ),
      NavigationItem(
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
        label: '任务大厅',
      ),
      NavigationItem(
        icon: Icons.card_giftcard_outlined,
        activeIcon: Icons.card_giftcard_rounded,
        label: '分红',
      ),
      NavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person_rounded,
        label: '我的',
      ),
    ], []);
    
    // 触发震动反馈
    void _triggerHapticFeedback() {
      // 只在手机端触发震动
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          // 使用轻量级震动反馈，适合Tab切换
          HapticFeedback.lightImpact();
        } catch (e) {
          // 如果震动反馈失败，静默处理
          print('震动反馈失败: $e');
        }
      }
    }
    
    // Tab 点击处理
    void onTabTapped(int index) {
      if (tabState.currentIndex != index) {
        print('点击切换到tab: ${TabRoute.getRouteFromIndex(index)}');
        
        // 添加震动反馈（仅手机端）
        _triggerHapticFeedback();
        
        // 更新 Tab 状态
        Future.microtask(() {
          tabViewModel.switchTab(index);
        });
        
        // 使用动画控制器
        animationController.forward().then((_) {
          animationController.reverse();
        });
      }
    }
    
    // 处理返回按钮
    Future<bool> onWillPop() async {
      final NavigatorState? navigator = navigatorKeys[tabState.currentIndex].currentState;
      
      // 如果当前tab的Navigator可以返回，则返回上一页
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        return false; // 阻止系统返回
      }
      
      // 检查是否是根页面
      final rootNavigator = Navigator.of(context, rootNavigator: true);
      if (!rootNavigator.canPop()) {
        // 如果是根页面，允许退出应用
        print('BottomMenuBarPage是根页面，允许退出应用');
        return true;
      }
      
      // 如果不是根页面，允许返回
      return true;
    }
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        print('PopScope onPopInvokedWithResult - didPop: $didPop');
        if (!didPop) {
          // 只有当系统没有处理返回操作时，才执行我们的自定义返回逻辑
          final shouldPop = await onWillPop();
          print('PopScope - shouldPop: $shouldPop, context.mounted: ${context.mounted}');
          if (shouldPop && context.mounted) {
            // 只有在明确允许返回时才执行返回操作
            print('执行返回操作');
            // 使用SystemNavigator.pop()来退出应用，而不是Navigator.pop()
            SystemNavigator.pop();
          } else {
            print('阻止返回操作');
          }
        } else {
          // 如果系统已经处理了返回操作（didPop为true），不需要做任何额外操作
          print('系统已处理返回操作，无需额外处理');
        }
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            // 只有当状态不同时才更新，避免重复调用
            if (tabState.currentIndex != index) {
              // 添加震动反馈（仅手机端）
              _triggerHapticFeedback();
              
              tabViewModel.switchTab(index);
              print('滑动切换到tab: ${TabRoute.getRouteFromIndex(index)}');
            }
          },
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: tabState.currentIndex,
          onTap: onTabTapped,
          items: navigationItems,
          onHapticFeedback: _triggerHapticFeedback,
        ),
      ),
    );
  }
  
  // 生成路由
  Route<dynamic> _generateRoute(BuildContext context, RouteSettings settings, Widget defaultWidget, String defaultRoute) {
    // 只处理tabs页面
    if (TabRoute.isTabRoute(settings.name ?? '')) {
      // 对于tabs页面，直接返回对应的页面，不创建新的BottomMenuBarPage
      switch (settings.name) {
        case 'IndexPage':
          return MaterialPageRoute(
            builder: (context) => KeepAliveWrapper(
              routeName: 'IndexPage',
              child: const IndexPage(),
            ),
            settings: settings,
          );
        case 'CategoryPage':
          return MaterialPageRoute(
            builder: (context) => KeepAliveWrapper(
              routeName: 'CategoryPage',
              child: const CategoryPage(),
            ),
            settings: settings,
          );
        case 'CartPage':
          return MaterialPageRoute(
            builder: (context) => KeepAliveWrapper(
              routeName: 'CartPage',
              child: const CartPage(),
            ),
            settings: settings,
          );
        case 'MyPage':
          return MaterialPageRoute(
            builder: (context) => KeepAliveWrapper(
              routeName: 'MyPage',
              child: const MyPage(),
            ),
            settings: settings,
          );
        default:
          return MaterialPageRoute(
            builder: (context) => KeepAliveWrapper(
              routeName: defaultRoute,
              child: defaultWidget,
            ),
            settings: RouteSettings(name: defaultRoute),
          );
      }
    } else {
      // 非tabs页面，使用根Navigator跳转
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pushNamed(settings.name!);
        }
      });
      // 返回当前页面
      return MaterialPageRoute(
        builder: (context) => KeepAliveWrapper(
          routeName: defaultRoute,
          child: defaultWidget,
        ),
        settings: RouteSettings(name: defaultRoute),
      );
    }
  }
}

// 自定义底部导航栏组件
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;
  final VoidCallback? onHapticFeedback;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.onHapticFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('CustomBottomNavigationBar build - currentIndex: $currentIndex');
    
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFFFFFFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                (index) => Expanded(
                  child: _buildNavigationItem(context, index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  Widget _buildNavigationItem(BuildContext context, int index) {
    final item = items[index];
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        // 立即触发震动反馈
        onHapticFeedback?.call();
        onTap(index);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 60,
          maxHeight: 70,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected 
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFFA29BFE),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    color: isSelected 
                        ? Colors.white
                        : const Color(0xFF636E72),
                    size: isSelected ? 20 : 18,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : const Color(0xFF636E72),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: isSelected ? 10 : 9,
                ),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 导航项数据模型
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
