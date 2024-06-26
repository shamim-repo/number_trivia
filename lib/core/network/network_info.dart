
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  late final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl({ required this.dataConnectionChecker});

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;

}