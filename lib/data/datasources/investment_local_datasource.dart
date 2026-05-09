import 'dart:convert';

import 'package:btgproject/data/models/investment_model.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:flutter/services.dart';

/// DataSource local para inversiones activas.
///
/// Carga datos iniciales desde JSON y mantiene el estado en memoria
/// para permitir suscripciones y cancelaciones en tiempo de ejecución.
class InvestmentLocalDataSource {
  List<InvestmentModel>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final jsonString =
        await rootBundle.loadString('assets/mocks/investments.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cache = jsonList
        .map((e) => InvestmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<InvestmentModel>> getInvestments() async {
    await _ensureLoaded();
    return List.unmodifiable(_cache!);
  }

  Future<void> subscribe(Investment investment) async {
    await _ensureLoaded();
    _cache!.add(InvestmentModel(
      id: investment.id,
      fundId: investment.fundId,
      fundName: investment.fundName,
      amount: investment.amount,
      subscriptionDate: investment.subscriptionDate,
      notificationMethod: investment.notificationMethod,
    ));
  }

  Future<void> cancel(String investmentId) async {
    await _ensureLoaded();
    _cache!.removeWhere((inv) => inv.id == investmentId);
  }
}
