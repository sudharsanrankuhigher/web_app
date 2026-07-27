import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/core/model/get_user_model.dart';
import 'package:webapp/core/model/login_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webapp/ui/views/banner/model/all_banner_model.dart';
import 'package:webapp/ui/views/city/model/city_model.dart' as city_model;
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/location_contact/models/location_contact_model.dart';
import 'package:webapp/ui/views/permissions/model/get_permission_model.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan;
import 'package:webapp/ui/views/promote_projects/model/payment_split_model.dart';
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart'
    as sub_project_model;
import 'package:webapp/ui/views/report/model/report_model.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as roles_model;
import 'package:webapp/ui/views/services/model/service_model.dart' as service;
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart'
    as sub_admin_model;

import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;
import 'package:webapp/ui/views/contact_support/model/client_model.dart'
    as client_model;

import 'package:webapp/ui/views/requests/model/request_model.dart'
    as request_model;
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart'
    as project_model;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webapp/services/profile_service.dart';
import 'package:webapp/services/floating_overlay_service.dart';
import 'package:webapp/services/notification_service.dart';
import 'package:webapp/services/user_authentication_service.dart';

class ApiService {
  final Dio _dio;

  ApiService._internal(this._dio);

  static ApiService init() {
    bool isRedirecting = false;

    Future<void> handleUnauthorized() async {
      if (isRedirecting) return;
      isRedirecting = true;

      try {
        log('Unauthorized (401) detected. Clearing local and in-memory data and redirecting.');
        final prefs = locator<SharedPreferences>();
        await prefs.clear();

        await ProfileService.instance.clearProfile();
        FloatingOverlayService.instance.remove();
        NotificationService.instance.clear();

        if (locator.isRegistered<UserAuthenticationService>()) {
          locator<UserAuthenticationService>().logout();
        }
      } catch (e) {
        log('Error clearing local data on 401: $e');
      } finally {
        isRedirecting = false;
      }

      if (goRouterKey.currentContext != null) {
        goRouterKey.currentContext!.go('/login');
      }
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://admin.promoteapp.in/',
        // baseUrl: 'http://172.20.25.23:8003/', //saran
        // baseUrl: 'http://172.20.25.55:8888/', //shy
        // baseUrl: 'http://172.20.25.23:8002/',
        // baseUrl: 'http://172.20.25.54:8005/',//deepak
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final prefs = locator<SharedPreferences>();
          final token = prefs.getString('accessToken');

          if (token != null && token.isNotEmpty) {
            log('Adding Authorization header with token: $token');
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    // 🔹 Handle 401
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            await handleUnauthorized();
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: 'Unauthorized',
              ),
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
      ),
    );

