import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weight_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/weight_input_dialog.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeightProvider>().loadWeights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('FitTracker'),
        centerTitle: true,
      ),
      body: Consumer<WeightProvider>(
        builder: (context, weightProvider, child) {
          if (weightProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Weight Card
                _buildCurrentWeightCard(weightProvider),
                const SizedBox(height: 16),
                
                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 16),
                
                // Recent Entries
                _buildRecentEntries(weightProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentWeightCard(WeightProvider provider) {
    final currentWeight = provider.currentWeight;
    final weightChange = provider.weightChange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Current Weight',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.subtextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentWeight != null ? '${currentWeight.toStringAsFixed(1)} kg' : 'No data',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            if (weightChange != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: weightChange >= 0 ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)} kg',
                  style: TextStyle(
                    color: weightChange >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Log Weight',
            onPressed: () => _showWeightInputDialog(),
            icon: Icons.monitor_weight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: 'Take Photo',
            onPressed: () {
              // TODO: Implement photo capture
            },
            icon: Icons.camera_alt,
            isSecondary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentEntries(WeightProvider provider) {
    if (provider.weights.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.monitor_weight_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No weight entries yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.subtextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap "Log Weight" to get started!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.subtextColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Entries',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.weights.take(5).map((entry) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: (0.1 * 255).round().toDouble()),
                child: const Icon(
                  Icons.monitor_weight,
                  color: AppTheme.primaryColor,
                ),
              ),
              title: Text('${entry.weight.toStringAsFixed(1)} kg'),
              subtitle: Text(
                '${entry.date.day}/${entry.date.month}/${entry.date.year}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => provider.deleteWeight(entry.id),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showWeightInputDialog() {
    showDialog(
      context: context,
      builder: (context) => const WeightInputDialog(),
    );
  }
}