import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ukil_chaai_client/app/core/services/api_endpoint.dart';
import 'package:ukil_chaai_client/app/core/services/api_service.dart';
import 'package:ukil_chaai_client/app/data/models/lawyer_model.dart';
import '../models/advocate_list_model.dart';

/// Advocate directory — A4.1 GET /advocates, A4.2 GET /advocates/filters.
class LawyerListController extends GetxController {
  final searchCtrl = TextEditingController();
  final scrollCtrl = ScrollController();
  Timer? _debounce;

  // ── Results ─────────────────────────────────────────────────────────────────
  final filteredLawyers = <Lawyer>[].obs;
  final isLoading = false.obs; // first page / refresh
  final isLoadingMore = false.obs; // next pages
  final totalCount = 0.obs;
  int _page = 1;
  bool _hasMore = true;

  // ── Filter options (from /advocates/filters) ───────────────────────────────
  final areas = <String>[].obs;
  final divisions = <String>[].obs;
  final districts = <String>[].obs;
  final sorts = <String>['recommended', 'experience', 'price_low', 'price_high', 'name'].obs;

  // ── Applied filters ('' = not sent) ─────────────────────────────────────────
  final query = ''.obs;
  final selectedArea = ''.obs;
  final selectedDivision = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedSort = 'recommended'.obs;
  final availableOnly = false.obs;

  bool get hasActiveFilters =>
      selectedArea.value.isNotEmpty ||
      selectedDivision.value.isNotEmpty ||
      selectedDistrict.value.isNotEmpty ||
      availableOnly.value ||
      selectedSort.value != 'recommended';

  @override
  void onInit() {
    super.onInit();
    scrollCtrl.addListener(_onScroll);
    getFilters();
    getAdvocates();
  }

  // ── A4.2 Filter values ─────────────────────────────────────────────────────
  Future<void> getFilters() async {
    final res = await ApiServices.get<AdvocateFiltersModel>(
      AdvocateFiltersModel.fromJson,
      ApiEndpoint.advocateFiltersUrl,
      showErrorMessage: false,
    );
    if (res == null) return;
    areas.assignAll(res.practiceAreas);
    divisions.assignAll(res.divisions);
    districts.assignAll(res.districts);
    sorts.assignAll(res.sorts);
  }

  // ── A4.1 List advocates ────────────────────────────────────────────────────
  Future<void> getAdvocates({bool loadMore = false}) async {
    if (loadMore) {
      if (!_hasMore || isLoadingMore.value || isLoading.value) return;
      isLoadingMore.value = true;
    } else {
      _page = 1;
      _hasMore = true;
      isLoading.value = true;
    }

    try {
      final res = await ApiServices.get<AdvocateListModel>(
        AdvocateListModel.fromJson,
        '${ApiEndpoint.advocatesUrl}?${_queryString(loadMore ? _page + 1 : 1)}',
      );
      if (res != null) {
        final items = res.data.map((e) => e.toLawyer()).toList();
        if (loadMore) {
          filteredLawyers.addAll(items);
        } else {
          filteredLawyers.assignAll(items);
        }
        _page = res.currentPage;
        _hasMore = res.hasMore;
        totalCount.value = res.total;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshList() => getAdvocates();

  String _queryString(int page) {
    final params = <String, String>{
      'sort': selectedSort.value,
      'page': '$page',
      if (query.value.isNotEmpty) 'q': query.value,
      if (selectedArea.value.isNotEmpty) 'practice_area': selectedArea.value,
      if (selectedDivision.value.isNotEmpty) 'division': selectedDivision.value,
      if (selectedDistrict.value.isNotEmpty) 'district': selectedDistrict.value,
      if (availableOnly.value) 'available_only': '1',
    };
    return Uri(queryParameters: params).query;
  }

  void _onScroll() {
    if (scrollCtrl.position.pixels >= scrollCtrl.position.maxScrollExtent - 200) {
      getAdvocates(loadMore: true);
    }
  }

  // ── UI actions ──────────────────────────────────────────────────────────────
  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.value == value.trim()) return;
      query.value = value.trim();
      getAdvocates();
    });
  }

  void applyFilters() => getAdvocates();

  void clearArea() {
    selectedArea.value = '';
    getAdvocates();
  }

  void clearDivision() {
    selectedDivision.value = '';
    getAdvocates();
  }

  void clearDistrict() {
    selectedDistrict.value = '';
    getAdvocates();
  }

  void clearAvailableOnly() {
    availableOnly.value = false;
    getAdvocates();
  }

  void clearSort() {
    selectedSort.value = 'recommended';
    getAdvocates();
  }

  void resetFilters() {
    selectedArea.value = '';
    selectedDivision.value = '';
    selectedDistrict.value = '';
    selectedSort.value = 'recommended';
    availableOnly.value = false;
    getAdvocates();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    scrollCtrl.dispose();
    super.onClose();
  }
}
