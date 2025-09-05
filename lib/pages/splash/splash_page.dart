import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/mvvm/auth_view_model.dart';
import 'package:flutter_demo/core/router/route_helper_static.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/pages/BottomMenuBarPage.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听认证状态
    final authState = ref.watch(authStateProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    // 动画控制器
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );
    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
      ),
    );

    // 启动动画
    useEffect(() {
      animationController.forward();
      
      // 测试静态路由帮助类
      Future.delayed(const Duration(seconds: 1), () {
        print('=== SplashPage 中测试静态路由帮助类 ===');
        print('Navigator 可用: ${RouteHelperStatic.isNavigatorAvailable}');
        print('当前页面: ${RouteHelperStatic.getCurrentRouteName()}');
        print('页面栈深度: ${RouteHelperStatic.getStackDepth()}');
        print('=====================================');
      });
      
      return null;
    }, []);

    // 检查认证状态
    useEffect(() {
      Future.microtask(() {
        authViewModel.checkAuthStatus();
      });
      return null;
    }, []);

    // 根据认证状态进行页面跳转
    useEffect(() {
      if (authState.authStatus == AuthStatus.authenticated) {
        // 已认证，跳转到首页
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BottomMenuBarPage(),
              ),
            );
          }
        });
      } else if (authState.authStatus == AuthStatus.unauthenticated) {
        // 未认证，跳转到登录页

            Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BottomMenuBarPage(),
              ),
            );
          }
        });
        // Future.delayed(const Duration(seconds: 1), () {
        //   if (context.mounted) {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) => const LoginPage(),
        //       ),
        //     );
        //   }
        // });
      }
      return null;
    }, [authState.authStatus]);

    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo动画
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnimation,
                    child: Opacity(
                      opacity: fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.work,
                          size: 60,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // 应用名称动画
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          '优赚',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '人人都是雇主',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // 加载指示器
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: fadeAnimation,
                    child: Column(
                      children: [
                        if (authState.isLoading)
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          )
                        else
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          _getLoadingText(authState.authStatus),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取加载文本
  String _getLoadingText(AuthStatus status) {
    switch (status) {
      case AuthStatus.initial:
        return '正在启动...';
      case AuthStatus.loading:
        return '正在检查登录状态...';
      case AuthStatus.authenticated:
        return '欢迎回来！';
      case AuthStatus.unauthenticated:
        return '请先登录';
    }
  }
}
