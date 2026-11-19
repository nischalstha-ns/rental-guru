import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lease_model.dart';


final myLeasesProvider = FutureProvider<List<LeaseModel>>((ref) async => []);

