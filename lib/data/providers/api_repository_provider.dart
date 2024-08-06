import 'package:ai_chat/data/repository/api_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_repository_provider.g.dart';

@riverpod
ApiRepository apiRepository(ApiRepositoryRef ref) => ApiRepository();
