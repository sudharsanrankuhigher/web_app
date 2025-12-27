import 'package:flutter_test/flutter_test.dart';
import 'package:webapp/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RolesViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
