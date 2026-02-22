import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(InternetInitial()) {
    _monitorInternetConnection();
  }
  late StreamSubscription<List<ConnectivityResult>>? _subscription;
  final Connectivity _connectivity = Connectivity();

  void _monitorInternetConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      },
      onError: (error) {
        debugPrint('❌ Connectivity error: $error');
      },
    );

    _checkCurrentConnection();
  }

  Future<void> _checkCurrentConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      debugPrint('❌ Error checking connectivity: $e');
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    debugPrint('📡 Connectivity changed: $results');

    if (results.contains(ConnectivityResult.none)) {
      emit(InternetConnectionLost());
      debugPrint('📡 Internet: DISCONNECTED');
    } else {
      emit(InternetConnectionGained());
      debugPrint('📡 Internet: CONNECTED via $results');
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
