import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/payment_model.dart';


final paymentListProvider = FutureProvider<List<PaymentModel>>((ref) async => []);

final paymentRepositoryProvider = Provider((ref) => throw UnimplementedError());
