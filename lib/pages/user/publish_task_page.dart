import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/router/route_helper_static.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/user/publish_task_view_model.dart';
import 'package:flutter_demo/pages/user/widgets/form_field_widget.dart';
import 'package:flutter_demo/pages/user/widgets/input_field_widget.dart';
import 'package:flutter_demo/pages/user/widgets/selector_widget.dart';
import 'package:flutter_demo/pages/user/widgets/task_steps_widget.dart';
import 'package:flutter_demo/pages/user/widgets/upload_verification_widget.dart';
import 'package:flutter_demo/pages/user/widgets/card_container_widget.dart';

class PublishTaskPage extends HookConsumerWidget {
  const PublishTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publishTaskState = ref.watch(publishTaskPageStateProvider);
    final publishTaskViewModel = ref.read(publishTaskViewModelProvider);

    // 使用 Hooks 管理 TextEditingController
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController =
        useTextEditingController(text: publishTaskState.title);
    final labelController =
        useTextEditingController(text: publishTaskState.label);
    final priceController =
        useTextEditingController(text: publishTaskState.price);
    final quantityController =
        useTextEditingController(text: publishTaskState.quantity);
    final descriptionController =
        useTextEditingController(text: publishTaskState.description);
    final websiteController =
        useTextEditingController(text: publishTaskState.website);

    // 监听状态变化，更新控制器
    useEffect(() {
      titleController.text = publishTaskState.title;
      return null;
    }, [publishTaskState.title]);

    useEffect(() {
      labelController.text = publishTaskState.label;
      return null;
    }, [publishTaskState.label]);

    useEffect(() {
      priceController.text = publishTaskState.price;
      return null;
    }, [publishTaskState.price]);

    useEffect(() {
      quantityController.text = publishTaskState.quantity;
      return null;
    }, [publishTaskState.quantity]);

    useEffect(() {
      descriptionController.text = publishTaskState.description;
      return null;
    }, [publishTaskState.description]);

