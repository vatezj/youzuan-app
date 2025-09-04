import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 认证状态枚举
enum AuthStatus {
  initial,    // 初始状态
  loading,    // 加载中
  authenticated,  // 已认证
  unauthenticated, // 未认证
}

/// 认证页面状态类
class AuthState extends BaseState {
  final AuthStatus authStatus;
  final String? token;
  final String? userId;
  final String? username;

  const AuthState({
    super.isLoading,
    super.errorMessage,
    required this.authStatus,
    this.token,
    this.userId,
    this.username,
  });

  factory AuthState.initial() => const AuthState(
        authStatus: AuthStatus.initial,
      );

  @override
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    AuthStatus? authStatus,
    String? token,
    String? userId,
    String? username,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      authStatus: authStatus ?? this.authStatus,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.authStatus == authStatus &&
        other.token == token &&
        other.userId == userId &&
        other.username == username;
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      authStatus.hashCode ^
      token.hashCode ^
      userId.hashCode ^
      username.hashCode;
}

/// 认证 ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState.initial());

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

  /// 检查认证状态
  Future<void> checkAuthStatus() async {
    await safeAsync(() async {
      // 模拟检查认证状态
      await Future.delayed(const Duration(seconds: 2));
      
      // 这里可以添加实际的认证检查逻辑
      // 比如检查本地存储的token、调用API验证等
      
      // 模拟检查结果
      final isAuthenticated = await _checkLocalAuth();
      
      if (isAuthenticated) {
        state = state.copyWith(
          authStatus: AuthStatus.authenticated,
          token: 'mock_token_123',
          userId: 'user_123',
          username: 'link_38',
        );
      } else {
        state = state.copyWith(
          authStatus: AuthStatus.unauthenticated,
        );
      }
    });
  }

  /// 模拟检查本地认证状态
  Future<bool> _checkLocalAuth() async {
    // 这里可以检查SharedPreferences中的token
    // 或者检查其他本地存储的认证信息
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 模拟返回false，表示未登录
    // 在实际应用中，这里应该检查真实的认证状态
    return false;
  }

  /// 登录
  Future<void> login(String username, String password) async {
    await safeAsync(() async {
      // 模拟登录API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟登录成功
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
      );
      
      // 这里可以保存token到本地存储
      await _saveAuthData();
    });
  }

  /// 登出
  Future<void> logout() async {
    await safeAsync(() async {
      // 模拟登出API调用
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 清除认证状态
      state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
        token: null,
        userId: null,
        username: null,
      );
      
      // 清除本地存储的认证数据
      await _clearAuthData();
    });
  }

  /// 保存认证数据到本地
  Future<void> _saveAuthData() async {
    // 这里可以保存token等认证信息到SharedPreferences
    print('保存认证数据到本地存储');
  }

  /// 清除本地认证数据
  Future<void> _clearAuthData() async {
    // 这里可以清除SharedPreferences中的认证信息
    print('清除本地认证数据');
  }

  /// 获取当前认证状态
  bool get isAuthenticated => state.authStatus == AuthStatus.authenticated;
  
  /// 获取当前用户名
  String? get currentUsername => state.username;
  
  /// 获取当前token
  String? get currentToken => state.token;
}

/// 认证 ViewModel Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel();
});

/// 认证状态 Provider
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authViewModelProvider);
});
