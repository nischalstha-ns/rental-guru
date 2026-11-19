import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/maintenance_request_model.dart';


final maintenanceRequestsProvider = FutureProvider<List<MaintenanceRequestModel>>((ref) async => []);

final maintenanceRepositoryProvider = Provider((ref) => throw UnimplementedError());
