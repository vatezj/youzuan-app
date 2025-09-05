import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 任务步骤数据模型
class TaskStep {
  final String id;
  final String description;
  final String? website;
  final bool isImageStep;

  TaskStep({
    required this.id,
    required this.description,
    this.website,
    this.isImageStep = false,
  });

  TaskStep copyWith({
    String? id,
    String? description,
    String? website,
    bool? isImageStep,
  }) {
    return TaskStep(
      id: id ?? this.id,
      description: description ?? this.description,
      website: website ?? this.website,
      isImageStep: isImageStep ?? this.isImageStep,
    );
  }
}

/// 上传验证数据模型
class UploadRequirement {
  final String id;
  final String description;
  final bool isImageRequirement;

  UploadRequirement({
    required this.id,
    required this.description,
    this.isImageRequirement = false,
  });

  UploadRequirement copyWith({
    String? id,
    String? description,
    bool? isImageRequirement,
  }) {
    return UploadRequirement(
      id: id ?? this.id,
      description: description ?? this.description,
      isImageRequirement: isImageRequirement ?? this.isImageRequirement,
    );
  }
}

/// 发布任务页面状态
class PublishTaskPageState extends BaseState {
  // 表单数据
  final String category;
  final String title;
  final String label;
  final String price;
  final String quantity;
  final String timeLimit;
  final String reviewTime;
  final String device;
  final String region;
  final String frequency;
  final String description;
  final String website;
  final bool saveAsTemplate;
  final bool agreeToTerms;

  // 任务步骤
  final List<TaskStep> taskSteps;

  // 上传验证要求
  final List<UploadRequirement> uploadRequirements;

  // 表单验证状态
  final Map<String, String> validationErrors;

  // 提交状态
  final bool isSubmitting;

  const PublishTaskPageState({
    required super.isLoading,
    super.errorMessage,
    this.category = '简单帮忙',
    this.title = '',
    this.label = '',
    this.price = '',
    this.quantity = '',
    this.timeLimit = '交单限时',
    this.reviewTime = '1天',
    this.device = '全部',
    this.region = '全部',
    this.frequency = '每人一次',
    this.description = '',
    this.website = '',
    this.saveAsTemplate = false,
    this.agreeToTerms = false,
    this.taskSteps = const [],
    this.uploadRequirements = const [],
    this.validationErrors = const {},
    this.isSubmitting = false,
  });

  PublishTaskPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? category,
    String? title,
    String? label,
    String? price,
    String? quantity,
    String? timeLimit,
    String? reviewTime,
    String? device,
    String? region,
    String? frequency,
    String? description,
    String? website,
    bool? saveAsTemplate,
    bool? agreeToTerms,
    List<TaskStep>? taskSteps,
    List<UploadRequirement>? uploadRequirements,
    Map<String, String>? validationErrors,
    bool? isSubmitting,
  }) {
    return PublishTaskPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      category: category ?? this.category,
      title: title ?? this.title,
      label: label ?? this.label,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      timeLimit: timeLimit ?? this.timeLimit,
      reviewTime: reviewTime ?? this.reviewTime,
      device: device ?? this.device,
      region: region ?? this.region,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      website: website ?? this.website,
      saveAsTemplate: saveAsTemplate ?? this.saveAsTemplate,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      taskSteps: taskSteps ?? this.taskSteps,
      uploadRequirements: uploadRequirements ?? this.uploadRequirements,
      validationErrors: validationErrors ?? this.validationErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// 检查表单是否有效
  bool get isFormValid {
    return title.isNotEmpty &&
        price.isNotEmpty &&
        quantity.isNotEmpty &&
        description.isNotEmpty &&
        agreeToTerms &&
        validationErrors.isEmpty;
  }

  /// 获取提交按钮文本
  String get submitButtonText {
    if (isSubmitting) return '提交中...';
    if (title.isEmpty) return '请输入标题';
    if (!isFormValid) return '请完善信息';
    return '发布任务';
  }

  /// 获取提交按钮颜色
  Color get submitButtonColor {
    if (isFormValid && !isSubmitting) return Colors.blue;
    return Colors.grey;
  }
}

/// 发布任务页面 ViewModel
class PublishTaskViewModel extends StateNotifier<PublishTaskPageState> {
  PublishTaskViewModel() : super(const PublishTaskPageState(
        isLoading: false,
      ));

  // 选项列表
  static const List<String> categories = ['简单帮忙', '电商回收', '游戏试玩', '注册下载', '其他'];
  static const List<String> timeLimits = ['交单限时', '1小时', '3小时', '6小时', '12小时', '1天', '3天'];
  static const List<String> reviewTimes = ['1天', '2天', '3天', '7天'];
  static const List<String> devices = ['全部', '安卓', '苹果'];
  static const List<String> regions = ['全部', '指定'];
  static const List<String> frequencies = ['每人一次', '每日一次', '每人三次', '店铺一次'];

  /// 更新分类
  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  /// 更新标题
  void updateTitle(String title) {
    state = state.copyWith(title: title);
    _validateTitle(title);
  }

  /// 更新标签
  void updateLabel(String label) {
    state = state.copyWith(label: label);
  }

  /// 更新单价
  void updatePrice(String price) {
    state = state.copyWith(price: price);
    _validatePrice(price);
  }

  /// 更新数量
  void updateQuantity(String quantity) {
    state = state.copyWith(quantity: quantity);
    _validateQuantity(quantity);
  }

  /// 更新限时
  void updateTimeLimit(String timeLimit) {
    state = state.copyWith(timeLimit: timeLimit);
  }

  /// 更新审核时间
  void updateReviewTime(String reviewTime) {
    state = state.copyWith(reviewTime: reviewTime);
  }