    useEffect(() {
      websiteController.text = publishTaskState.website;
      return null;
    }, [publishTaskState.website]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTaskInfoSection(
                        context,
                        publishTaskState,
                        publishTaskViewModel,
                        titleController,
                        labelController,
                        priceController,
                        quantityController),
                    _buildTaskDescriptionSection(context, publishTaskState,
                        publishTaskViewModel, descriptionController),
                    TaskStepsWidget(
                      state: publishTaskState,
                      viewModel: publishTaskViewModel,
                      websiteController: websiteController,
                    ),
                    UploadVerificationWidget(
                      state: publishTaskState,
                      viewModel: publishTaskViewModel,
                    ),
                    _buildTermsSection(
                        context, publishTaskState, publishTaskViewModel),
                    _buildSubmitButton(
                        context, publishTaskState, publishTaskViewModel),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFFf093fb),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => RouteHelperStatic.navigateBack(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '发布任务',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to my store
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '创建您的专属任务，让更多人参与',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInfoSection(
      BuildContext context,
      PublishTaskPageState state,
      PublishTaskViewModel viewModel,
      TextEditingController titleController,
      TextEditingController labelController,
      TextEditingController priceController,
      TextEditingController quantityController) {
    return CardContainerWidget(
      title: '任务信息',
      titleIcon: Icons.assignment_outlined,
      titleTrailing: Container(
        decoration: BoxDecoration(
          color: state.saveAsTemplate
              ? const Color(0xFF667eea).withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: state.saveAsTemplate,
              onChanged: (value) {
                viewModel.toggleSaveAsTemplate();
              },
              activeColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text(
              '保存模版',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Show template selection
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '模版',
                  style: TextStyle(
                    color: Color(0xFF667eea),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldWidget(
            label: '分类',
            child: BottomSheetSelectorWidget(
              title: '分类',
              currentValue: state.category,
              options: PublishTaskViewModel.categories,
              onSelected: (value) => viewModel.updateCategory(value),
              icon: Icons.category_outlined,
            ),
          ),
          FormFieldWidget(
            label: '标题',
            child: InputFieldWidget(
              controller: titleController,
              hintText: '项目核心标题，12字内',
              icon: Icons.title,
              errorText: state.validationErrors['title'],
              maxLength: 12,
              onChanged: (value) => viewModel.updateTitle(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入任务标题';
                }
                return null;
              },
            ),
          ),
          FormFieldWidget(
            label: '标签',
            child: InputFieldWidget(
              controller: labelController,
              hintText: '推广的应用名字',
              icon: Icons.label_outline,
              onChanged: (value) => viewModel.updateLabel(value),
            ),
          ),
          FormFieldWidget(
            label: '单价',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFieldWithUnitWidget(
                  controller: priceController,
                  hintText: '0.20元起',
                  icon: Icons.attach_money,
                  unit: '元',
                  errorText: state.validationErrors['price'],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (value) => viewModel.updatePrice(value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入单价';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0.20) {
                      return '单价不能低于0.20元';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange.withOpacity(0.1),
                        Colors.orange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '支持两位小数',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FormFieldWidget(
            label: '数量',
            child: InputFieldWithUnitWidget(
              controller: quantityController,
              hintText: '最少30单',
              icon: Icons.numbers,
              unit: '单',
              errorText: state.validationErrors['quantity'],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => viewModel.updateQuantity(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入数量';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity < 30) {
                  return '数量不能少于30单';
                }
                return null;
              },
            ),
          ),
          FormFieldWidget(
            label: '限时',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetSelectorWidget(
                  title: '限时',
                  currentValue: state.timeLimit,
                  options: PublishTaskViewModel.timeLimits,
                  onSelected: (value) => viewModel.updateTimeLimit(value),
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '用户交单时间\n超时未交单释放名额',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FormFieldWidget(
            label: '审核',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetSelectorWidget(
                  title: '审核时间',
                  currentValue: state.reviewTime,
                  options: PublishTaskViewModel.reviewTimes,
                  onSelected: (value) => viewModel.updateReviewTime(value),
                  icon: Icons.verified_user,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '任务审核时间\n超时系统自动审核',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FormFieldWidget(
            label: '设备',
            child: RadioButtonGroupWidget(
              label: '设备',
              currentValue: state.device,
              options: PublishTaskViewModel.devices,
              onChanged: (value) => viewModel.updateDevice(value),
              isHorizontal: true,
            ),
          ),
          FormFieldWidget(
            label: '地区',
            child: RadioButtonGroupWidget(
              label: '地区',
              currentValue: state.region,
              options: PublishTaskViewModel.regions,
              onChanged: (value) => viewModel.updateRegion(value),
              isHorizontal: true,
            ),
          ),
          FormFieldWidget(
            label: '限次',
            child: RadioButtonGroupWidget(
              label: '限次',
              currentValue: state.frequency,
              options: PublishTaskViewModel.frequencies,
              onChanged: (value) => viewModel.updateFrequency(value),
              isHorizontal: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDescriptionSection(
      BuildContext context,
      PublishTaskPageState state,
      PublishTaskViewModel viewModel,
      TextEditingController descriptionController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description, color: Colors.green),
              SizedBox(width: 8),
              Text(
                '任务说明',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: '一句话简单描述任务要求（限制50字）',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
              errorText: state.validationErrors['description'],
            ),
            maxLines: 3,
            maxLength: 50,
            onChanged: (value) {
              viewModel.updateDescription(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入任务说明';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(BuildContext context, PublishTaskPageState state,
      PublishTaskViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: state.agreeToTerms,
                onChanged: (value) {
                  viewModel.toggleAgreeToTerms();
                },
              ),
              const Text('我已阅读、理解并同意'),
              GestureDetector(
                onTap: () {
                  // Show publishing rules
                },
                child: const Text(
                  '《发布规则》',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            '购买季卡、年卡的用户优先审核任务',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '提示：平台禁止发布黄赌毒、诈骗及涉政等一切法律禁止之内容，另禁止发布与平台同性质的软件、app或网站，违者将冻结账户，谢谢！',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, PublishTaskPageState state,
      PublishTaskViewModel viewModel) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: state.isFormValid && !state.isSubmitting
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                    Color(0xFFf093fb),
                  ],
                  stops: [0.0, 0.5, 1.0],
                )
              : null,
          color: state.isFormValid && !state.isSubmitting
              ? null
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(24),
          boxShadow: state.isFormValid && !state.isSubmitting
              ? [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: const Color(0xFF764ba2).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: state.isSubmitting
              ? null
              : () => _submitTask(context, state, viewModel),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: state.isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '提交中...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      state.submitButtonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _submitTask(BuildContext context, PublishTaskPageState state,
      PublishTaskViewModel viewModel) async {
    if (!state.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先同意发布规则'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await viewModel.submitTask();

    if (context.mounted) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('任务发布成功，等待审核'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
