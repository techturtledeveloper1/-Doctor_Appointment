import 'dart:io';

import 'package:doctor_appointment/ReusableWidget/app_string.dart';
import 'package:doctor_appointment/Utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as JSON;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  //chasemind local anjan
  // static var baseurl ="http://192.168.1.5:3014/v1/";
  // static var termsofUrl ="http://192.168.1.5:3014/terms-of-use";
  // static var privacyPolicyUrl ="http://192.168.1.5:3014/privacy-notice";

  //chasemind local Ajaysir
  // static var baseurl ="http://192.168.1.3:5050/v1/";
  // static var termsofUrl ="http://192.168.1.3:5050/terms-of-use";
  // static var privacyPolicyUrl ="http://192.168.1.3:5050/privacy-notice";

  //chasemind local anjan new
  // static var baseurl ="http://192.168.1.50:3014/v1/";
  // static var termsofUrl ="http://192.168.1.50:3014/terms-of-use";
  // static var privacyPolicyUrl ="http://192.168.1.50:3014/privacy-notice";

  //Chasemind Local
  // static var baseurl ="http://122.170.0.3:5050/v1/";
  // static var termsofUrl = "http://122.170.0.3:5050/terms-of-use";
  // static var privacyPolicyUrl = "http://122.170.0.3:5050/privacy-notice";

  // Production URL
  // static var baseurl = "https://api.tendfriendapp.com/v1/";
  // static var termsofUrl = "https://admin.tendfriendapp.com/terms-of-use";
  // static var privacyPolicyUrl = "https://admin.tendfriendapp.com/privacy-notice";
  static var imageurlForFeatureIcon =
      "https://api.tendfriendapp.com/uploads/photos/admin/";
  static String imageurl = "https://tendfriend.s3.us-east-2.amazonaws.com/";

  static var baseurl =
      "https://doctor-appointment-booking-backend-9iif.onrender.com/api/";

  // static String My_Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2Mzk5NTUxM2E0M2MwYTFkODRlY2U2YTEiLCJ1c2VyTmFtZSI6ImZmZ3kiLCJmaXJzdE5hbWUiOiJ0ZXN0IiwibGFzdE5hbWUiOiJ0ZXN0IiwiZW1haWwiOiJmZ3JAbWFpbGluYXRvci5jb20iLCJtb2JpbGUiOjg4NTU2NjY1ODgsImFjY291bnRUeXBlIjoxLCJyZWdpc3RlclN0YXR1cyI6MSwic3RhdHVzIjoxLCJpc3VzZXJ2ZXJpZmllZCI6ZmFsc2UsInByb2ZpbGVfaW1hZ2UiOiJuby11c2VyLnBuZyIsImp0aSI6IjYzOTk1NTEzYTQzYzBhMWQ4NGVjZTZhMV8wNDk4ODQiLCJpYXQiOjE2NzA5OTMxNzEsImV4cCI6MTY3MzU4NTE3MX0.mFtaQXY0y2Ty2TnPD2N3TWdNoVZBWxIf9mI3R5RlWRY";
  final String My_Token = AppStrings.token;
  Map<String, String> HeaderNoToken = {'Content-Type': 'application/json'};

  //For Login APi
  Future callLoginApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);

    try {
      print(baseurl + "patient/login");
      http.Response response = await http.post(
        Uri.parse(baseurl + "patient/login"),
        headers: HeaderNoToken,
        body: msg,
      );

      print("Login Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  //For Register APi
  Future callSignupApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);

    try {
      print(baseurl + "patient/register");
      http.Response response = await http.post(
        Uri.parse(baseurl + "patient/register"),
        headers: HeaderNoToken,
        body: msg,
      );

      print("Signup Request Body: $msg");
      print("Signup Response Code: ${response.statusCode}");
      print("Signup Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        // ✅ Normalize the structure for easier handling in UI
        responseData = {
          "success": data["token"] != null,
          "message": data["message"] ?? "Signup successful",
          "token": data["token"],
          "user": data["user"],
        };

        return responseData;
      } else {
        // ✅ Handle API errors gracefully
        return {
          "success": false,
          "message": "Server error (${response.statusCode})",
        };
      }
    } catch (e) {
      print("Error in callSignupApi: $e");
      return {
        "success": false,
        "message": "Something went wrong. Please try again.",
      };
    }
  }

  //callHomeScreen

  Future<dynamic> callGetHomeScreenList() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    // ✅ Debug — Token print
    print("============== API DEBUG LOG ==============");
    print("TOKEN FOUND: ${myToken ?? "NO TOKEN"}");

    if (myToken != null) {
      print("AUTH HEADER SENT: Bearer $myToken");
    }
    print("===========================================");

    if (myToken == null) {
      print("Token not found!");
      return null;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "patient/dashboard");
      http.Response response = await http.get(
        Uri.parse(baseurl + "patient/dashboard"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<dynamic> callGetSpecializationList(String specializationId) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(
        baseurl +
            "patient/specialzationIdByDoctor?specializationId=$specializationId",
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "patient/specialzationIdByDoctor?specializationId=$specializationId",
        ),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  // ✅ GET DOCTOR DETAILS BY ID
  // ✅ GET DOCTOR DETAILS BY ID
  Future<dynamic> callGetDoctorById(String doctorId) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    if (myToken == null) {
      print("⚠️ Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      final url = Uri.parse(
        "${baseurl}patient/view-doctor-details?id=$doctorId",
      );
      print("📤 Request URL: $url");

      final response = await http.get(url, headers: headers);
      print("📥 Doctor Details Response: ${response.body}");

      // ✅ Handle both 200 and 201 status codes as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception fetching doctor details: $e");
    }
    return null;
  }

  // ✅ BOOK APPOINTMENT API
  // ✅ BOOK APPOINTMENT API
  Future<dynamic> callBookAppointmentApi(Map<String, dynamic> body) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    try {
      final url = Uri.parse("${baseurl}appointment/add");
      print("📤 Request URL: $url");
      print("📤 Request Body: $body");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $myToken',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print("📥 Book Appointment Response: ${response.body}");

      // ✅ Handle both 200 and 201 status codes as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in callBookAppointmentApi: $e");
    }

    return responseData;
  }

  Future<dynamic> callGetCalanderScreenList() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "appointment/date");
      http.Response response = await http.get(
        Uri.parse(baseurl + "appointment/date"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<dynamic> callGetProfileApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // ✅ get token again here

    if (myToken == null) {
      print("❌ Token not found for profile API!");
      return {"success": false, "message": "Token not found"};
    }

    try {
      print("🔹 Calling profile API: ${baseurl}patient/profile");
      final response = await http.get(
        Uri.parse("${baseurl}patient/profile"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
      );

      print("📦 Profile Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("❌ API Error: ${response.statusCode}");
        return {"success": false, "message": "Failed to load profile"};
      }
    } catch (e) {
      print("❌ Exception in callGetProfileApi: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<dynamic> callUpdateProfileApi(
    Map<String, dynamic> body,
    File? image,
    String token,
  ) async {
    try {
      var request = http.MultipartRequest(
        'PUT', // ✅ CHANGED FROM POST TO PUT
        Uri.parse('${baseurl}patient/update'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add form data - match exactly with Postman
      body.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          request.fields[key] = value.toString();
        }
      });

      // Add image file if available - field name should be 'profile_photo' based on Postman
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo', // This must match the Postman field name
            image.path,
          ),
        );
      }

      print("📤 Sending PUT request to: ${baseurl}patient/update");
      print("📤 Headers: ${request.headers}");
      print("📤 Fields: ${request.fields}");

      // Send request
      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      print("🔹 Update Profile Response Status: ${response.statusCode}");
      print("🔹 Update Profile Response Body: $resBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(resBody);
      } else {
        return {
          "success": false,
          "message": "Failed to update profile: ${response.statusCode}",
          "body": resBody,
        };
      }
    } catch (e) {
      print("❌ Exception in callUpdateProfileApi: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> callChangedPassword(
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${baseurl}patient/change-password'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add fields
      body.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          request.fields[key] = value.toString();
        }
      });

      print("📤 Sending PUT request to: ${baseurl}patient/change-password");
      print("📤 Headers: ${request.headers}");
      print("📤 Fields: ${request.fields}");

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: $resBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(resBody);
          if (data is Map<String, dynamic>) {
            return data;
          } else {
            return {
              "success": true,
              "message": "Password changed successfully",
              "data": data,
            };
          }
        } catch (e) {
          return {
            "success": true,
            "message": "Password changed successfully (no JSON)",
          };
        }
      } else {
        return {
          "success": false,
          "message": "Failed to change password",
          "status": response.statusCode,
          "body": resBody,
        };
      }
    } catch (e) {
      print("❌ Exception in callChangedPassword: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<dynamic> callMedicineActivecategory() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "medicienCategory/active");
      http.Response response = await http.get(
        Uri.parse(baseurl + "medicienCategory/active"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<dynamic> callGetMedicineCategoryById(String categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    debugPrint("🔍 API CALL: Get Medicine Category By ID");
    debugPrint("➡ Category ID: $categoryId");

    if (myToken == null) {
      debugPrint("❌ Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    String url =
        "$baseurl"
        "medicienCategory/subcategoryIdByMedicines?subcatId=$categoryId";
    debugPrint("🌐 URL: $url");

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      debugPrint("✅ STATUS CODE: ${response.statusCode}");
      debugPrint("📦 RESPONSE BODY:");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        debugPrint("✅ DECODED DATA: $responseData");
        return responseData;
      } else {
        debugPrint("❌ Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🚨 ERROR: $e");
    }

    return null;
  }

  Future<dynamic> callGetMedicineDetailsById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    debugPrint("🔍 API CALL: Get Medicine Category By ID");
    debugPrint("➡ Category ID: $id");

    if (myToken == null) {
      debugPrint("❌ Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    String url =
        "$baseurl"
        "medicien/display-medicein?id=$id";
    debugPrint("🌐 URL: $url");

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      debugPrint("✅ STATUS CODE: ${response.statusCode}");
      debugPrint("📦 RESPONSE BODY:");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        debugPrint("✅ DECODED DATA: $responseData");
        return responseData;
      } else {
        debugPrint("❌ Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🚨 ERROR: $e");
    }

    return null;
  }

  Future<dynamic> callAddToCartApi(Map<String, dynamic> body) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    try {
      final url = Uri.parse("${baseurl}cart/add");
      print("📤 Request URL: $url");
      print("📤 Request Body: $body");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $myToken',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print("📥 Book Appointment Response: ${response.body}");

      // ✅ Handle both 200 and 201 status codes as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in callBookAppointmentApi: $e");
    }

    return responseData;
  }

  Future<dynamic> callViewCartDetailsApi() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "cart/userCart");
      http.Response response = await http.get(
        Uri.parse(baseurl + "cart/userCart"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  // ✅ ✅ UPDATE CART
  // ✅ Update Cart Item
  Future<Map<String, dynamic>> callUpdateCartItemApi(
    String medicineId,
    int quantity,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${baseurl}cart/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'medicineId': medicineId, // ✅ Correct key name
          'quantity': quantity,
        }),
      );

      print("🔄 Updating: $medicineId → Qty: $quantity");
      print("🧾 Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Update Cart Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ✅ Remove Cart Item
  Future<Map<String, dynamic>> callRemoveCartItemApi(
    String medicineId,
    String token,
  ) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseurl}cart/remove'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json', // ✅ required for body
        },
        body: json.encode({
          'medicineId': medicineId, // ✅ send correct body
        }),
      );

      print("🗑 Removing: $medicineId → ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Remove Cart Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ✅ Clear Entire Cart
  Future<Map<String, dynamic>> callClearCartApi(String token) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseurl}cart/clear'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("🧹 Clearing entire cart → ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Clear Cart Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ✅ Alternative: Clear Cart with user ID (if needed)
  Future<Map<String, dynamic>> callClearCartByUserIdApi(
    String userId,
    String token,
  ) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseurl}cart/clear/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("🧹 Clearing cart for user: $userId → ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Clear Cart by User Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<dynamic> callViewAddressDetailsApi() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "patientAddress/list");
      http.Response response = await http.get(
        Uri.parse(baseurl + "patientAddress/list"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<dynamic> callAddAddressApi(Map<String, dynamic> body) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    try {
      final url = Uri.parse("${baseurl}patientAddress/create");
      print("📤 Request URL: $url");
      print("📤 Request Body: $body");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $myToken',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print("📥 Book Appointment Response: ${response.body}");

      // ✅ Handle both 200 and 201 status codes as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in callBookAppointmentApi: $e");
    }

    return responseData;
  }

  // ✅ Update Address - CORRECTED
  Future<Map<String, dynamic>> callUpdateAddressApi(
    String addressId,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${baseurl}patientAddress/update?addressId=$addressId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body), // ✅ Send the complete updated data
      );

      print("🔄 Updating: $addressId");
      print("📤 Request Body: $body");
      print("🧾 Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Update Address Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> callRemoveAddressApi(
    String addressId,
    String token,
  ) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseurl}patientAddress/delete?addressId=$addressId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json', // ✅ required for body
        },
        body: json.encode({
          'addressId': addressId, // ✅ send correct body
        }),
      );

      print("🗑 Removing: $addressId → ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Remove Cart Error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<dynamic> callViewPrescriptionListApi() async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token"); // load saved token

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "prescription/user-prescription");
      http.Response response = await http.get(
        Uri.parse(baseurl + "prescription/user-prescription"),
        headers: headers,
      );
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<dynamic> callViewPrescriptionDetailsApi(String id) async {
    var responseData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myToken = prefs.getString("token");

    if (myToken == null) {
      print("Token not found!");
      return null;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    try {
      print(baseurl + "prescription/details?id=$id");
      http.Response response = await http.get(
        Uri.parse(baseurl + "prescription/details?id=$id"),
        headers: headers,
      );
      print("Prescription Details Response: ${response.body}");

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return responseData['data']; // Return only the data part
        } else {
          print("API returned error: ${responseData['message']}");
          return null;
        }
      } else {
        print("Error Status: ${response.statusCode}");
        print("Error Body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  //For Forgot Pass APi
  Future callForgotPassApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "user/forgotPassworFor-User");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/forgotPassworFor-User"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("Login Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Reset password Pass APi
  Future callResetPassApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "user/passwordResetForUser");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/passwordResetForUser"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("Reset pass  Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For User Registration APi
  Future callUserRegistrationApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);
    print("Api service" + msg);
    try {
      print(baseurl + "user/user-create");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/user-create"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("callUserRegistrationApi Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For OTP After Registration
  Future callOTPVerificationAfterRegistration(
    Map<String, dynamic> otpJson,
  ) async {
    var responseData;
    String msg = json.encode(otpJson);

    print("Api service" + msg);

    try {
      print(baseurl + "user/checkOtpVerificationForUserRegister");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/checkOtpVerificationForUserRegister"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("callOTPVerificationAfterRegistration Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For OTP After Forgot
  Future callOTPVerificationAfterForgotPass(
    Map<String, dynamic> otpJson,
  ) async {
    var responseData;
    String msg = json.encode(otpJson);

    print("Api service" + msg);

    try {
      print(baseurl + "user/checkOtpVerificationFor-User-Forgotpassword");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/checkOtpVerificationFor-User-Forgotpassword"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("callOTPVerificationAfterForgot Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Resend OTP
  Future callResendOTPApi(Map<String, dynamic> otpJson) async {
    var responseData;
    String msg = json.encode(otpJson);

    print("Api service" + msg);

    try {
      print(baseurl + "user/resendOTPForUsersAll");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/resendOTPForUsersAll"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("callResendOTPApi Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Places API
  Future callPlacesApi(String input, {String type = ""}) async {
    var responseData;

    print("Api service");

    try {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyA76B_O-7asDg9vyyyrhu8EXKd3bVbq2RU&input=$input";
      if (type.isNotEmpty) {
        url += "&types=$type";
      }
      print(url);
      http.Response response = await http.get(
        Uri.parse(url),
        headers: HeaderNoToken,
      );
      print("call Places Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callbasicdetailupdate(
    File? imagefile,
    List<XFile> imagesList,
    List hashTagList,
    List? hoursList,
    String? brief,
    String? userId,
  ) async {
    var responseData;

    print("inside");

    try {
      var uri = Uri.parse(baseurl + "user/user-businessAccount-update-details");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(HeaderWithToken);

      print("Update user tests1 :" + imagefile!.path);
      if (imagefile.path != null) {
        var steam = http.ByteStream(imagefile.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "profile_image",
          steam,
          length,
          filename: path.basename(imagefile.path),
        );

        request.files.add(multipartfile);
      }

      print("requests  1" + request.files.toString());
      List<http.MultipartFile> newList = [];
      try {
        if (imagesList != null) {
          for (int i = 0; i <= imagesList.length; i++) {
            var stream = new http.ByteStream(
              imagesList.elementAt(i).openRead(),
            );
            var length = await imagesList.elementAt(i).length();
            print(
              "list $i" +
                  imagesList.elementAt(i).path.toString() +
                  "\n list 2" +
                  imagesList.length.toString(),
            );
            var multipartFile = new http.MultipartFile(
              "photos",
              stream,
              length,
              filename: path.basename(imagesList.elementAt(i).path),
            );
            newList.add(multipartFile);
          }
        }
      } catch (e) {
        print("list error" + e.toString());
      }

      request.files.addAll(newList!);
      print("requests 3" + request.files.toString());
      request.fields["userId"] = userId!;
      request.fields["featuresId"] = hashTagList!.join(',');
      request.fields["briefDescription"] = brief!;
      request.fields['timetable'] = hoursList!.length > 0
          ? json.encode(hoursList)
          : "";
      print("Update user responce :" + request.fields.toString());

      var response = await request.send().timeout(
        const Duration(minutes: 10),
        // onTimeout: () {
        //   // Time has run out, do what you wanted to do.
        //   print("Fail"); // Request Timeout response status code
        // },
      );
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("Update user responce :" + response.toString().toString());
      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  //For Search Bar and BarTender OTP

  Future callSearchBarandBartenderAPi(String searchkey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/businessUserListForSerach?searchKey=$searchkey" +
            "\n header\n" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "user/businessUserListForSerach?searchKey=$searchkey",
        ),
        headers: HeaderWithToken,
      );
      print("call Search Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Add to favourite Api
  Future callAddToFavouriteApi(Map<String, dynamic> otpJson) async {
    var responseData;
    String msg = json.encode(otpJson);
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print("Api service" + msg);

    try {
      print(baseurl + "user/addfavoriteUser");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/addfavoriteUser"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("call Add To favourite Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For remove to favourite  Api
  Future callRemoveToFavouriteApi(Map<String, dynamic> otpJson) async {
    var responseData;
    String msg = json.encode(otpJson);
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print("Api service" + msg);

    try {
      print(baseurl + "user/removefavoriteUser");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/removefavoriteUser"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("call Remove To favourite Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        ///**************************

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callPersonalAccounUpdate(
    File imagefile,
    List hashTagList,
    List<String> hoursList,
    String brief,
    String userId,
  ) async {
    var responseData;
    print("insdie call update personal");

    try {
      var uri = Uri.parse(baseurl + "user/user-personalAccount-update-details");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(HeaderWithToken);

      if (imagefile != null) {
        var steam = http.ByteStream(imagefile.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "profile_image",
          steam,
          length,
          filename: path.basename(imagefile.path),
        );

        request.files.add(multipartfile);
      }

      //  request.files.add(multipartfile2);

      request.fields["userId"] = userId;
      request.fields["featuresId"] = hashTagList.join(',');
      request.fields["briefDescription"] = brief;
      request.fields['favorite'] = hoursList.join(',');

      print("request" + request.fields.toString());

      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("Update user responce :" + response.toString().toString());
      return result;
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Search Bar and BarTender OTP

  Future callSkipProfileApi() async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(baseurl + "user/skipUsrDetails");
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/skipUsrDetails"),
        headers: HeaderWithToken,
      );

      if (response.statusCode == 200) {
        print("call Create pos Api Success" + response.body);
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callCreatePostApi(
    String userID,
    List imagesList,
    double lat,
    double long,
    String locationName,
    String content,
    int pricavyStatus,
    List selectedFeatureListId,
  ) async {
    var responseData;

    try {
      var uri = Uri.parse(baseurl + "post/post-create");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(HeaderWithToken);

      List<http.MultipartFile> newList = [];
      if (imagesList != null) {
        for (int i = 0; i < imagesList.length; i++) {
          var stream = new http.ByteStream(imagesList.elementAt(i).openRead());
          var length = await imagesList.elementAt(i).length();
          var multipartFile = new http.MultipartFile(
            "photos",
            stream,
            length,
            filename: path.basename(imagesList.elementAt(i).path),
          );
          newList.add(multipartFile);
        }
      }
      request.files.addAll(newList!);

      //  request.files.add(multipartfile2);

      request.fields["userId"] = userID;

      if (lat != null) {
        request.fields['location'] = long.toString() + "," + lat.toString();
      }

      request.fields["locationName"] = locationName;
      request.fields['content'] = content;
      request.fields["privacyStatus"] = pricavyStatus.toString();
      request.fields["featuresId"] = selectedFeatureListId.join(',');

      print("Create post request" + request.fields.toString());

      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);

      AppColor.isCreatepost = false;
      //print("create post response :" + AppColor.isCreatepost.toString());
      return result;
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callEditPostApi(
    String userID,
    List imagesList,
    double? lat,
    double? long,
    String locationName,
    String content,
    int pricavyStatus,
    List deletedMedialist,
    String postId,
    List selectedFeatureListId,
  ) async {
    var responseData;

    try {
      var uri = Uri.parse(baseurl + "post/post-update");
      print(baseurl + "post/post-update");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      // print("Create post request" + request.fields.toString());
      request.headers.addAll(HeaderWithToken);

      List<http.MultipartFile> newList = [];
      if (imagesList != null) {
        for (int i = 0; i < imagesList.length; i++) {
          var stream = new http.ByteStream(imagesList.elementAt(i).openRead());
          var length = await imagesList.elementAt(i).length();
          var multipartFile = new http.MultipartFile(
            "photos",
            stream,
            length,
            filename: path.basename(imagesList.elementAt(i).path),
          );
          newList!.add(multipartFile);
        }
      }
      request.files.addAll(newList!);

      //  request.files.add(multipartfile2);

      // request.fields["userId"] = userID;

      request.fields['location'] = lat.toString() + "," + long.toString();
      request.fields["locationName"] = locationName;
      request.fields['content'] = content;
      request.fields["privacyStatus"] = pricavyStatus.toString();
      request.fields["_id"] = postId;
      request.fields["deletedPhotos"] = deletedMedialist.join(', ');
      request.fields["featuresId"] = selectedFeatureListId.join(',');
      print("Edit post request harsh " + request.fields.toString());

      print("Edit post request" + request.fields.toString());
      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);

      AppColor.isCreatepost = false;
      //print("create post response :" + AppColor.isCreatepost.toString());
      return result;
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Post Suggestion List

  Future callSuggestionsListApi(String searchkey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "friends/getFriendSuggestionList?searchKey=$searchkey" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "friends/getFriendSuggestionList?searchKey=$searchkey",
        ),
        headers: HeaderWithToken,
      );
      print("call SuggestionList Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callSubmitAnIssueApi(Map<String, dynamic> loginJson) async {
    var responseData;
    String msg = json.encode(loginJson);
    print("Api service" + msg);
    try {
      print(baseurl + "adminUser/contactUsForm");
      http.Response response = await http.post(
        Uri.parse(baseurl + "adminUser/contactUsForm"),
        headers: HeaderNoToken,
        body: msg,
      );
      print("callSubmitAnIssueApi Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Feed Post Api

  Future callGetFeedList(int pageNumber) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "post/get-PostFeed-List?pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "post/get-PostFeed-List?pageNumber=$pageNumber"),
        headers: HeaderWithToken,
      );
      print("call Get Feed List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //NearestBar List Api

  Future callGetNearestBarList(double? lat, double? long) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      // Construct the URL with lat and long as query parameters
      final url = Uri.parse(baseurl + "user/nearestBarDetails").replace(
        queryParameters: {'lat': lat.toString(), 'long': long.toString()},
      );

      print("API URL: $url");
      print("Headers: $HeaderWithToken");

      http.Response response = await http.get(url, headers: HeaderWithToken);

      print("call Get Nearest Bar List API Success: ${response.body}");
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }

    return null;
  }

  //pagenationapi call
  Future callpagenationapi(int _page) async {
    var responseData;
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdGF0dXMiOjEsInJlZ2lzdGVyU3RhdHVzIjozLCJpc2RlbGV0ZWQiOmZhbHNlLCJlbWFpbCI6ImRpeWFudGVjaG5vbG9naWVzNjE2QGdtYWlsLmNvbSIsInVzZXJJZCI6IjYxNDQyNDYxYmRlOWY0MDlhODdlOGYyYSIsInByaXZhY3lTdGF0dXMiOjAsInN0YXR1c1R5cGUiOjEsImZpcnN0TmFtZSI6IloiLCJ1c2VyTmFtZSI6ImRoeWFudGVjaG5vbG9neSIsImxhc3ROYW1lIjoiUGF0ZWwiLCJwcm9maWxlVXJsIjoiVXNlci9JbWFnZXMvVXNlci9JbWFnZXMvcHJvZmlsZV9pbWFnZS0xNjQ2ODk3MTM0MzAzLmpwZyIsImZhdm91cml0ZVN0cmFpbiI6InB1cnBsZXdfZmFnYSIsImFib3V0IjoiSSBhbSBhbiBpbXBvcnRhbnQgcXVlc3Rpb24gZm9yIHlvdSBnZXQgYSBwZXJzb24gd2hvIGNhbiBiZSBpbiB5b3VyIGxpZmUgYW5kIEVuZ2xpc2ggdG8gRW5nbGlzaCB0byBFbmdsaXNoIGFuZCBjYW4ndCBFbmdsaXNoIHRvIEVuZ2xpc2ggdG8gRW5nbGlzaCAiLCJnZW5kZXIiOiJtYWxlIiwiZG9iIjoiMTAvMTgvMjAxOSIsImxvY2F0aW9uTmFtZSI6IkJvcml2YWxpLCBNdW1iYWksIE1haGFyYXNodHJhLCBJbmRpYSIsIm1vYmlsZSI6IiIsImp0aSI6InVuZGVmaW5lZF80NTY1MzAiLCJpYXQiOjE2NjMyNDc2NDcsImV4cCI6MTY2NTgzOTY0N30.2VxlJq5V77HPD5QmniMmoZpbITbIeDGewSC11Vz0b8k',
    };
    try {
      print(
        "http://122.170.111.66:3001/v1/buddies/get-BuddiesListForAdd?searchKey=&pageNumber=$_page",
      );
      http.Response response = await http.get(
        Uri.parse(
          "http://122.170.111.66:3001/v1/buddies/get-BuddiesListForAdd?searchKey=&pageNumber=$_page",
        ),
        headers: Header,
      );

      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);
        print("Pagenation  list sucess : " + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Post Like and Dislike APi
  Future callPostLikeandDislikeApi(Map<String, dynamic> likeJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(likeJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "post/post-likeDislike");
      http.Response response = await http.post(
        Uri.parse(baseurl + "post/post-likeDislike"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Login Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Post Comment Api
  Future callPostCommentApi(Map<String, dynamic> likeJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(likeJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "post/post-addComment");
      http.Response response = await http.post(
        Uri.parse(baseurl + "post/post-addComment"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Post Comment Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Post Comment List Api
  Future callGetPostCommentListApi(String postId) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    //print("Api service"+msg);

    try {
      print(baseurl + "post/post-commentListForHomePage?postId=$postId");
      http.Response response = await http.get(
        Uri.parse(baseurl + "post/post-commentListForHomePage?postId=$postId"),
        headers: HeaderWithToken,
      );
      print("Get Post Comment List Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Post Comment Reply Api
  Future callPostCommentReplyApi(Map<String, dynamic> likeJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(likeJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "post/post-addCommentReply");
      http.Response response = await http.post(
        Uri.parse(baseurl + "post/post-addCommentReply"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Post Comment Reply Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Post Delete Api
  Future callDeletePostApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "post/post-Delete");
      http.Response response = await http.post(
        Uri.parse(baseurl + "post/post-Delete"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Post Delete Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Edit Perrsonal Account Api
  Future CallEditpersonalAccountApi(String userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/userDetailsGetById"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userDetailsGetById"),
        headers: Header,
      );
      print("Pofile detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile detail message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Friend Suggestion List

  Future callGetFFriendSuggesionlist(int pageNumber, String searchKey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "friends/getFriendSuggestionList?searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "friends/getFriendSuggestionList?searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Friend Suggestion List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  Future callUserPostFeedListApi(userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "post/get-user-PostFeed-List?userId=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "post/get-user-PostFeed-List?userId=$userId"),
        headers: Header,
      );
      print("Post detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("Post detail message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For User Follow Api
  Future callFollowUserApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "follower/create");
      http.Response response = await http.post(
        Uri.parse(baseurl + "follower/create"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Follow User Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Send user Friend request
  Future callSenduserFriendrequestApi(
    Map<String, dynamic> deletePostJson,
  ) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "friendsRequest/createRequest");
      http.Response response = await http.post(
        Uri.parse(baseurl + "friendsRequest/createRequest"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Send Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Cancel Send user Friend request
  Future callCancelFriendrequestApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "friendsRequest/cancelRequest");
      http.Response response = await http.post(
        Uri.parse(baseurl + "friendsRequest/cancelRequest"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Send Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Unfollow User
  Future callUnfollowApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "follower/unFollow-User");
      http.Response response = await http.post(
        Uri.parse(baseurl + "follower/unFollow-User"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("UnFolllow Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Friend request List

  Future callGetFriendRequestListlist(int pageNumber, String searchKey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "friendsRequest/getFriendsRequestList?searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "friendsRequest/getFriendsRequestList?searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Friend Suggestion List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For accept friend reuqest
  Future callAcceptFriendrequestApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "friendsRequest/approveRequest");
      http.Response response = await http.post(
        Uri.parse(baseurl + "friendsRequest/approveRequest"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Accept Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For reject friend reuqest
  Future callRejectFriendrequestApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "friendsRequest/rejectRequest");
      http.Response response = await http.post(
        Uri.parse(baseurl + "friendsRequest/rejectRequest"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Accept Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //for EditPersonalaccount Photos api

  //For User wise Friend  List

  Future callUserWiseFriendListApi(
    String userID,
    int pageNumber,
    String searchKey,
  ) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/getUserFriendList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "user/getUserFriendList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Friend Suggestion List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For User wise Follower  List

  Future callUserWiseFollowerListListApi(
    String userID,
    int pageNumber,
    String searchKey,
  ) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/getUserFollowerList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "user/getUserFollowerList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call User wise Follower  List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Friend Following List

  Future callUserWiseFollowingListApi(
    String userID,
    int pageNumber,
    String searchKey,
    var accountType,
  ) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/getUserFollowingList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber&accountType=$accountType" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "user/getUserFollowingList?userId=$userID&searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Following  List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For remove friend
  Future callremoveFriendApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "friends/removeFriends");
      http.Response response = await http.post(
        Uri.parse(baseurl + "friends/removeFriends"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Accept Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Remove follower Api
  Future callRemoveUnfollowUserApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "follower/unFollwingUser");
      http.Response response = await http.post(
        Uri.parse(baseurl + "follower/unFollwingUser"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Accept Friend Request Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For User List For review

  Future callGetUserListForReview(int pageNumber, String searchKey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/getUserListForRating?searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "user/getUserListForRating?searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("callGet User List For Review" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For CategoryList Api

  Future callGetCategoryListApi(Map<String, dynamic> catJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(catJson);
    try {
      print(
        baseurl +
            "user/getRatingCategoryListForDropDown" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/getRatingCategoryListForDropDown"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call Get category List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Feature  Api

  Future callGetFeatureListApi(String userId, int accountType) async {
    var responseData;

    // Define headers with authorization token
    Map<String, String> headerWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    // Construct request body
    Map<String, dynamic> bodyData = {
      "userId": userId,
      "accountType": accountType,
    };

    String body = json.encode(bodyData);

    try {
      print(
        "API URL: ${baseurl}user/getFeatureListForDropDown?accountType=$accountType",
      );
      print("Request Headers: $headerWithToken");
      print("Request Body: $body");

      // Send HTTP POST request
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/getFeatureListForDropDown"),
        body: body,
        headers: headerWithToken,
      );

      print("API Response: ${response.body}");

      // Check response status
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      return null;
    }
  }

  //For Edit Perrsonal Account Api
  Future CallEditpersonalBusinessAccountApi(String userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/userDetailsGetById?_id=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userDetailsGetById?_id=$userId"),
        headers: Header,
      );
      print("Pofile detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile detail message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  Future callMultiplePhotosApi(String userID, List<XFile> imagesList) async {
    print("inside");
    try {
      var uri = Uri.parse(baseurl + "user/user-businessAccount-update-details");
      print(uri);
      var request = http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer $My_Token",
      };
      request.headers.addAll(headers);
      print("requests" + request.headers.toString());
      // print("Update user tests1 :" + imageFile.path);
      List<http.MultipartFile> newList = [];
      if (imagesList != null) {
        for (int i = 0; i < imagesList.length; i++) {
          var stream = http.ByteStream(imagesList.elementAt(i).openRead());
          var length = await imagesList.elementAt(i).length();
          var multipartFile = new http.MultipartFile(
            "photos",
            stream,
            length,
            filename: path.basename(imagesList.elementAt(i).path),
          );
          newList!.add(multipartFile);
        }
      }
      request.files.addAll(newList!);

      //  request.files.add(multipartfile2);

      request.fields["userId"] = userID;

      print(" post request" + request.fields.toString());
      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("add image responce :" + responsedata.toString());
      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  //for EditPersonalaccount Photos api
  //For Edit Perrsonal Account Api
  Future CallEditpersonalAccountPhotosApi() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/userPhotoList"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userPhotoList"),
        headers: Header,
      );
      print("Pofile detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile detail message====>" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  /////remove favapi
  Future callremovefavorite(Map<String, Object> favremovejson) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;

    final msg = jsonEncode(favremovejson);
    // print(msg);
    try {
      print(baseurl + "user/removefavoriteUser");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/removefavoriteUser"),
        headers: Header,
        body: msg,
      );

      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);
        print("user remove Success" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////add favorite search///
  Future callfavouritesearchApi(String searchkey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/businessUserListForSerach?searchKey=$searchkey" +
            "\n header\n" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "user/businessUserListForSerach?searchKey=$searchkey",
        ),
        headers: HeaderWithToken,
      );
      print("call Search Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }
  //
  // Future callfavouritesearchApi(String searchkey) async {
  //   var responseData;
  //   Map<String, String> HeaderWithToken = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $My_Token',
  //   };
  //   try {
  //     print(baseurl +
  //         "user/businessUserListForSerach?searchKey=$searchkey" +
  //         "\n header\n" +
  //         HeaderWithToken.toString());
  //     http.Response response = await http.get(
  //       Uri.parse(
  //           baseurl + "user/businessUserListForSerach?searchKey=$searchkey"),
  //       headers: HeaderWithToken,
  //     );
  //     print("call Search Api Success" + response.body);
  //     if (response.statusCode == 200) {
  //       responseData = JSON.jsonDecode(response.body);
  //
  //       return responseData;
  //     }
  //   } catch (E) {
  //     print("Error" + E.toString());
  //   }
  // }

  ///////////////update hashtag/////
  Future callPostUpdatehashtagApi(Map<String, Object> hashJson) async {
    var responseData;
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    final ResetJson = jsonEncode(hashJson);
    try {
      print(baseurl + "user/updateUserHashtag");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/updateUserHashtag"),
        headers: header,
        body: ResetJson,
      );
      print(
        "Post hashtag Success" +
            response.request.toString() +
            "\n res" +
            response.body,
      );
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //update information api
  Future callUpdateInformationApi(Map<String, Object> resetJson) async {
    //For Login APi
    var responseData;
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    final ResetJson = jsonEncode(resetJson);
    print(resetJson);
    try {
      print(baseurl + "user/updateUserBasicDetails");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/updateUserBasicDetails"),
        headers: header,
        body: ResetJson,
      );
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body.toString());
        print("Password Res.." + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////add favorite search///
  Future callgetUserDetailsbyId(String userId) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "user/userDetailsGetById?_id=$userId" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userDetailsGetById?_id=$userId"),
        headers: HeaderWithToken,
      );
      print("call Get user details Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Timetabledata api  Api
  Future callTimetabledataApi(Map<String, Object> resetJson) async {
    //For Login APi
    var responseData;
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    final ResetJson = jsonEncode(resetJson);
    print(resetJson);
    try {
      print(baseurl + "user/user-businessAccount-update-details");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/user-businessAccount-update-details"),
        headers: header,
        body: ResetJson,
      );
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body.toString());
        print("timetable Res.." + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  /////multipart timetable

  Future calltimetableapi(List hoursList, String userId) async {
    print("inside");
    try {
      var uri = Uri.parse(baseurl + "user/user-businessAccount-update-details");
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(header);
      print("requests" + request.headers.toString());
      request.fields["userId"] = userId;
      request.fields['timetable'] = hoursList.length > 0
          ? json.encode(hoursList)
          : json.encode(hoursList);
      print("Update user responce :" + request.fields.toString());
      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("Update user responce :" + response.toString());
      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  //For remove to timetabledata  Api
  Future callremovetimelistapi(Map<String, Object> removeJson) async {
    var responseData;
    final msg = json.encode(removeJson);
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print(My_Token.toString());

    try {
      print(baseurl + "user/removeUserTimetable");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/removeUserTimetable"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("call Remove To Hourlist Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  ///////////////update Hourlist/////
  Future callPostUpdatehourlistApi(Map<String, Object> hourJson) async {
    var responseData;
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    //print("Api service"+msg);
    final ResetJson = jsonEncode(hourJson);
    try {
      print(baseurl + "user/updateUserTimetable");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/updateUserTimetable"),
        headers: header,
        body: ResetJson,
      );
      print("Post Hourlist Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //Call Save user rating Api
  Future callSaveUserRatingApi(
    File? imageFile,
    String? userId,
    String categoryRating,
    String feature,
    String review,
  ) async {
    var responseData;
    print("inside");
    String? path;
    if (imageFile != null) {
      path = imageFile!.path;
      print("requests 2" + path!);
    } else {
      path = "";
      print("requests 3");
    }

    print(baseurl + "event/save-rating".toString());
    // async {
    //   Map<String, String> HeaderWithToken = {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $My_Token',
    //   };
    //   var responseData;
    try {
      var uri = Uri.parse(baseurl + "user/ratingSave");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      // var responseData;
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(HeaderWithToken);

      print("requests 4" + path);

      if (path != "") {
        print("requests 5" + path);

        var steam = http.ByteStream(imageFile!.openRead())..cast();
        var length = await imageFile.length();
        var multipartfile = http.MultipartFile(
          "Image",
          steam,
          length,
          filename: path,
        );
        request.files.add(multipartfile);
      }
      List<http.MultipartFile> newList = [];
      request.files.addAll(newList!);
      request.fields["userId"] = userId!;
      request.fields["review"] = review;
      request.fields["categoryRating"] = categoryRating;
      request.fields["feature"] = feature;

      print("$categoryRating /*/*/*/**/*");

      // request.fields['data'] = jsonEncode(ratingJson);
      print(
        "Update user request //////////////////////:" +
            request.fields.toString(),
      );
      print(
        "Update user request files **********************:" +
            request.files.toString(),
      );

      print(baseurl + "user/ratingSave");
      var response = await request.send();

      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);

      return result;
      // if (response.statusCode == 200) {
      //   var responseString = await response.stream.bytesToString();
      //   responseData = jsonDecode(responseString);
      //   print("Save User rating" + responseString);
      //   return responseData;
      // } else {
      //   print("Failed to save user rating. Status code: ${response.statusCode}");
      // }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  //For Delete user Rating Api

  Future callDeleteRatingApi(Map<String, dynamic> deleteRatingJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deleteRatingJson);

    //print("Api service"+msg);

    try {
      print(baseurl + "user/ratingDelete");
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/ratingDelete"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Rating Delete Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For user selected  Feature  Api

  Future callGetSelectedFeatureListApi(Map<String, dynamic> catJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(catJson);
    try {
      print(
        baseurl + "user/userFeatureListForEdit" + HeaderWithToken.toString(),
      );
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/userFeatureListForEdit"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call Get userFeature List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  callAddBarTenderSaveApi(
    File imageProfileFile,
    String firstname,
    String lastname,
    String locationname,
    lat,
    lng,
    String email,
  ) async {
    print("insdie call Add bar");
    File imagefile = new File(imageProfileFile.path);
    try {
      var uri = Uri.parse(baseurl + "accountTypeMaster/accountTypeSave");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(HeaderWithToken);

      if (imagefile != null) {
        var steam = http.ByteStream(imagefile.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "profile_image",
          steam,
          length,
          filename: path.basename(imagefile.path),
        );

        request.files.add(multipartfile);
      }

      //  request.files.add(multipartfile2);

      request.fields["firstName"] = firstname;
      request.fields["lastName"] = lastname;
      request.fields["accountType"] = "1";
      request.fields["locationName"] = locationname;
      request.fields["lat"] = lat.toString();
      request.fields["long"] = lng.toString();
      request.fields["email"] = email;

      print("request" + request.fields.toString());

      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("Add Bar Tender user responce :" + response.toString().toString());
      return result;
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  callAddBarSaveApi(
    File imageProfileFile,
    String barName,
    String locationName,
    lat,
    lng,
    String email,
    String website,
  ) async {
    var responseData;
    print("insdie call Add bar");
    File imagefile = new File(imageProfileFile.path);
    try {
      var uri = Uri.parse(baseurl + "accountTypeMaster/accountTypeSave");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(HeaderWithToken);

      if (imagefile != null) {
        var steam = http.ByteStream(imagefile.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "profile_image",
          steam,
          length,
          filename: path.basename(imagefile.path),
        );

        request.files.add(multipartfile);
      }

      //  request.files.add(multipartfile2);

      request.fields["barName"] = barName;
      request.fields["locationName"] = locationName;
      request.fields["accountType"] = "2";
      request.fields["lat"] = lat.toString();
      request.fields["long"] = lng.toString();
      request.fields["email"] = email;
      request.fields["webSite"] = website;

      print("request" + request.fields.toString());

      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("Add Bar user responce :" + response.toString().toString());
      return result;
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Discovery Post Lise

  Future callGetDiscoveryPostListApi(String searchKey, int index) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "discovery/discovery-postListWithDetails?index=$index&searchKey=$searchKey" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "discovery/discovery-postListWithDetails?index=$index&searchKey=$searchKey",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Discovery Post List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////eventlist get///////
  Future callgeteventlist(String eventmonth, String eventYear) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/eventList?month=$eventmonth&year=$eventYear"));
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "event/eventList?month=$eventmonth&year=$eventYear",
        ),
        headers: Header,
      );
      print("Event detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  Future callgeteventlistByFeature(String feature) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/event/eventListByHashTag?hashTag=Goldentee"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "event/eventListByHashTag?hashTag=Goldentee"),
        headers: Header,
      );
      print("Event detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("call get event list By Feature" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Get Discovery Friend List

  Future callGetDiscoveryFriendListApi(String searchKey, int pageNumber) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "discovery/get-getFriendsListForDiscovery?searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "discovery/get-getFriendsListForDiscovery?searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Discovery Post List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Post List Location Wise

  Future callLocationWisePostListApi(Map<String, dynamic> postJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(postJson);
    try {
      print(
        baseurl + "discovery/discovery-placeList" + HeaderWithToken.toString(),
      );
      http.Response response = await http.post(
        Uri.parse(baseurl + "discovery/discovery-placeList"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call Get location wise post List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Discovery HashTag List

  Future callGetDiscoveryHashTagListApi(String searchKey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "discovery/discovery-hashTagList?contant=$searchKey" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "discovery/discovery-hashTagList?contant=$searchKey",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Discovery HashTag List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Discovery HashTag List

  Future callGetDiscoveryPostListByHashTagApi(
    String searchKey,
    String hashTagId,
  ) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "discovery/getpostListByHashTag?searchKey=$searchKey&hashTagId=$hashTagId" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "discovery/getpostListByHashTag?searchKey=$searchKey&hashTagId=$hashTagId",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Discovery PostList By HashTag Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  /////createeventpost Api////////
  Future callCreateevent(
    File? imagefile,
    List<dynamic> hashTagList,
    List friendiList,
    String desc,
    String eventTitle,
    String eventStartTime,
    String eventDate,
    var hostId,
    var barID,
    String locationName,
    var lat,
    var lng,
    int eventType,
  ) async {
    var responseData;
    print("inside");
    String? path;
    if (imagefile != null) {
      path = imagefile!.path;
      print("requests 2" + path!);
    } else {
      path = "";
      print("requests 3");
    }

    print(baseurl + "event/save-event".toString());
    try {
      var uri = Uri.parse(baseurl + "event/save-event");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(HeaderWithToken);
      print("requests" + request.headers.toString());
      //  print("Update user tests1 :" + imagefile!.path);
      print("requests 4" + path);

      if (path != "") {
        print("requests 5" + path);
        var steam = http.ByteStream(imagefile!.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "event_image",
          steam,
          length,
          filename: path,
        );
        request.files.add(multipartfile);
      }
      List<http.MultipartFile> newList = [];
      request.files.addAll(newList!);
      request.fields["hostId"] = hostId;
      request.fields["barId"] = barID;
      request.fields["locationName"] = locationName;
      request.fields["lat"] = lat as String;
      request.fields["long"] = lng as String;
      request.fields["featuresId"] = hashTagList.join(',');
      if (eventType == 3) {
        request.fields["invitedfriendsId"] = friendiList.join(',');
      }

      request.fields["description"] = desc;
      request.fields["eventTitle"] = eventTitle;
      request.fields["eventType"] = eventType.toString();
      request.fields["eventStartDate"] =
          eventDate + "T" + eventStartTime + ".000+00:00";

      print("Update user request :" + request.fields.toString());
      print("Update user request files:" + request.files.toString());
      var response = await request.send().timeout(
        const Duration(minutes: 10),
        // onTimeout: () {
        //   // Time has run out, do what you wanted to do.
        //   print("Fail"); // Request Timeout response status code
        // },
      );
      print("Update user responce data:" + response.statusCode.toString());
      print("Update user responce stream:" + response.stream.toString());
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);

      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  Future callEditevent(
    String _id,
    File? imagefile,
    List<dynamic> hashTagList,
    List friendiList,
    String desc,
    String eventTitle,
    String eventStartTime,
    String eventDate,
    var hostId,
    var barID,
    String locationName,
    var lat,
    var lng,
    int eventType,
  ) async {
    var responseData;
    print("inside");
    String? path;
    if (imagefile != null) {
      path = imagefile!.path;
      print("requests 2" + path!);
    } else {
      path = "";
      print("requests 3");
    }

    print(baseurl + "event/update-event".toString());
    try {
      var uri = Uri.parse(baseurl + "event/update-event");
      Map<String, String> HeaderWithToken = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $My_Token',
      };
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(HeaderWithToken);
      print("requests" + request.headers.toString());
      //  print("Update user tests1 :" + imagefile!.path);
      print("requests 4" + path);

      if (path != "") {
        print("requests 5" + path);
        var steam = http.ByteStream(imagefile!.openRead())..cast();
        var length = await imagefile.length();
        var multipartfile = http.MultipartFile(
          "event_image",
          steam,
          length,
          filename: path,
        );
        request.files.add(multipartfile);
      }
      request.fields['_id'] = _id;
      List<http.MultipartFile> newList = [];
      request.files.addAll(newList!);
      request.fields["hostId"] = hostId;
      request.fields["barId"] = barID;
      request.fields["locationName"] = locationName;
      request.fields["lat"] = lat as String;
      request.fields["long"] = lng as String;
      request.fields["featuresId"] = hashTagList.join(',');
      if (eventType == 3) {
        request.fields["invitedfriendsId"] = friendiList.join(',');
      }

      request.fields["description"] = desc;
      request.fields["eventTitle"] = eventTitle;
      request.fields["eventType"] = eventType.toString();
      request.fields["eventStartDate"] =
          eventDate + "T" + eventStartTime + ".000+00:00";

      print("Update user request :" + request.fields.toString());
      print("Update user request files:" + request.files.toString());
      var response = await request.send().timeout(
        const Duration(minutes: 10),
        // onTimeout: () {
        //   // Time has run out, do what you wanted to do.
        //   print("Fail"); // Request Timeout response status code
        // },
      );
      print("Update user responce data:" + response.statusCode.toString());
      print("Update user responce stream:" + response.stream.toString());
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);

      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  //For Edit Perrsonal Account Api
  Future CallUserwisePhotosListApi(String userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/userWisePhotoListById?_id=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userWisePhotoListById?_id=$userId"),
        headers: Header,
      );
      print("Pofile detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile detail message====>" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For IniteFriend List
  Future callInviteFriendList(int pageNumber, String searchKey) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "event/inviteFriendsForEventList?searchKey=$searchKey&pageNumber=$pageNumber" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "event/inviteFriendsForEventList?searchKey=$searchKey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Get Invite Friend List Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Search Host

  Future callSearchHostAPi(String searchkey, int pageNumber) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(
        baseurl +
            "event/tagBarUserListForEvent?searchKey=$searchkey&pageNumber=$pageNumber" +
            "\n header\n" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "event/tagHostUserListForEvent?searchKey=$searchkey&pageNumber=$pageNumber",
        ),
        headers: HeaderWithToken,
      );
      print("call Search Api Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);
        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////eventlist get///////
  Future calldayWieseEventApi(
    String eventmonth,
    String eventYear,
    String eventDay,
  ) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print(
        (baseurl +
            "event/eventListDateWise?month=$eventmonth&year=$eventYear&date=$eventDay"),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "event/eventListDateWise?month=$eventmonth&year=$eventYear&date=$eventDay",
        ),
        headers: Header,
      );
      print("Event day wise list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  ///Call Get QR code Api
  Future callCreateQRcodeApi(String userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "user/createQrCode?userId=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/createQrCode?userId=$userId"),
        headers: Header,
      );
      print("Create Qr Code message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  ///Call Get QR code Api

  //////////Get Pending Event List///////
  Future callPendingEventListApi() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/pendingeventList"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "event/pendingeventList"),
        headers: Header,
      );
      print("Get Pending Event list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //////////Get Accepted Event List///////
  Future callAcceptedEventList() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/userJoinedEventList?pageNumber=&pageSize=10"));
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "event/userJoinedEventList?pageNumber=&pageSize=10",
        ),
        headers: Header,
      );
      print("Get Accepted Event list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //////////Get Rejected Event List///////
  Future callRejectedEventList() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/userDeclineEventList"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "event/userDeclineEventList"),
        headers: Header,
      );
      print("Call Rejected Event list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Call join Event Api

  Future callJoinEventApi(Map<String, dynamic> joinEventJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(joinEventJson);
    try {
      print(baseurl + "event/eventJoin" + HeaderWithToken.toString());
      http.Response response = await http.post(
        Uri.parse(baseurl + "event/eventJoin"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("callJoin Event Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Call Decline Event Api

  Future callDeclineEventApi(Map<String, dynamic> declineEventJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(declineEventJson);
    try {
      print(baseurl + "event/eventDeclined" + HeaderWithToken.toString());
      http.Response response = await http.post(
        Uri.parse(baseurl + "event/eventDeclined"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call Decline Event Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////eventListBaarId get///////
  Future callgetEventListByBarId(String barId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/eventListByBarId?barId=$barId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "event/eventListByBarId?barId=$barId"),
        headers: Header,
      );
      print("Event detail By Bar Id list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("Event detail By Bar Id  message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //////////eventdetails get///////
  Future callgetEventDetails(String eventid) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "event/eventDetails?eventId=$eventid"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "event/eventDetails?eventId=$eventid"),
        headers: Header,
      );
      print("Event detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("Event detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Call Delete Event Api
  Future callDeleteEventApi(Map<String, dynamic> declineEventJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(declineEventJson);
    try {
      print(baseurl + "event/EventCancel" + HeaderWithToken.toString());
      http.Response response = await http.post(
        Uri.parse(baseurl + "event/EventCancel"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call Decline Event Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////Participates get///////
  Future callgetParticipates(String eventid, String searchKey) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print(
        (baseurl +
            "event/eventParticipantsList?eventId=$eventid&searchKey=$searchKey"),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl +
              "event/eventParticipantsList?eventId=$eventid&searchKey=$searchKey",
        ),
        headers: Header,
      );
      print("Event Participates list.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("Event Participates Detail message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Call change Api
  Future callChangepassApi(Map<String, dynamic> changepassJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(changepassJson);
    try {
      print(
        baseurl + "user/ChangePasswordForUser" + HeaderWithToken.toString(),
      );
      http.Response response = await http.post(
        Uri.parse(baseurl + "user/ChangePasswordForUser"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call change password Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////Get Notification Api///////
  Future callGetNotificationListResponse() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print((baseurl + "notification/getNotification"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "notification/getNotification"),
        headers: Header,
      );
      print("Get Notification list.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Get Notification message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //////////Get UserId from Username Api///////
  Future callGetUserIdFromUsernameApi(
    String useranme,
    String featureImage,
  ) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print(
        (baseurl +
            "user/getUserIdByUserName?userName=$useranme&featureImage=$featureImage"),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/getUserIdByUserName?userName=$useranme"),
        headers: Header,
      );
      print("Get callGetUserIdFromUsernameApi list.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        // print("Get Notification message" + response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //////////Participates get///////
  Future callGetFeedLikeList(String postId, String searchKey) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print(
        (baseurl + "post/post-LikeListForHomePage?postId=$postId&searchKey="),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "post/post-LikeListForHomePage?postId=$postId&searchKey=",
        ),
        headers: Header,
      );
      print("Feed like List list.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Latest Verison Get

  Future callGetLatestVersion() async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(baseurl + "adminCreate/version-list" + HeaderWithToken.toString());
      http.Response response = await http.get(
        Uri.parse(baseurl + "adminCreate/version-list"),
        headers: HeaderWithToken,
      );
      print("call Get Latest Version List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Feed Details By ID

  Future callGetFeedDetailsByIdApi(String postId) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "post/get-post-by-id?postId=$postId" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "post/get-post-by-id?postId=$postId"),
        headers: HeaderWithToken,
      );
      print("call Get Discovery Post List" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Get Notification Count Api

  Future callGetNotificationCountApi() async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl +
            "notification/unViewdNotificationCount" +
            HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "notification/unViewdNotificationCount"),
        headers: HeaderWithToken,
      );
      print("call Get Notification Count Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For View Notification  Api

  Future callViewNotificationApi() async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    try {
      print(
        baseurl + "notification/viewNotifications" + HeaderWithToken.toString(),
      );
      http.Response response = await http.get(
        Uri.parse(baseurl + "notification/viewNotifications"),
        headers: HeaderWithToken,
      );
      print("call View Notification  Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //call help and faqs api call
  Future callHelpandFaqapi() async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;

    try {
      print((baseurl + "contentMaster/FAQList"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "contentMaster/FAQList"),
        headers: Header,
      );
      print("help and faqs list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("help and faqs response3" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  Future callDeleteAccount() async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    try {
      print(baseurl + "user/userDeleted");
      print(My_Token.toString());
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userDeleted"),
        headers: HeaderWithToken,
      );

      if (response.statusCode == 200) {
        print("Delete Acccount Success" + response.body);
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Block user Api
  Future callBlockUserApi(Map<String, dynamic> changepassJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(changepassJson);
    try {
      print(baseurl + "blockUser/blockUser" + bodyData.toString());
      http.Response response = await http.post(
        Uri.parse(baseurl + "blockUser/blockUser"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call change password Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //For Call Unblock user Api
  Future callUnblockuserApi(Map<String, dynamic> changepassJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String bodyData = json.encode(changepassJson);
    try {
      print(baseurl + "blockUser/unblockUser" + bodyData.toString());
      http.Response response = await http.post(
        Uri.parse(baseurl + "blockUser/unblockUser"),
        body: bodyData,
        headers: HeaderWithToken,
      );
      print("call change password Api" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  //////////call get user block list///////
  Future calluserBlockListApi(String searchKey) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');
    var responseData;
    try {
      print(
        (baseurl + "blockUser/get-blockeduserList-Byid?searchKey=&pageNumber="),
      );
      http.Response response = await http.get(
        Uri.parse(
          baseurl + "blockUser/get-blockeduserList-Byid?searchKey=&pageNumber=",
        ),
        headers: Header,
      );
      print("Block user list.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For Post Report Api
  Future callReportPostApi(Map<String, dynamic> deletePostJson) async {
    var responseData;
    Map<String, String> HeaderWithToken = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    String msg = json.encode(deletePostJson);

    print("Token" + My_Token.toString());

    try {
      print(baseurl + "postReport/postReport-Save");
      http.Response response = await http.post(
        Uri.parse(baseurl + "postReport/postReport-Save"),
        headers: HeaderWithToken,
        body: msg,
      );
      print("Post Report Success" + response.body);
      if (response.statusCode == 200) {
        responseData = JSON.jsonDecode(response.body);

        return responseData;
      }
    } catch (E) {
      print("Error" + E.toString());
    }
  }

  /// For Update Profile picture

  Future callProfilePickUpdateApi(File image) async {
    print("inside");
    try {
      var uri = Uri.parse(baseurl + "user/user-update-Profile");
      print(uri);
      var request = http.MultipartRequest(" ", uri);
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer $My_Token",
      };
      request.headers.addAll(headers);
      print("requests" + request.headers.toString());
      if (image != null) {
        var stream = new http.ByteStream(image.openRead());
        // get file length
        var length = await image.length();
        var multipartFile = new http.MultipartFile(
          "profile_image",
          stream,
          length,
          filename: path.basename(image.path),
        );
        request.files.add(multipartFile);
      }
      // request.fields["userId"] = userID;

      print(" post request" + request.fields.toString());
      var response = await request.send();
      var responsedata = await response.stream.toBytes();
      var result = String.fromCharCodes(responsedata);
      print("add image responce :" + responsedata.toString());
      return result;
    } catch (E) {
      print(" Error api" + E.toString());
    }
  }

  //For My Bar List Api
  Future CallMyBarListApi(String userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/userBarDetailsGetById?_id=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userBarDetailsGetById?_id=$userId"),
        headers: Header,
      );
      print("Pofile detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile detail message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For My Bar Staff List Api

  Future CallMyBarStaffDetailsApi(String barId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${My_Token}');

    var responseData;

    try {
      print((baseurl + "user/staffDetailsGetById?barId=$barId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/staffDetailsGetById?barId=$barId"),
        headers: Header,
      );
      print("Pofile Staff detail list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("profile Staff detail message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  //For My User Rating List Api
  Future CallUserRatingListApi(userId) async {
    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };
    print('Token: ${userId}');

    var responseData;

    try {
      print((baseurl + "user/userWiseRatingList?id=$userId"));
      http.Response response = await http.get(
        Uri.parse(baseurl + "user/userWiseRatingList?id=$userId"),
        headers: Header,
      );
      print("User Rating list message.. :" + response.body);
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        print("User Rating message" + response.body);

        return responseData;
      }
    } catch (E) {
      print("Error.." + E.toString());
    }
  }

  Future CallUserRatingCommanListApi(String? featuresId) async {
    // String? token = await getToken();

    if (My_Token == null || My_Token.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }

    Map<String, String> Header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $My_Token',
    };

    var responseData;
    try {
      String url = baseurl + "user/tagWiseRatingList?featuresId=$featuresId";
      print("Requesting URL: $url");

      http.Response response = await http.get(Uri.parse(url), headers: Header);

      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        return responseData;
      } else {
        print("Error: API returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future CallUserRatingCommanListApi(String? featuresId) async {
  //   // Ensure featuresId is not null or empty
  //   if (featuresId == null || featuresId.isEmpty) {
  //     print("Error: featuresId cannot be null or empty.");
  //     return {'error': 'featuresId is missing'};
  //   }
  //
  //   Map<String, String> Header = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $My_Token',
  //   };
  //   print('Token: ${Header['Authorization']}');
  //   print('FeaturesId: $featuresId');
  //
  //   var responseData;
  //
  //   try {
  //     final url = baseurl + "user/userWiseRatingList?featuresId=$featuresId";
  //     print("Calling API: $url");
  //
  //     http.Response response = await http.get(
  //       Uri.parse(url),
  //       headers: Header,
  //     );
  //
  //     print("API Response: ${response.statusCode} - ${response.body}");
  //     if (response.statusCode == 200) {
  //       responseData = json.decode(response.body);
  //       print("Parsed Response: $responseData");
  //       return responseData;
  //     } else {
  //       // Handle non-200 responses
  //       print("Error: Received ${response.statusCode} from API.");
  //       responseData = json.decode(response.body);
  //       return {'error': 'API Error', 'details': responseData};
  //     }
  //   } catch (e) {
  //     print("Exception occurred: $e");
  //     return {'error': 'Exception occurred', 'details': e.toString()};
  //   }
  // }
}
