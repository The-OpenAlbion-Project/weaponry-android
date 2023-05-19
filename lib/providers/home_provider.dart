import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:openalbion_weaponry/data/vos/app_error.dart';
import 'package:openalbion_weaponry/data/vos/category_vo.dart';
import 'package:openalbion_weaponry/data/vos/item_vo.dart';
import 'package:openalbion_weaponry/data/vos/sub_category_vo.dart';
import 'package:openalbion_weaponry/data/vos/tier_group_vo.dart';
import 'package:openalbion_weaponry/network/firebase/firebase_analytics_repository.dart';
import 'package:openalbion_weaponry/network/firebase/firebase_analytics_repository_impl.dart';
import 'package:openalbion_weaponry/network/repository/network_repository.dart';
import 'package:openalbion_weaponry/network/repository/network_repository_impl.dart';
import 'package:openalbion_weaponry/providers/based_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeProvider extends BasedProvider {
  List<CategoryVO> _categoryList = [];
  List<CategoryVO> get categoryList => _categoryList;

  late CategoryVO selectedCategory;
  late SubCategoryVO selectedSubCategory;
  String _selectedCategoryType = '';
  String get selectedCategoryType => _selectedCategoryType;

  String _versionName = '';
  String get versionName => _versionName;

  AppError? appError;
  final NetworkRepository _repository = NetworkRepositoryImpl();
  final FirebaseAnalyticsRepository _fireRepository = FirebaseAnalyticsRepositoryImpl();

  bool itemLoading = true;
  bool itemComplete = false;
  List<ItemVO> _itemList = [];
  List<ItemVO> get itemList => _itemList;

  List<TierGroupVO> _tierGroupList = [];
  List<TierGroupVO> get tierGroupList => _tierGroupList;

  HomeProvider() {
    _fireRepository.reportOpenApp();
    _getFCMToken();
    _getCategoryList();
    _getVersion();
  }

  // api call
  void _getCategoryList() async {
    setState(ViewState.LOADING);
    if (await handleConnectionView(isReplaceView: false)) {
      return;
    }
    Either<AppError, List<CategoryVO>> data = await _repository.getCategoryList();
    data.fold((L) {
      appError = L;
      print(state);
      setState(ViewState.ERROR);
    }, (R) {
      _categoryList = R;
      _selectedCategoryType = _categoryList.first.type;
      _setInitialCategoryAndSubCategory();
      setState(ViewState.COMPLETE);
    });
  }

  void getItemList() async {
    _fireRepository
        .reportToFirebase("watch_${selectedSubCategory.type}_${selectedSubCategory.name.toLowerCase()}");

    _tierGroupList = [];
    itemLoading = true;
    notifyListeners();

    if (await handleConnectionView(isReplaceView: false)) {
      return;
    }
    Either<AppError, List<ItemVO>> data =
        await _repository.getItemListBySubCategoryId(selectedSubCategory.id, selectedCategory.path);
    data.fold((L) {
      itemLoading = false;
      itemComplete = false;
      appError = L;
      notifyListeners();
    }, (R) {
      _itemList = R;
      _tierGroupList = _itemList.convertToTierGroupList();
      itemLoading = false;
      itemComplete = true;
      notifyListeners();
    });
  }

  void _getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _versionName = packageInfo.version;
  }

  // set category and sub-category
  void _setInitialCategoryAndSubCategory() {
    if (_categoryList.isNotEmpty) {
      selectedCategory = _categoryList.first;
      if (selectedCategory.subcategories.isNotEmpty) {
        selectedSubCategory = selectedCategory.subcategories.first;
        getItemList();
      } else {
        throw Exception("Empty SubCategory List");
      }
    } else {
      throw Exception("Empty Category List");
    }
    print(selectedSubCategory);
  }

  void setCategoryAndSubCategory({int? catId, int? subId, bool setFirstSubcategory = false}) {
    if (catId != null) {
      selectedCategory = _categoryList.getCategoryById(catId);
    } else {
      catId = selectedCategory.id;
    }
    if (setFirstSubcategory == true) {
      selectedSubCategory = selectedCategory.subcategories.first;
      getItemList();
    } else if (subId != null) {
      selectedSubCategory = _categoryList.getSubCategoryById(catId, subId);
      getItemList();
    }
    selectCategoryType(selectedCategory.type);
    print(selectedCategory);
    print(selectedSubCategory);

    notifyListeners();
  }

  void selectCategoryType(String type) {
    print(selectedCategoryType);

    _selectedCategoryType = type;
    notifyListeners();
  }
}
