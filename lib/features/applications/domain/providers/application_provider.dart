import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application_model.dart';


final approvedApplicationsProvider = FutureProvider<List<RentalApplicationModel>>((ref) async => []);

final myApplicationsProvider = FutureProvider<List<RentalApplicationModel>>((ref) async => []);

final applicationDetailProvider = FutureProvider.family<RentalApplicationModel, String>((ref, applicationId) async {
  throw UnimplementedError();
});

final applicationRepositoryProvider = Provider((ref) => throw UnimplementedError());

