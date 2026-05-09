import 'dart:convert';

import 'package:btgproject/data/models/fund_model.dart';
import 'package:flutter/services.dart';

class FundLocalDataSource {
  Future<List<FundModel>> getFunds() async {
    final jsonString = await rootBundle.loadString('assets/mocks/funds.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => FundModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
