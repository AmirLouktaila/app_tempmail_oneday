import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';

String generateRandomString() {
  final now = DateTime.now();

  final formatted =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
  final secretKey = 'templkt-$formatted';
  print("hash fate: ${secretKey}");
  final bytes = utf8.encode(secretKey);
  final digest = sha256.convert(bytes);

  return digest.toString();
}

DateTime now = DateTime.now();

String year = now.year.toString();
String month = now.month.toString().padLeft(2, '0');
String day = now.day.toString().padLeft(2, '0');

String formattedDate = '$year-$month-$day';
Future<Map<String, dynamic>> GenerateRandomMail(String id_app) async {
  Dio dio = Dio();
  try {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final url_api = "https://your_domin/generate";
    final response = await dio.post(
      url_api,
      options: Options(
        headers: {
          "secret-key": generateRandomString(),
          "id-app": id_app,
          "datemail": formattedDate,
          "Host": "tempmail.your_domin.com",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      print(data);
      return {
        'email': data['email'] ?? data['data'],
        "datemail": data['datemail'] ?? 'غير متوفر'
      };
    } else {
      return {"error": 'حدث خطأ حاول لاحقا'};
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على البيانات'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}

//// here code  generate custom mail
Future<Map<String, dynamic>> GenerateCustomMail(
    String id_app, String username) async {
  Dio dio = Dio();
  try {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final url_api = "https://your_domin/generate-custom/$username";
    final response_genrandom_mail = await dio.post(url_api,
        options: Options(headers: {
          "secret-key": generateRandomString(),
          "id-app": id_app,
          "datemail": formattedDate,
          "Host": "tempmail.your_domin.com",
        }));

    if (response_genrandom_mail.statusCode == 200) {
      final data = response_genrandom_mail.data;
      print(data);
      return {
        'email': data['email'] ?? data['data'],
        "datemail": data['datemail'] ?? 'غير متوفر'
      };
    } else {
      return {"error": 'حدث خطأ حاول لاحقا'};
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على البيانات'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}

Future<Map<String, dynamic>> RenewMail(String id_app, String username) async {
  Dio dio = Dio();
  try {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (cert, host, port) => true; // allow all certificates
      return client;
    };

    final url_api = "https://your_domin/update-date/$username";
    final response_genrandom_mail = await dio.post(url_api,
        options: Options(headers: {
          "secret-key": generateRandomString(),
          "id-app": id_app,
          "datemail": formattedDate,
          "Host": "tempmail.your_domin.com",
        }));

    if (response_genrandom_mail.statusCode == 200) {
      final data = response_genrandom_mail.data;
      print(data);
      return {'email': data['email'] ?? 'حدث خطأ حاول لاحقا'};
    } else {
      return {"error": 'حدث خطأ حاول لاحقا'};
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على البيانات'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}

Future<Map<String, dynamic>> DeleteMessage(String filename) async {
  Dio dio = Dio();
  try {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final url_api = "https://your_domin/delete-message/$filename";
    final response = await dio.post(
      url_api,
      options: Options(
        headers: {
          "secret-key": generateRandomString(),
          "Host": "tempmail.your_domin.com",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      print("Response delete: $data");
      return {
        'message': data['message'] ?? false, // bool
        'output': data['output'] ?? '', // النص
      };
    } else {
      return {"error": 'حدث خطأ حاول لاحقا'};
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على البيانات'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}


ReplyToMessage(
  String from,
  String to,
  String subject,
  String body,
) async {
  Dio dio = Dio();

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  };

  final url = 'https://your_domin/reply';

  final data = {
    'from': from,
    'to': to,
    'subject': subject,
    'body': body,
  };

  try {
    final response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          "secret-key": generateRandomString(),
          "Host": "tempmail.your_domin.com",
          'Content-Type': 'application/json'
        },
      ),
    );

    print('✅ Response: ${response.data}');
    return response.data;
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على البيانات'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}

/// here code get message mail
Future<Map<String, dynamic>> MessageMail(String email) async {
  Dio dio = Dio();
  try {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final url_api = "https://your_domin/inbox/$email";
    final response = await dio.get(
      // Changed to GET
      url_api,
      options: Options(headers: {
        "secret-key": generateRandomString(),
        "Host": "tempmail.your_domin.com",
      }),
    );

    if (response.statusCode == 200) {
      final data = response.data; // Removed jsonDecode

      final messages = data['messages'] ?? [];
      final firstMessage = messages.isNotEmpty ? messages[0] : {};

      return {
        'email': data['email'] ?? 'حدث خطأ حاول لاحقا',
        'messages': messages,
        'from': firstMessage['from'] ?? 'غير معروف',
        "date": firstMessage['date'] ?? 'غير معروف',
        'subject': firstMessage['subject'] ?? 'غير معروف',
        'shortMsg': firstMessage['shortMsg'] ?? 'غير معروف',
        'filename': firstMessage['filename'] ?? 'غير معروف',
        'body': firstMessage['message'] ??
            firstMessage['body'] ??
            'لا يوجد محتوى', // Check both 'message' and 'body'
      };
    } else {
      return {"error": "حدث خطأ: ${response.statusCode}"};
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return {"error": 'انتهى وقت الاتصال'};
    } else if (e.response?.statusCode == 404) {
      return {"error": 'لم يتم العثور على صندوق الوارد'};
    } else {
      return {"error": 'حدث خطأ غير معروف: ${e.message}'};
    }
  }
}
