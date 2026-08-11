import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillx/core/theme/app_colors.dart';
import 'package:skillx/shared/widgets/skill_chip.dart';

// Foundation smoke tests. Full widget/integration coverage lands in Phase 13.
void main() {
  testWidgets('SkillChip renders its label and remove action', (tester) async {
    var removed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkillChip(
            label: 'Python',
            variant: SkillChipVariant.teach,
            onRemove: () => removed = true,
          ),
        ),
      ),
    );

    expect(find.text('Python'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    expect(removed, isTrue);
  });

  test('design tokens are locked to the brand palette', () {
    expect(AppColors.primary, const Color(0xFF2563EB));
    expect(AppColors.teal, const Color(0xFF0D9488));
  });
}
