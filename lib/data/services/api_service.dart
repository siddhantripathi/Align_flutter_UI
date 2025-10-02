import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/config/environment.dart';
import '../models/learning_module.dart';
import '../models/checkin_data.dart';
import 'auth_service.dart';

// API Service
// Centralized service for all backend API communications

class ApiService {
  static const String _baseUrl = Environment.baseUrl;
  static const String _apiKeyHeader = AppConstants.apiKeyHeader;
  
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Get API key from environment
  String get _apiKey => Environment.alignApiKey;
  
  ApiService();
  
  Future<Map<String, String>> get _headers async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    // Add API key for backend authentication
    headers[_apiKeyHeader] = _apiKey;
    
    // Add Firebase ID token for user authentication
    final idToken = await _authService.getIdToken();
    if (idToken != null) {
      headers['Authorization'] = 'Bearer $idToken';
    }
    
    return headers;
  }

  // Generic API call method
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final uriWithQuery = queryParams != null 
        ? uri.replace(queryParameters: queryParams)
        : uri;

    final headers = await _headers;
    http.Response response;
    
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uriWithQuery, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uriWithQuery,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uriWithQuery,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uriWithQuery, headers: headers);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
      
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Check service status
  Future<bool> checkServiceStatus() async {
    try {
      final response = await _makeRequest('GET', '/');
      return response.statusCode == 200;
    } catch (e) {
      print('Backend connection error: $e');
      return false;
    }
  }

  // Test backend connection (for debugging)
  Future<Map<String, dynamic>> testBackendConnection() async {
    try {
      final response = await _makeRequest('GET', '/');
      return {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Backend is reachable',
        'backend': 'https://dev.lifestages.us',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to connect to backend',
        'backend': 'https://dev.lifestages.us',
      };
    }
  }

  // Send push notification
  Future<Map<String, dynamic>> sendNotification({
    required String token,
    required String title,
    required String message,
    int badge = 1,
  }) async {
    final response = await _makeRequest('POST', '/sendNotification/', body: {
      'token': token,
      'alert': title,
      'message': message,
      'badge': badge,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send notification: ${response.body}');
    }
  }

  // Create learning module
  Future<LearningModule> createLearningModule({
    required String userId,
    required double currentActivity,
    required double currentEmotionalHealth,
    required double currentStress,
    required List<String> outdoorActivities,
    required List<String> topThreeWellness,
    required List<String> wellnessInterests,
    required String topic,
    required String moodCheckSelection,
  }) async {
    final response = await _makeRequest('POST', '/createLearningModule', body: {
      'userID': userId,
      'currentActivity': currentActivity,
      'currentEmotionalHealth': currentEmotionalHealth,
      'currentStress': currentStress,
      'outdoorActivites': outdoorActivities, // Note: typo in backend API
      'topThreeWellness': topThreeWellness,
      'wellnessInterests': wellnessInterests,
      'topic': topic,
      'moodCheckSelection': moodCheckSelection,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return LearningModule.fromJson(data['learningModule']);
      } else {
        throw Exception('Failed to create learning module: ${data['error']}');
      }
    } else {
      throw Exception('Failed to create learning module: ${response.body}');
    }
  }

  // Send support email
  Future<String> sendSupportEmail({
    required String userEmail,
    required String userId,
    required String userName,
    required String message,
  }) async {
    final response = await _makeRequest('POST', '/sendSupportEmail', body: {
      'user_email': userEmail,
      'user_id': userId,
      'user_name': userName,
      'message': message,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] ?? 'Email sent successfully';
    } else {
      throw Exception('Failed to send support email: ${response.body}');
    }
  }

  // Get user data
  Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await _makeRequest('GET', '/user/$userId');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  // Generate AI image
  Future<String> generateImage(String prompt) async {
    final response = await _makeRequest('POST', '/generate-replicate-image', body: {
      'prompt': prompt,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['imageURL'];
      } else {
        throw Exception('Failed to generate image: ${data['error']}');
      }
    } else {
      throw Exception('Failed to generate image: ${response.body}');
    }
  }

  // Save check-in data (placeholder - would need backend endpoint)
  Future<bool> saveCheckinData(CheckinData checkinData) async {
    // This would be implemented when the backend has a check-in endpoint
    // For now, return true as placeholder
    return true;
  }
}
