import 'package:dio/dio.dart';
import 'package:openalbion_weaponry/network/api_constants.dart';
import 'package:openalbion_weaponry/network/response/response_category_list.dart';
import 'package:openalbion_weaponry/network/response/response_item_list.dart';
import 'package:retrofit/http.dart';
part 'open_albion_api.g.dart';

@RestApi(baseUrl: ApiConstants.OPEN_ALBION_URL)
abstract class OpenAlbionApi {
  factory OpenAlbionApi(Dio dio, {String baseUrl}) = _OpenAlbionApi;

  @GET("/categories")
  Future<ResponseCategoryList> getCategoryList();

  @GET("/weapons?subcategory_id={subId}")
  Future<ResponseItemList> getItemListBySubCategoryId(
    @Path() subId
  );
}