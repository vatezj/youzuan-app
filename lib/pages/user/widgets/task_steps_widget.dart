import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/user/publish_task_view_model.dart';

/// 任务步骤组件
class TaskStepsWidget extends StatelessWidget {
  final PublishTaskPageState state;
  final PublishTaskViewModel viewModel;
  final TextEditingController websiteController;

  const TaskStepsWidget({
    Key? key,
    required this.state,
    required this.viewModel,
    required this.websiteController,
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
              OutlinedButton.icon(
                onPressed: () {
                  viewModel.addTaskStep();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加步骤'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 显示任务步骤
          ...state.taskSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildTaskStepItem(context, index, step);
          }).toList(),
          const SizedBox(height: 6),
          TextFormField(
            controller: websiteController,
            decoration: const InputDecoration(
              hintText: '请输入网站网址',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (value) {
              viewModel.updateWebsite(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStepItem(BuildContext context, int index, TaskStep step) {
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
              initialValue: step.description,
              decoration: const InputDecoration(
                hintText: '请输入步骤说明（限制60字）',
                border: InputBorder.none,
              ),
              maxLength: 60,
              onChanged: (value) {
                viewModel.updateTaskStep(step.id, value);
              },
            ),
          ),
                            GestureDetector(
                    onTap: () {
                      viewModel.removeTaskStep(step.id);
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