  /// 更新设备
  void updateDevice(String device) {
    state = state.copyWith(device: device);
  }

  /// 更新地区
  void updateRegion(String region) {
    state = state.copyWith(region: region);
  }

  /// 更新限次
  void updateFrequency(String frequency) {
    state = state.copyWith(frequency: frequency);
  }

  /// 更新任务说明
  void updateDescription(String description) {
    state = state.copyWith(description: description);
    _validateDescription(description);
  }

  /// 更新网站
  void updateWebsite(String website) {
    state = state.copyWith(website: website);
  }

  /// 切换保存为模板
  void toggleSaveAsTemplate() {
    state = state.copyWith(saveAsTemplate: !state.saveAsTemplate);
  }

  /// 切换同意条款
  void toggleAgreeToTerms() {
    state = state.copyWith(agreeToTerms: !state.agreeToTerms);
  }

  /// 添加任务步骤
  void addTaskStep() {
    final newStep = TaskStep(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: '',
    );
    state = state.copyWith(
      taskSteps: [...state.taskSteps, newStep],
    );
  }

  /// 更新任务步骤
  void updateTaskStep(String stepId, String description, {String? website}) {
    final updatedSteps = state.taskSteps.map((step) {
      if (step.id == stepId) {
        return step.copyWith(description: description, website: website);
      }
      return step;
    }).toList();
    state = state.copyWith(taskSteps: updatedSteps);
  }

  /// 删除任务步骤
  void removeTaskStep(String stepId) {
    final updatedSteps = state.taskSteps.where((step) => step.id != stepId).toList();
    state = state.copyWith(taskSteps: updatedSteps);
  }

  /// 添加上传验证要求
  void addUploadRequirement() {
    final newRequirement = UploadRequirement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: '',
    );
    state = state.copyWith(
      uploadRequirements: [...state.uploadRequirements, newRequirement],
    );
  }

  /// 更新上传验证要求
  void updateUploadRequirement(String requirementId, String description) {
    final updatedRequirements = state.uploadRequirements.map((req) {
      if (req.id == requirementId) {
        return req.copyWith(description: description);
      }
      return req;
    }).toList();
    state = state.copyWith(uploadRequirements: updatedRequirements);
  }

  /// 删除上传验证要求
  void removeUploadRequirement(String requirementId) {
    final updatedRequirements = state.uploadRequirements
        .where((req) => req.id != requirementId)
        .toList();
    state = state.copyWith(uploadRequirements: updatedRequirements);
  }

  /// 验证标题
  void _validateTitle(String title) {
    final errors = Map<String, String>.from(state.validationErrors);
    if (title.isEmpty) {
      errors['title'] = '请输入任务标题';
    } else if (title.length > 12) {
      errors['title'] = '标题不能超过12个字符';
    } else {
      errors.remove('title');
    }
    state = state.copyWith(validationErrors: errors);
  }

  /// 验证单价
  void _validatePrice(String price) {
    final errors = Map<String, String>.from(state.validationErrors);
    if (price.isEmpty) {
      errors['price'] = '请输入单价';
    } else {
      final priceValue = double.tryParse(price);
      if (priceValue == null || priceValue < 0.20) {
        errors['price'] = '单价不能低于0.20元';
      } else {
        errors.remove('price');
      }
    }
    state = state.copyWith(validationErrors: errors);
  }

  /// 验证数量
  void _validateQuantity(String quantity) {
    final errors = Map<String, String>.from(state.validationErrors);
    if (quantity.isEmpty) {
      errors['quantity'] = '请输入数量';
    } else {
      final quantityValue = int.tryParse(quantity);
      if (quantityValue == null || quantityValue < 30) {
        errors['quantity'] = '数量不能少于30单';
      } else {
        errors.remove('quantity');
      }
    }
    state = state.copyWith(validationErrors: errors);
  }

  /// 验证任务说明
  void _validateDescription(String description) {
    final errors = Map<String, String>.from(state.validationErrors);
    if (description.isEmpty) {
      errors['description'] = '请输入任务说明';
    } else if (description.length > 50) {
      errors['description'] = '任务说明不能超过50个字符';
    } else {
      errors.remove('description');
    }
    state = state.copyWith(validationErrors: errors);
  }

  /// 提交任务
  Future<void> submitTask() async {
    if (!state.isFormValid) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 收集任务数据
      final taskData = {
        'category': state.category,
        'title': state.title,
        'label': state.label,
        'price': double.tryParse(state.price) ?? 0.0,
        'quantity': int.tryParse(state.quantity) ?? 0,
        'timeLimit': state.timeLimit,
        'reviewTime': state.reviewTime,
        'device': state.device,
        'region': state.region,
        'frequency': state.frequency,
        'description': state.description,
        'website': state.website,
        'taskSteps': state.taskSteps.map((step) => {
          'description': step.description,
          'website': step.website,
          'isImageStep': step.isImageStep,
        }).toList(),
        'uploadRequirements': state.uploadRequirements.map((req) => {
          'description': req.description,
          'isImageRequirement': req.isImageRequirement,
        }).toList(),
        'saveAsTemplate': state.saveAsTemplate,
      };

      // 这里可以调用实际的API
      print('提交任务数据: $taskData');

      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '提交失败: $e',
      );
    }
  }

  /// 重置表单
  void resetForm() {
    state = const PublishTaskPageState(
      isLoading: false,
    );
  }
}

/// Provider 定义
final publishTaskPageStateProvider = StateNotifierProvider<PublishTaskViewModel, PublishTaskPageState>(
  (ref) => PublishTaskViewModel(),
);

final publishTaskViewModelProvider = Provider<PublishTaskViewModel>(
  (ref) => ref.read(publishTaskPageStateProvider.notifier),
);
