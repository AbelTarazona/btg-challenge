/// Simula latencia de red para desarrollo con datos mock.
///
/// Envuelve cualquier llamada asíncrona con un delay configurable
/// para emular tiempos de respuesta reales de una API.
Future<T> withMockDelay<T>(
  Future<T> Function() action, {
  Duration delay = const Duration(milliseconds: 1200),
}) async {
  await Future.delayed(delay);
  return action();
}
