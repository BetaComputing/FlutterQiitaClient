import 'package:test/test.dart';

void main() {
  test('テスト', () {
    const actual = 1 + 2;
    const expected = 3;

    expect(actual, equals(expected));
  });
}
