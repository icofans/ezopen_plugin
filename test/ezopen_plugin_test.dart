import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezopen_plugin/ezopen_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('ezopen_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
