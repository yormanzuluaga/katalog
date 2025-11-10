import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';
import 'package:either_dart/either.dart';

/// {@template example_resource}
/// An api resource to get the prompt terms.
/// {@endtemplate}
class VideoResource {
  /// {@macro example_resource}
  VideoResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  // ignore: unused_field
  final ApiClient _apiClient;

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].

  Future<Either<ApiException, TalentModel>> getMostHighlightTalent({
    Map<String, String>? headers,
    required String url,
  }) async {
    final response = await _apiClient.get(
      url,
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = TalentModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Right(categoryResponse);
    } else {
      return Left(
        ApiException(
          response.statusCode,
          response.body,
        ),
      );
    }
  }

  Future<Either<ApiException, TalentModel>> getTopPitches({
    Map<String, String>? headers,
    required String url,
  }) async {
    final response = await _apiClient.get(
      'categories/d/talentees/top_pitches/unique/null/',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = TalentModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Right(categoryResponse);
    } else {
      return Left(
        ApiException(
          response.statusCode,
          response.body,
        ),
      );
    }
  }

  Future<Either<ApiException, TalentModel>> getMostViewedTalent({
    Map<String, String>? headers,
    required String url,
  }) async {
    final response = await _apiClient.get(
      'categories/d/talentees/most_viewed_talent/video/null/',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = TalentModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Right(categoryResponse);
    } else {
      return Left(
        ApiException(
          response.statusCode,
          response.body,
        ),
      );
    }
  }

  Future<Either<ApiException, TalentModel>> getToPichesViewd({
    Map<String, String>? headers,
    required String url,
  }) async {
    final response = await _apiClient.get(
      'categories/d/talentees/top_pitches_viewed/card_top/null/',
      modifiedHeaders: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final categoryResponse = TalentModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return Right(categoryResponse);
    } else {
      return Left(
        ApiException(
          response.statusCode,
          response.body,
        ),
      );
    }
  }
}
