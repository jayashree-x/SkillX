import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/certificate_functions_repository.dart';
import '../data/certificate_repository.dart';
import '../domain/certificate.dart';

final certificateFunctionsRepositoryProvider =
    Provider<CertificateFunctionsRepository>(
        (ref) => CertificateFunctionsRepository());

final certificateRepositoryProvider = Provider<CertificateRepository>(
  (ref) => CertificateRepository(ref.watch(certificateFunctionsRepositoryProvider)),
);

/// Issues (or fetches) + generates the certificate for a completed path. Runs
/// once per path while the screen is open; the server side is idempotent.
final certificateForPathProvider =
    FutureProvider.autoDispose.family<CertificateData, String>(
  (ref, pathId) => ref.watch(certificateRepositoryProvider).obtain(pathId),
);
