import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openalbion_weaponry/data/vos/app_error.dart';
import 'package:openalbion_weaponry/data/vos/category_vo.dart';
import 'package:openalbion_weaponry/data/vos/enchantment_vo.dart';
import 'package:openalbion_weaponry/data/vos/item_vo.dart';
import 'package:openalbion_weaponry/data/vos/slot_vo.dart';
import 'package:openalbion_weaponry/data/vos/spell_vo.dart';
import 'package:openalbion_weaponry/network/dio/dio_client.dart';
import 'package:openalbion_weaponry/network/error/error_mapper.dart';
import 'package:openalbion_weaponry/network/repository/network_repository.dart';
import 'package:openalbion_weaponry/network/response/response_category_list.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  static final NetworkRepositoryImpl _singleton = NetworkRepositoryImpl.internal();
  final DioClient _albionClient = DioClient();

  factory NetworkRepositoryImpl() {
    return _singleton;
  }

  NetworkRepositoryImpl.internal() {
    _initializeEnv();
  }

  void _initializeEnv() async {
    await dotenv.load(fileName: ".env");
  }

  @override
  Future<Either<AppError, List<CategoryVO>>> getCategoryList() async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      var apiToken = dotenv.env['API_TOKEN'];
      var response = await _albionClient.openAlbionApi().getCategoryList(apiToken);
      // print("env --> ${dotenv.env['API_TOKEN']}");
      // final String response =
      //     await rootBundle.loadString("assets/mock_json/response_category_list.json");

      // final Map<String, dynamic> mappedJson = await jsonDecode(response);
      return Right(response.data);
    } on DioError catch (e) {
      return Left(ErrorMapper.mapDioToAppError(e));
    } on JsonUnsupportedObjectError catch (_) {
      return Left(AppError(code: "-", message: "Respond is not Json"));
    } on TypeError catch (_) {
      return Left(AppError(code: "-", message: "Invalid Json Type"));
    }
  }

  @override
  Future<Either<AppError, List<ItemVO>>> getItemListBySubCategoryId(int subId,String path) async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      var apiToken = dotenv.env['API_TOKEN'];
      var response = await _albionClient.openAlbionApi().getItemListBySubCategoryId(path, apiToken, subId);
      // final String response =
      //     await rootBundle.loadString("assets/mock_json/response_category_list.json");

      // final Map<String, dynamic> mappedJson = await jsonDecode(response);
      return Right(response.data);
    } on DioError catch (e) {
      return Left(ErrorMapper.mapDioToAppError(e));
    } on JsonUnsupportedObjectError catch (_) {
      return Left(AppError(code: "-", message: "Respond is not Json"));
    } on TypeError catch (_) {
      return Left(AppError(code: "-", message: "Invalid Json Type"));
    }
  }

  @override
  Future<Either<AppError, List<EnchantmentVO>>> getItemDetailById(String itemType, int itemId) async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      var apiToken = dotenv.env['API_TOKEN'];
      var response = await _albionClient.openAlbionApi().getItemDetailById(apiToken, itemType, itemId);
      // final String response =
      //     await rootBundle.loadString("assets/mock_json/response_category_list.json");

      // final Map<String, dynamic> mappedJson = await jsonDecode(response);
      return Right(response.data);
    } on DioError catch (e) {
      return Left(ErrorMapper.mapDioToAppError(e));
    } on JsonUnsupportedObjectError catch (_) {
      return Left(AppError(code: "-", message: "Respond is not Json"));
    } on TypeError catch (_) {
      return Left(AppError(code: "-", message: "Invalid Json Type"));
    }
  }

  @override
  Future<Either<AppError, List<SlotVO>>> getSpellDetailById(String itemType, int itemId) async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      var apiToken = dotenv.env['API_TOKEN'];
      var response = await _albionClient.openAlbionApi().getSpellDetailById(apiToken, itemType, itemId);
      // final String response =
      //     await rootBundle.loadString("assets/mock_json/response_category_list.json");

      // final Map<String, dynamic> mappedJson = await jsonDecode(response);
      return Right(response.data);
    } on DioError catch (e) {
      return Left(ErrorMapper.mapDioToAppError(e));
    } on JsonUnsupportedObjectError catch (_) {
      return Left(AppError(code: "-", message: "Respond is not Json"));
    } on TypeError catch (_) {
      return Left(AppError(code: "-", message: "Invalid Json Type"));
    }
  }

  // @override
  // Future<Either<AppError, ItemDetailVO>> getItemDetail(String itemId) async {
  //   try {
  //     var data = await _albionClient.toolApi().getItemDetail(itemId);
  //     return Right(data);
  //   } on DioError catch (e) {
  //     return Left(ErrorMapper.mapDioToAppError(e));
  //   } on JsonUnsupportedObjectError catch (_) {
  //     return Left(AppError(code: "-", message: "Respond is not Json"));
  //   } on TypeError catch (_) {
  //     return Left(AppError(code: "-", message: "Invalid Json Type"));
  //   }
  // }
}