    return ApiService._internal(dio);
  }

  Future<LoginResponse> loginAdmin(LoginRequest loginRequest) async {
    final response = await _dio.post(
      'api/admin/login',
      data: loginRequest.toJson(),
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return LoginResponse.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// GET: /api/admin/profile
  Future<dynamic> getProfile() async {
    final response = await _dio.get('api/admin/profile');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// Get : /api/admin/get-users
  Future<GetUsersResponse> getUsers({data}) async {
    final response = await _dio.post('api/admin/get-users', data: data);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());
      return GetUsersResponse.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST : /api/admin/client/note
  Future<void> updateNotes(
      {required int? userId, required String notes}) async {
    final data = {
      "client_id": userId,
      "note": notes,
    };
    final response = await _dio.post('api/admin/client/note', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///////////////////// STATE APIs /////////////////////

  ///POST: /api/admin/add-state
  Future<state_model.StateModel> addState(addStateRequest) async {
    final data = {'name': addStateRequest.name};
    final response = await _dio.post('api/admin/add-state', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return state_model.StateModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// GET: /api/admin/get-states
  Future<List<state_model.Datum>> getStates() async {
    final response = await _dio.get('api/admin/get-all-state');
    final List<dynamic> data = response.data['data'] ?? [];
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());
      return data.map((json) => state_model.Datum.fromJson(json)).toList();
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/update-state
  Future<state_model.StateModel> updateState(updateStateRequest) async {
    final response = await _dio.post('api/admin/edit-state',
        data: updateStateRequest.toJson());
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return state_model.StateModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// DELETE: /api/admin/delete-state/{id}
  Future<state_model.StateModel> deleteState(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-state', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return state_model.StateModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///////////////////// CITY APIs /////////////////////

  /// GET: /api/admin/get-all-city
  Future<List<city_model.Datum>> getCities() async {
    final response = await _dio.get('api/admin/get-all-city');
    final List<dynamic> data = response.data['data'] ?? [];
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());
      return data.map((json) => city_model.Datum.fromJson(json)).toList();
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/add-city
  Future<city_model.CityShowModel> addCity(addCityRequest) async {
    final data = addCityRequest;
    log('Add City Request Data: $data');
    final response = await _dio.post('api/admin/add-city', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return city_model.CityShowModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/update-city
  Future<city_model.CityShowModel> updateCity(updateCityRequest) async {
    final response =
        await _dio.post('api/admin/edit-city', data: updateCityRequest);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return city_model.CityShowModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// DELETE: /api/admin/delete-city/{id}
  Future<city_model.CityShowModel> deleteCity(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-city', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return city_model.CityShowModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ////////////////////// PLAN APIs /////////////////////

  /// GET: /api/admin/get-all-plan
  Future<plan.PlanModel> getAllPlans() async {
    final response = await _dio.get('api/admin/get-all-plan');
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());
      return plan.PlanModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/add-plan
  Future<plan.PlanModel> addPlan(addPlanRequest) async {
    final data = addPlanRequest;
    log('Add Plan Request Data: $data');
    final response = await _dio.post('api/admin/add-plan', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return plan.PlanModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/update-plan
  Future<plan.PlanModel> updatePlan(updatePlanRequest) async {
    final response =
        await _dio.post('api/admin/edit-plan', data: updatePlanRequest);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return plan.PlanModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// DELETE: /api/admin/delete-plan/{id}
  Future<plan.PlanModel> deletePlan(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-plan',
        data: data,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return plan.PlanModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ////////////////////// Service APIs /////////////////////

  /// GET: /api/admin/get-all-plan
  Future<service.ServiceModel> getAllService() async {
    final response = await _dio.get('api/admin/get-all-service');
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());
      return service.ServiceModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/add-service
  Future<service.ServiceModel> addService(request) async {
    final formData = FormData.fromMap({
      "name": request["serviceName"],

      /// MOBILE IMAGE

      if (request["imagePath"] != null && !kIsWeb)
        "service_image": await MultipartFile.fromFile(
          request["imagePath"],
          filename: request["imagePath"].split('/').last,
        ),

      /// WEB IMAGE
      if (request["imageBytes"] != null && kIsWeb)
        "service_image": MultipartFile.fromBytes(
          request["imageBytes"],
          filename: "service.png",
        ),
    });

    log("Add Service FormData: ${formData.fields}");

    final response = await _dio.post(
      'api/admin/add-service',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());
      return service.ServiceModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/edit-service
  Future<service.ServiceModel> updateService(
      Map<String, dynamic> request) async {
    final Map<String, dynamic> formMap = {
      "id": request["id"],
      "name": request["serviceName"],
    };

    // Mobile: send new image file if selected
    if (!kIsWeb && request["imagePath"] != null) {
      formMap["service_image"] = await MultipartFile.fromFile(
        request["imagePath"],
        filename: request["imagePath"].split('/').last,
      );
    }

    // Web: send new image bytes if selected
    if (kIsWeb && request["imageBytes"] != null) {
      formMap["service_image"] = MultipartFile.fromBytes(
        request["imageBytes"],
        filename: "service.png",
      );
    }

    // If no new image is provided, send existing image URL
    if (request["existing_image"] != null && (request["imageBytes"] == null)) {
      formMap["existing_image"] = request["existing_image"];
    }

    final formData = FormData.fromMap(formMap);

    final response = await _dio.post(
      'api/admin/edit-service',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return service.ServiceModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// DELETE: /api/admin/delete-plan/{id}
  Future<service.ServiceModel> deleteService(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-service', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return service.ServiceModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///////////////////////////// INFLUENCERS APIs /////////////////////

  /// GET: /api/admin/get-influencers
  Future<void> getInfluencers() async {
    final response = await _dio.get('api/admin/get-influencers');
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  Future<dynamic> addInfluencer(FormData formData) async {
    final response = await _dio.post(
      'api/admin/add-influencer',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.json, // ✅ important
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// GET: /api/admin/get-all-plan
  Future<influencer_model.InfluencerModel> getAllInfluencer({data}) async {
    final response =
        await _dio.post('api/admin/get-all-influencer', data: data);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return influencer_model.InfluencerModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /////////////////// company api //////////////////////

  /// POST: /api/admin/add-company
  Future<void> addCompany(FormData formData) async {
    final response = await _dio.post(
      'api/admin/add-company',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.json, // ✅ important
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  Future<company_model.CompanyModel> getCompany() async {
    final response = await _dio.get('api/admin/get-all-company');

    // map JSON to CompanyModel
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return company_model.CompanyModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ////////////////// Role API ////////////////////
  /// Get: /api/admin/get-all-role

  Future<roles_model.RolesModel> getAllRole() async {
    final response = await _dio.get('api/admin/get-all-role');
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return roles_model.RolesModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/add-role
  Future<roles_model.RolesModel> addRole(role) async {
    final response = await _dio.post(
      'api/admin/add-role',
      data: {
        'name': role['name'], // ✅ map access
        if (role['id'] != null) 'id': role['id'],
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return roles_model.RolesModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///DELETE : /api/admin/delete-role/{id}
  Future<roles_model.RolesModel> deleteRole(id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-role', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return roles_model.RolesModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ////////////// sub admin /////////////
  /// GET: /api/admin/get-all-sub-admin
  Future<List<sub_admin_model.Datum>> getAllSubAdmin() async {
    final response = await _dio.get('api/admin/get-all-sub-admin');
    final List<dynamic> data = response.data['data'] ?? [];
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return data.map((json) => sub_admin_model.Datum.fromJson(json)).toList();
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/add-sub-admin
  Future<sub_admin_model.SubAdminModel> addSubAdmin(addSubAdminRequest) async {
    final data = addSubAdminRequest;
    log('Add Sub Admin Request Data: $data');
    final response = await _dio.post(
      'api/admin/add-sub-admin',
      data: data,
      options: Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.json, // ✅ important
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return sub_admin_model.SubAdminModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///DELETE : /api/admin/delete-role/{id}
  Future<sub_admin_model.SubAdminModel> deleteSubAdmin(id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-admin', data: data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return sub_admin_model.SubAdminModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /////////////////// Permissions ////////////////////
  /// GET: /api/admin/add-permission

  Future<void> addPermissions(id, request) async {
    final req = {
      "role_id": id,
      "permissions": request,
    };
    final response = await _dio.post(
      'api/admin/permissions',
      data: req,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  Future<GetPermissionModel> getPermissions(id) async {
    final request = {
      "role_id": id,
    };
    final response = await _dio.get(
      'api/admin/get-permissions',
      queryParameters: request,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return GetPermissionModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ////////////////// contact support ////////////////////
  ///
  /// POST: /api/admin/add-contact-support
  Future<client_model.ClientModel> getAllContactSupport() async {
    final response = await _dio.get(
      'api/admin/tickets',
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return client_model.ClientModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/tickets/update
  Future<client_model.ClientModel> updateContactSupport(request) async {
    final response = await _dio.post(
      'api/admin/tickets/update',
      data: request,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return client_model.ClientModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// Delete: /api/admin/tickets/delete
  Future<client_model.ClientModel> deleteContactSupport(request) async {
    final req = {
      "ticket_id": request,
    };
    final response = await _dio.delete(
      'api/admin/tickets/delete',
      data: req,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return client_model.ClientModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///////////////////// client request ////////////////////////
  ///POST: /api/admin/client/request

  Future<request_model.ProjectRequestModel> getClientRequest(request,
      {String? month}) async {
    final req = {
      "status": request,
      if (month != null) "month": month,
    };
    final response = await _dio.post('api/admin/client/request',
        data: req,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return request_model.ProjectRequestModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/promote/note
  Future<void> addPromoteNote(requestId, note) async {
    final req = {
      "promote_project_id": requestId,
      "note": note,
    };
    final response = await _dio.post('api/admin/promote/note',
        data: req,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/client/status/change
  Future<void> statusChange(request) async {
    dynamic requestData = request;

    if (request["image"] != null) {
      final Map<String, dynamic> formMap = {
        "id": request["id"],
        "status": request["status"],
        "client_id": request["client_id"],
        if (request["category_id"] != null)
          "category_id": request["category_id"],
        "link": request["link"] ?? "",
        "remark": request["remark"] ?? "",
      };

      final image = request["image"];
      if (image is Uint8List) {
        formMap["image"] = MultipartFile.fromBytes(
          image,
          filename: "screenshot.png",
        );
      } else if (image is String) {
        formMap["image"] = await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        );
      } else {
        formMap["image"] = image;
      }

      requestData = FormData.fromMap(formMap);
    }

    final response = await _dio.post('api/admin/status/change',
        data: requestData,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/client/status/change
  Future<void> waitingAccept(request) async {
    final response = await _dio.post('api/admin/waiting/accept',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/payment/status/change
  Future<void> paymentStatusChange(request) async {
    final response = await _dio.post('api/admin/payment/status/change',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/client/reassign
  Future<request_model.ProjectRequestModel> clientReAssign(request) async {
    final response = await _dio.post('api/admin/client/reassign',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return request_model.ProjectRequestModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /////////////////////promote projects ////////////////////////
  /// POST: /api/admin/promote/create
  Future<dynamic> promoteProjectCreate(FormData formData) async {
    final response = await _dio.post(
      'api/admin/promote/create',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// POST: /api/admin/promote/list
  Future<project_model.ProjectModel> getAllPromoteProjects(request) async {
    final response = await _dio.post('api/admin/promote/list', data: request);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return project_model.ProjectModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/promote/project
  Future<sub_project_model.PromoteTableModel> getSubProjects(request) async {
    final response =
        await _dio.post('api/admin/promote/project', data: request);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return sub_project_model.PromoteTableModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/promote/status
  Future<dynamic> changePromoteStatus(request) async {
    dynamic requestData = request;

    if (request is Map && request["image"] != null) {
      final Map<String, dynamic> formMap = {
        "promote_project_id": request["promote_project_id"],
        "status": request["status"],
        if (request["rework"] != null) "rework": request["rework"],
        if (request["link"] != null) "link": request["link"],
      };

      final image = request["image"];
      if (image is Uint8List) {
        formMap["image"] = MultipartFile.fromBytes(
          image,
          filename: "screenshot.png",
        );
      } else if (image is String) {
        formMap["image"] = await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        );
      } else {
        formMap["image"] = image;
      }

      requestData = FormData.fromMap(formMap);
    }

    final response = await _dio.post('api/admin/promote/status',
        data: requestData,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /promote/refund/status
  Future<dynamic> refundPromoteProject(request) async {
    final response = await _dio.post('api/admin/promote/refund/status',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/payment/list
  Future<PaymentSplitModel> getPaymentSplit(request) async {
    final response = await _dio.post('api/admin/payment/list', data: request);
    return PaymentSplitModel.fromJson(response.data);
  }

  ///POST: /api/admin/payment/update
  Future<dynamic> updatePaymentSplit(request) async {
    final response = await _dio.post('api/admin/payment/update',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/promote/reassign
  Future<project_model.ProjectModel> reAssignInf(request) async {
    final response = await _dio.post('api/admin/promote/reassign',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return project_model.ProjectModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  //////////////////// location contact ////////////////////
  /// GET: /api/admin/contact/list
  Future<LocationContactModel> getLocationContact() async {
    final response = await _dio.get('api/admin/contact/list',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      return LocationContactModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: /api/admin/contact/save
  Future<LocationContactModel> createLocationContact(request) async {
    final response = await _dio.post('api/admin/contact/save',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return LocationContactModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///DELETE: /api/admin/contact/delete
  Future<LocationContactModel> deleteLocationContact(request) async {
    final response = await _dio.delete('api/admin/contact/delete',
        queryParameters: request,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return LocationContactModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  //////////////////Banner/////////////////
  ///Get: api/admin/banner/list
  Future<AllBannerModel> getAllBanner() async {
    final response = await _dio.get(
      'api/admin/banner/list',
      options: Options(
        validateStatus: (status) => status != null && status < 500,
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.data["message"].toString());

      return AllBannerModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///POST: api/admin/banner/create
  Future<AllBannerModel> createBanner(request) async {
    final response = await _dio.post('api/admin/banner/create',
        data: request,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return AllBannerModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  ///Delete: /api/admin/delete
  Future<AllBannerModel> deleteBanner(id) async {
    final request = {
      "id": id,
    };
    final response = await _dio.delete('api/admin/banner/delete',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return AllBannerModel.fromJson(response.data);
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  Future<ReportModel> getReport(request) async {
    try {
      final response = await _dio.post(
        'api/admin/get/reports',
        data: request,
        options: Options(
          validateStatus: (status) => status != null && status < 501,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ReportModel.fromJson(response.data);
      } else {
        final message = response.data?['message'] ?? 'Server error';
        throw Exception(message);
      }
    } catch (e) {
      print("Report API Error: $e");
      rethrow; // let stacked handle busy/error state
    }
  }

  ///POST: /api/admin/refund/status
  Future<void> refundStatus(
    connectionId,
  ) async {
    final req = {
      "connection_id": connectionId,
    };
    final response = await _dio.post('api/admin/refund/status',
        data: req,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: response.data["message"].toString());

      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #EF5350, #000000)",
          webPosition: "center",
          webShowClose: true,
          msg: message);
      throw Exception(message);
    }
  }

  /// GET: /api/admin/notification-list
  Future<dynamic> getNotificationList() async {
    final response = await _dio.get('api/admin/notification-list');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/notification-delete
  Future<dynamic> deleteNotification(List<int> ids) async {
    final response = await _dio.delete(
      'api/admin/notification-delete',
      data: {'id': ids},
      queryParameters: {'id': ids},
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/notification-read
  Future<dynamic> readNotification(int id) async {
    final response = await _dio.post('api/admin/notification-read', data: {
      'id': id,
      // 'notification_ids': id,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/notification-read-all
  Future<dynamic> readAllNotifications() async {
    final response = await _dio.post('api/admin/notification-read-all');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/notification-temp
  Future<dynamic> sendBroadcastNotification(
      Map<String, dynamic> request) async {
    final response = await _dio.post(
      'api/admin/notification-temp',
      data: request,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/user-list
  Future<dynamic> getAdminUserList(Map<String, dynamic> request) async {
    final response = await _dio.post(
      'api/admin/user-list',
      data: request,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/template-store
  Future<dynamic> storeTemplate(Map<String, dynamic> request) async {
    final response = await _dio.post(
      'api/admin/template-store',
      data: request,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// GET: /api/admin/template-list
  Future<dynamic> getTemplateList() async {
    final response = await _dio.get(
      'api/admin/template-list',
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// DELETE: /api/admin/template-delete
  Future<dynamic> deleteTemplate(int id) async {
    final response = await _dio.delete(
      'api/admin/template-delete',
      data: {'id': id},
      queryParameters: {'id': id},
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/logout
  Future<dynamic> logout() async {
    final response = await _dio.post('api/admin/logout');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }

  /// POST: /api/admin/attendance
  Future<dynamic> getAttendance(String month, {dynamic id}) async {
    final Map<String, dynamic> requestData = {'month': month};
    if (id != null) {
      requestData['id'] = id;
    }
    final response = await _dio.post(
      'api/admin/attendance',
      data: requestData,
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data?['message'] ?? 'Server error';
      throw Exception(message);
    }
  }
}
