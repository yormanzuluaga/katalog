import 'package:api_helper/api_helper.dart';
import 'package:api_repository/api_repository.dart';
import 'package:dartz/dartz.dart';

class VideoRepositoryImpl extends VideoRepository {
  VideoResource videoResource;
  @override
  VideoRepositoryImpl({
    required this.videoResource,
  });

  @override
  Future<Either<ApiException, TalentModel>> getMostHighlightTalent({
    Map<String, String>? headers,
    required String url,
  }) async {
    final movieModel = await videoResource.getMostHighlightTalent(
      headers: headers,
      url: url,
    );
    return movieModel.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
