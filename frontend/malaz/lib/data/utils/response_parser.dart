// lib/data/utils/response_parser.dart
import 'dart:convert';

bool extractSuccess(dynamic data, {int? statusCode}) {
  try {
    if (statusCode != null) {
      if (statusCode >= 400) return false;
    }

    if (data == null) return false;

    dynamic parsed = data;
    if (data is String) {
      try {
        parsed = jsonDecode(data);
      } catch (_) { parsed = data; }
    }

    dynamic rawSuccess;
    if (parsed is Map) {
      rawSuccess = parsed['success'] ??
          parsed['status'] ??
          parsed['ok'] ??
          parsed['result'] ??
          (parsed['data'] is Map ? parsed['data']['success'] ?? parsed['data']['status'] : null);
    } else {
      rawSuccess = parsed;
    }

    if (rawSuccess is bool) return rawSuccess;
    if (rawSuccess is int) return rawSuccess == 1;
    if (rawSuccess is String) {
      final s = rawSuccess.toLowerCase().trim();
      return (s == 'true' || s == '1' || s == 'success' || s == 'ok' || s == 'verified');
    }

    final msg = extractMessage(parsed);
    if (msg != null) {
      final low = msg.toLowerCase();
      if (low.contains('success') || low.contains('verified') || low.contains('created')) return true;
      if (low.contains('error') || low.contains('invalid') || low.contains('failed')) return false;
    }

    if (statusCode != null && statusCode >= 200 && statusCode < 300) return true;
    return false;
  } catch (e) {
    return false;
  }
}

String? extractMessage(dynamic data) {
  try {
    if (data == null) return null;
    dynamic parsed = data;
    if (data is String) {
      try { parsed = jsonDecode(data); } catch (_) { parsed = data; }
    }
    if (parsed is Map) {
      final m = parsed['message'] ?? parsed['msg'] ?? parsed['error'] ?? parsed['errors'];
      if (m == null) return null;
      if (m is String) return m;
      try { return jsonEncode(m); } catch (_) { return m.toString(); }
    }
    if (parsed is String) return parsed;
    return parsed.toString();
  } catch (e) {
    return null;
  }
}
