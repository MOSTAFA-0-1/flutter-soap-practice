import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

class ConditionFilterTabs extends StatelessWidget {
  const ConditionFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HistoryFilter selected;
  final ValueChanged<HistoryFilter> onChanged;

  static const _tabs = <(HistoryFilter, String)>[
    (HistoryFilter.all, 'All'),
    (HistoryFilter.active, 'Active'),
    (HistoryFilter.resolved, 'Resolved'),
    (HistoryFilter.chronic, 'Chronic'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        for (final (filter, label) in _tabs)
          Expanded(
            child: InkWell(
              onTap: () => onChanged(filter),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected == filter
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: selected == filter ? 2.5 : 1,
                    ),
                  ),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: selected == filter
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        selected == filter ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
