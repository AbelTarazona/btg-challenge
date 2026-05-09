import 'dart:convert';

import 'package:btgproject/data/models/user_model.dart';
import 'package:flutter/services.dart';

/// DataSource local para el usuario.
///
/// Mantiene el saldo mutable en memoria para reflejar
/// suscripciones y cancelaciones durante la sesión.
class UserLocalDataSource {
  UserModel? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final jsonString = await rootBundle.loadString('assets/mocks/user.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;
    _cache = UserModel.fromJson(jsonMap);
  }

  Future<UserModel> getUser() async {
    await _ensureLoaded();
    return _cache!;
  }

  Future<void> updateBalance(double newBalance) async {
    await _ensureLoaded();
    _cache = UserModel(
      id: _cache!.id,
      name: _cache!.name,
      availableBalance: newBalance,
      currency: _cache!.currency,
    );
  }
}
