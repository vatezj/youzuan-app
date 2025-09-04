import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PublishTaskPage extends StatefulWidget {
  const PublishTaskPage({Key? key}) : super(key: key);

  @override
  State<PublishTaskPage> createState() => _PublishTaskPageState();
}

class _PublishTaskPageState extends State<PublishTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _labelController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepDescriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _uploadDescriptionController = TextEditingController();

  String selectedCategory = '简单帮忙';
  String selectedTimeLimit = '交单限时';
  String selectedReviewTime = '1天';
  String selectedDevice = '全部';
  String selectedRegion = '全部';
  String selectedFrequency = '每人一次';
  bool saveAsTemplate = false;
  bool agreeToTerms = false;

  final List<String> categories = ['简单帮忙', '电商回收', '游戏试玩', '注册下载', '其他'];
  final List<String> timeLimits = ['交单限时', '1小时', '3小时', '6小时', '12小时', '1天', '3天'];
  final List<String> reviewTimes = ['1天', '2天', '3天', '7天'];
  final List<String> devices = ['全部', '安卓', '苹果'];
  final List<String> regions = ['全部', '指定'];
  final List<String> frequencies = ['每人一次', '每日一次', '每人三次', '店铺一次'];

  @override
  void dispose() {
    _titleController.dispose();
    _labelController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _stepDescriptionController.dispose();
    _websiteController.dispose();
    _uploadDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTaskInfoSection(),
                    _buildTaskDescriptionSection(),
                    _buildTaskStepsSection(),
                    _buildUploadVerificationSection(),
                    _buildTermsSection(),
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
                    '发布任务',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to my store
                },
                child: const Text(
                  '我的店铺',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInfoSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                '任务信息',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Checkbox(
                    value: saveAsTemplate,
                    onChanged: (value) {
                      setState(() {
                        saveAsTemplate = value ?? false;
                      });
                    },
                  ),
                  const Text('保存模版'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      // Show template selection
                    },
                    child: const Text('选择模版'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: '分类',
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
          _buildFormField(
            label: '标题',
            child: TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '项目核心标题，12字内',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLength: 12,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入任务标题';
                }
                return null;
              },
            ),
          ),
          _buildFormField(
            label: '标签',
            child: TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(
                hintText: '推广的应用名字',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          _buildFormField(
            label: '单价',
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      hintText: '0.20元起',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
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
                ),
                const SizedBox(width: 8),
                const Text('元'),
                const SizedBox(width: 8),
                const Text(
                  '支持两位小数',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _buildFormField(
            label: '数量',
            child: TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                hintText: '最少30单',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          _buildFormField(
            label: '限时',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedTimeLimit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: timeLimits.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTimeLimit = value!;
                    });
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  '用户交单时间\n超时未交单释放名额',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _buildFormField(
            label: '审核',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedReviewTime,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: reviewTimes.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedReviewTime = value!;
                    });
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  '任务审核时间\n超时系统自动审核',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _buildFormField(
            label: '设备',
            child: Row(
              children: devices.map((device) {
                final isSelected = selectedDevice == device;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDevice = device;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          device,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildFormField(
            label: '地区',
            child: Row(
              children: regions.map((region) {
                final isSelected = selectedRegion == region;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRegion = region;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          region,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildFormField(
            label: '限次',
            child: Wrap(
              spacing: 8,
              children: frequencies.map((frequency) {
                final isSelected = selectedFrequency == frequency;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFrequency = frequency;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      frequency,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDescriptionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: '一句话简单描述任务要求（限制50字）',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            maxLines: 3,
            maxLength: 50,
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

  Widget _buildTaskStepsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                '任务步骤',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Add image step
                },
                child: const Text('增加图文步骤'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  // Add website step
                },
                child: const Text('增加网址步骤'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _stepDescriptionController,
                    decoration: const InputDecoration(
                      hintText: '请输入步骤说明（限制60字）',
                      border: InputBorder.none,
                    ),
                    maxLength: 60,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Delete step
                    _stepDescriptionController.clear();
                  },
                  child: const Text('删除'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              hintText: '请输入网站网址',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadVerificationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.upload, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                '上传验证',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Add collection image
                },
                child: const Text('增加收集截图'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  // Add collection info
                },
                child: const Text('增加收集信息'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _uploadDescriptionController,
                    decoration: const InputDecoration(
                      hintText: '请输入上传说明（限制30字）',
                      border: InputBorder.none,
                    ),
                    maxLength: 30,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Delete upload requirement
                    _uploadDescriptionController.clear();
                  },
                  child: const Text('删除'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    agreeToTerms = value ?? false;
                  });
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
          const SizedBox(height: 8),
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

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _submitTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '请输入标题',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _submitTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先同意发布规则'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect all form data
    final taskData = {
      'category': selectedCategory,
      'title': _titleController.text,
      'label': _labelController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'timeLimit': selectedTimeLimit,
      'reviewTime': selectedReviewTime,
      'device': selectedDevice,
      'region': selectedRegion,
      'frequency': selectedFrequency,
      'description': _descriptionController.text,
      'stepDescription': _stepDescriptionController.text,
      'website': _websiteController.text,
      'uploadDescription': _uploadDescriptionController.text,
      'saveAsTemplate': saveAsTemplate,
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('任务发布成功，等待审核'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or to task list
    Navigator.of(context).pop();
  }
}