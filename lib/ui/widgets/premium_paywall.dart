import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/data/services/purchase_service.dart';

class PremiumPaywall extends StatefulWidget {
  final bool softPaywall; // true = can dismiss, false = must buy

  const PremiumPaywall({super.key, this.softPaywall = true});

  /// Show the paywall as a bottom sheet.
  static Future<bool?> show(BuildContext context, {bool soft = true}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: soft,
      enableDrag: soft,
      builder: (_) => PremiumPaywall(softPaywall: soft),
    );
  }

  @override
  State<PremiumPaywall> createState() => _PremiumPaywallState();
}

class _PremiumPaywallState extends State<PremiumPaywall> {
  bool _loading = false;

  Future<void> _purchase(Future<bool> Function() action) async {
    setState(() => _loading = true);
    final success = await action();
    setState(() => _loading = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.whisperGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Crown icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.deepIndigo, AppColors.softMauve],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Text('👑', style: TextStyle(fontSize: 36)),
                ),
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 20),

              Text(
                'Unlock Premium',
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Get the full Zzz experience',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Benefits list
              ..._benefits.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                AppColors.deepIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(b.$1,
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(b.$2, style: AppTextStyles.bodyMedium),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 24),

              // Annual plan
              _PlanButton(
                label: 'Annual',
                price: '\$19.99 / year',
                savings: 'Save 44%',
                highlighted: true,
                loading: _loading,
                onTap: () =>
                    _purchase(PurchaseService().purchaseAnnual),
              ),

              const SizedBox(height: 10),

              // Monthly plan
              _PlanButton(
                label: 'Monthly',
                price: '\$2.99 / month',
                highlighted: false,
                loading: _loading,
                onTap: () =>
                    _purchase(PurchaseService().purchaseMonthly),
              ),

              const SizedBox(height: 16),

              // Restore
              TextButton(
                onPressed: _loading
                    ? null
                    : () =>
                        _purchase(PurchaseService().restorePurchases),
                child: Text(
                  'Restore Purchases',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              // Close button for soft paywall
              if (widget.softPaywall)
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Maybe later',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static const _benefits = [
    ('🎵', '8 premium sleep sounds'),
    ('📊', 'Full sleep statistics & insights'),
    ('🔔', 'Advanced smart notifications'),
    ('🌙', 'Unlimited sleep tracking history'),
    ('💎', 'Early access to new features'),
  ];
}

class _PlanButton extends StatelessWidget {
  final String label;
  final String price;
  final String? savings;
  final bool highlighted;
  final bool loading;
  final VoidCallback onTap;

  const _PlanButton({
    required this.label,
    required this.price,
    this.savings,
    required this.highlighted,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.deepIndigo : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: highlighted
              ? null
              : Border.all(color: AppColors.whisperGray),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.labelLarge.copyWith(
                          color:
                              highlighted ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      if (savings != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            savings!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: highlighted
                                  ? Colors.white
                                  : AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: highlighted ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (loading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: highlighted ? Colors.white : AppColors.deepIndigo,
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: highlighted ? Colors.white70 : AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
