import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/user/publish_task_view_model.dart';

/// 上传验证组件
class UploadVerificationWidget extends StatelessWidget {
  final PublishTaskPageState state;
  final PublishTaskViewModel viewModel;

  const UploadVerificationWidget({
    Key? key,
    required this.state,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              OutlinedButton.icon(
                onPressed: () {
                  viewModel.addUploadRequirement();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加要求'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 显示上传验证要求
          ...state.uploadRequirements.asMap().entries.map((entry) {
            final index = entry.key;
            final requirement = entry.value;
            return _buildUploadRequirementItem(context, index, requirement);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUploadRequirementItem(BuildContext context, int index, UploadRequirement requirement) {
                return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
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
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
                            const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: requirement.description,
              decoration: const InputDecoration(
                hintText: '请输入上传说明（限制30字）',
                border: InputBorder.none,
              ),
              maxLength: 30,
              onChanged: (value) {
                viewModel.updateUploadRequirement(requirement.id, value);
              },
            ),
          ),
                            GestureDetector(
                    onTap: () {
                      viewModel.removeUploadRequirement(requirement.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
