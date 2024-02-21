import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tell_me/provider/recordsProvider.dart';

import 'record_provider_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('test get records', () {
    test('success state get records ', () {
      final dio = MockDio();

      when(dio.get("/api/v1/record",
              queryParameters: {"page": 1, "question": 7}))
          .thenAnswer((_) async =>
              Response(requestOptions: RequestOptions(), statusCode: 200));
                expect(RecordProvider().getRecords(2), 'success');

    });
  });

}
