import 'dart:convert';

import 'package:btgproject/data/models/transaction_model.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:flutter/services.dart';

/// DataSource local para transacciones.
///
/// Carga datos iniciales desde JSON y mantiene el estado en memoria
/// para permitir agregar nuevas transacciones en tiempo de ejecución.
class TransactionLocalDataSource {
  List<TransactionModel>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final jsonString =
        await rootBundle.loadString('assets/mocks/transactions.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cache = jsonList
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TransactionModel>> getTransactions() async {
    await _ensureLoaded();
    return List.unmodifiable(_cache!);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _ensureLoaded();
    _cache!.add(TransactionModel(
      id: transaction.id,
      type: transaction.type,
      fundId: transaction.fundId,
      fundName: transaction.fundName,
      amount: transaction.amount,
      date: transaction.date,
      notificationMethod: transaction.notificationMethod,
    ));
  }
}
