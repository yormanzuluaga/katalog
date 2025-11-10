import 'package:api_helper/api_helper.dart';
import 'package:dartz/dartz.dart';

abstract class VideoRepository {
  Future<Either<ApiException, TalentModel>> getMostHighlightTalent({
    Map<String, String>? headers,
    required String url,
  });
}
