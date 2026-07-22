import 'package:cineswipe/data/services/haptic_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  test('HapticService drops overlapping feedback calls', () async {
    final calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          calls.add(call);
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return null;
        });

    await Future.wait([
      HapticService.light(),
      HapticService.medium(),
      HapticService.heavy(),
    ]);

    expect(calls, hasLength(1));
  });
}
