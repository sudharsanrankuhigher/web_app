import 'package:flutter_test/flutter_test.dart';
import 'package:webapp/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('BannerViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
