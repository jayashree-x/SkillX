import 'package:flutter_test/flutter_test.dart';
import 'package:skillx/features/paths/domain/learning_path.dart';

void main() {
  PathDetail make({required int unlockedUpTo, bool complete = false}) => PathDetail(
        id: 'p',
        title: 'T',
        skillName: 'S',
        teacherName: 'M',
        modules: const [
          PathModule(id: '1', order: 1, title: 'One'),
          PathModule(id: '2', order: 2, title: 'Two'),
          PathModule(id: '3', order: 3, title: 'Three'),
        ],
        unlockedUpTo: unlockedUpTo,
        currentModuleOrder: unlockedUpTo,
        isComplete: complete,
      );

  test('lock states derive from unlockedUpTo', () {
    final p = make(unlockedUpTo: 2);
    expect(p.stateOf(p.modules[0]), ModuleState.completed); // order 1 < 2
    expect(p.stateOf(p.modules[1]), ModuleState.available); // order 2 == 2
    expect(p.stateOf(p.modules[2]), ModuleState.locked); // order 3 > 2
    expect(p.completedCount, 1);
    expect(p.progress, closeTo(1 / 3, 1e-9));
  });

  test('a completed path marks every module complete', () {
    final p = make(unlockedUpTo: 3, complete: true);
    expect(p.modules.every((m) => p.stateOf(m) == ModuleState.completed), isTrue);
    expect(p.completedCount, 3);
    expect(p.progress, 1.0);
  });
}
