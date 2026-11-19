import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DocumentTypeScreen extends ConsumerWidget {
  const DocumentTypeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.read(authStateProvider).value?.role ?? AppConstants.roleTenant;
    final types = role == AppConstants.roleLandlord ? [AppConstants.docTypeLandlordIdentity]
        : role == AppConstants.rolePropertyManager ? [AppConstants.docTypePropertyManagerIdentity]
        : [AppConstants.docTypeNationalId, AppConstants.docTypeCitizenshipFront, AppConstants.docTypePassport];
    return Scaffold(appBar: AppBar(title: const Text('Select Document Type')),
      body: ListView(padding: const EdgeInsets.all(16), children: types.map((t) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: const Icon(Icons.description_outlined), title: Text(t.replaceAll('_', ' ').capitalize()), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(RouteName.documentFrontUpload)))).toList()));
  }
}
extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}