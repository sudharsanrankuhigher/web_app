import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/model/get_profile_model.dart';
import 'package:webapp/core/model/get_user_model.dart';
import 'package:webapp/core/model/login_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webapp/ui/views/city/model/city_model.dart' as city_model;
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/permissions/model/get_permission_model.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan;
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

class ApiService {
  final Dio _dio;

  ApiService._internal(this._dio);

  static ApiService init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://172.20.25.23:8005/',
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

    return LoginResponse.fromJson(response.data);
  }

  /// GET: /api/paidpromo/country/getAllCountry
  Future<GetAdminProfileResponse> getProfile() async {
    final response = await _dio.get('api/admin/profile');
    return GetAdminProfileResponse.fromJson(response.data);
  }

  /// Get : /api/admin/get-users
  Future<GetUsersResponse> getUsers() async {
    final response = await _dio.get('api/admin/get-users');
    return GetUsersResponse.fromJson(response.data);
  }

  ///////////////////// STATE APIs /////////////////////

  ///POST: /api/admin/add-state
  Future<state_model.StateModel> addState(addStateRequest) async {
    final data = {'name': addStateRequest.name};
    final response = await _dio.post('api/admin/add-state', data: data);
    return state_model.StateModel.fromJson(response.data);
  }

  /// GET: /api/admin/get-states
  Future<List<state_model.Datum>> getStates() async {
    final response = await _dio.get('api/admin/get-all-state');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => state_model.Datum.fromJson(json)).toList();
  }

  /// POST: /api/admin/update-state
  Future<state_model.StateModel> updateState(updateStateRequest) async {
    final response = await _dio.post('api/admin/edit-state',
        data: updateStateRequest.toJson());
    return state_model.StateModel.fromJson(response.data);
  }

  /// DELETE: /api/admin/delete-state/{id}
  Future<state_model.StateModel> deleteState(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-state', data: data);
    return state_model.StateModel.fromJson(response.data);
  }

  ///////////////////// CITY APIs /////////////////////

  /// GET: /api/admin/get-all-city
  Future<List<city_model.Datum>> getCities() async {
    final response = await _dio.get('api/admin/get-all-city');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => city_model.Datum.fromJson(json)).toList();
  }

  ///POST: /api/admin/add-city
  Future<city_model.CityShowModel> addCity(addCityRequest) async {
    final data = addCityRequest;
    log('Add City Request Data: $data');
    final response = await _dio.post('api/admin/add-city', data: data);
    return city_model.CityShowModel.fromJson(response.data);
  }

  /// POST: /api/admin/update-city
  Future<city_model.CityShowModel> updateCity(updateCityRequest) async {
    final response =
        await _dio.post('api/admin/edit-city', data: updateCityRequest);
    return city_model.CityShowModel.fromJson(response.data);
  }

  /// DELETE: /api/admin/delete-city/{id}
  Future<city_model.CityShowModel> deleteCity(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-city', data: data);
    return city_model.CityShowModel.fromJson(response.data);
  }

  ////////////////////// PLAN APIs /////////////////////

  /// GET: /api/admin/get-all-plan
  Future<plan.PlanModel> getAllPlans() async {
    final response = await _dio.get('api/admin/get-all-plan');
    return plan.PlanModel.fromJson(response.data);
  }

  /// POST: /api/admin/add-plan
  Future<plan.PlanModel> addPlan(addPlanRequest) async {
    final data = addPlanRequest;
    log('Add Plan Request Data: $data');
    final response = await _dio.post('api/admin/add-plan', data: data);
    return plan.PlanModel.fromJson(response.data);
  }

  /// POST: /api/admin/update-plan
  Future<plan.PlanModel> updatePlan(updatePlanRequest) async {
    final response =
        await _dio.post('api/admin/edit-plan', data: updatePlanRequest);
    return plan.PlanModel.fromJson(response.data);
  }

  /// DELETE: /api/admin/delete-plan/{id}
  Future<plan.PlanModel> deletePlan(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-plan', data: data);
    return plan.PlanModel.fromJson(response.data);
  }

  ////////////////////// Service APIs /////////////////////

  /// GET: /api/admin/get-all-plan
  Future<service.ServiceModel> getAllService() async {
    final response = await _dio.get('api/admin/get-all-service');
    return service.ServiceModel.fromJson(response.data);
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

    return service.ServiceModel.fromJson(response.data);
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

    return service.ServiceModel.fromJson(response.data);
  }

  /// DELETE: /api/admin/delete-plan/{id}
  Future<service.ServiceModel> deleteService(int id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-service', data: data);
    return service.ServiceModel.fromJson(response.data);
  }

  ///////////////////////////// INFLUENCERS APIs /////////////////////

  /// GET: /api/admin/get-influencers
  Future<void> getInfluencers() async {
    final response = await _dio.get('api/admin/get-influencers');
    return response.data;
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
    return response.data;
  }

  /// GET: /api/admin/get-all-plan
  Future<influencer_model.InfluencerModel> getAllInfluencer() async {
    final response = await _dio.get('api/admin/get-all-influencer');
    return influencer_model.InfluencerModel.fromJson(response.data);
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
    return response.data;
  }

  Future<company_model.CompanyModel> getCompany() async {
    final response = await _dio.get('api/admin/get-all-company');

    // map JSON to CompanyModel
    return company_model.CompanyModel.fromJson(response.data);
  }

  ////////////////// Role API ////////////////////
  /// Get: /api/admin/get-all-role

  Future<roles_model.RolesModel> getAllRole() async {
    final response = await _dio.get('api/admin/get-all-role');
    return roles_model.RolesModel.fromJson(response.data);
  }

  /// POST: /api/admin/add-role
  Future<roles_model.RolesModel> addRole(role) async {
    final response = await _dio.post(
      'api/admin/add-role',
      data: {
        'name': role['name'], // ✅ map access
      },
    );

    return roles_model.RolesModel.fromJson(response.data);
  }

  ///DELETE : /api/admin/delete-role/{id}
  Future<roles_model.RolesModel> deleteRole(id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-role', data: data);
    return roles_model.RolesModel.fromJson(response.data);
  }

  ////////////// sub admin /////////////
  /// GET: /api/admin/get-all-sub-admin
  Future<List<sub_admin_model.Datum>> getAllSubAdmin() async {
    final response = await _dio.get('api/admin/get-all-sub-admin');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => sub_admin_model.Datum.fromJson(json)).toList();
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
    return sub_admin_model.SubAdminModel.fromJson(response.data);
  }

  ///DELETE : /api/admin/delete-role/{id}
  Future<sub_admin_model.SubAdminModel> deleteSubAdmin(id) async {
    final data = {'id': id};
    final response = await _dio.delete('api/admin/delete-admin', data: data);
    return sub_admin_model.SubAdminModel.fromJson(response.data);
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
    return response.data;
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
    return GetPermissionModel.fromJson(response.data);
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
    return client_model.ClientModel.fromJson(response.data);
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
    return client_model.ClientModel.fromJson(response.data);
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
    return client_model.ClientModel.fromJson(response.data);
  }

  ///////////////////// client request ////////////////////////
  ///POST: /api/admin/client/request

  Future<request_model.ProjectRequestModel> getClientRequest(request) async {
    final req = {"status": request};
    final response = await _dio.post('api/admin/client/request',
        data: req,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ));
    return request_model.ProjectRequestModel.fromJson(response.data);
  }
}
