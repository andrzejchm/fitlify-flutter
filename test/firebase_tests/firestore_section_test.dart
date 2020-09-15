import 'package:fitlify_flutter/data/firebase/model/firestore_section.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_doubles/mocks.dart';
import '../test_doubles/stubs.dart';

void main() {
  group("FirestoreSection", () {
    test("id is created if missing", () async {
      //
      final section = FirestoreSection.fromSection(Stubs.section.copyWith(id: null));
      expect(section.id, allOf(isNotNull, isNotEmpty));
    });

    test("null section is mapped to null", () {
      expect(FirestoreSection.fromSection(null), isNull);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
