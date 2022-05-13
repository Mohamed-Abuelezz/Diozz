import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'package:diozz/diozz.dart';
import 'package:palestine_console/palestine_console.dart';

void main() {
  test('Diozz Test', () async {
    dynamic req = await Diozz().sendDiozz(
      url: 'https://khabeerha.com/api/index',
      methodType: 'GET',
      dioBody: null,
      dioHeaders: null,
    );
   Print.green(req.toString());
  });
}
