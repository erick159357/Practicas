import 'package:connectivity_plus/connectivity_plus.dart';
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    // connectivity_plus 6.x devuelve una lista (puede haber wifi + datos).
    final results = await _connectivity.checkConnectivity();
    // Hay conexión mientras la lista no sea solo "none".
    return !results.contains(ConnectivityResult.none);
  }
}
