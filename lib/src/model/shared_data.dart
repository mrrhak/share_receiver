part of '../../share_receiver.dart';

class SharedData {
  const SharedData({
    this.text,
    this.filePaths = const [],
    this.mimeType,
    this.thumbnail,
  });

  /// Shared text content (URLs, messages, etc.)
  final String? text;

  /// List of file paths for shared files (images, videos, documents)
  final List<String> filePaths;

  /// MIME type of the shared content
  final String? mimeType;

  /// Thumbnail path (if available)
  final String? thumbnail;

  factory SharedData.fromMap(Map<String, dynamic> map) {
    return SharedData(
      text: map['text'] as String?,
      filePaths: _parseFilePaths(map['filePaths']),
      mimeType: map['mimeType'] as String?,
      thumbnail: map['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'filePaths': filePaths,
      'mimeType': mimeType,
      'thumbnail': thumbnail,
    };
  }

  static List<String> _parseFilePaths(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    if (value is String && value.isNotEmpty) {
      return [value];
    }
    return [];
  }

  /// Returns true if this SharedData contains any content
  bool get hasContent => text != null || filePaths.isNotEmpty;

  /// Returns true if this is a text share
  bool get isText => text != null && filePaths.isEmpty;

  /// Returns true if this is a file share (image, video, document)
  bool get isMedia => filePaths.isNotEmpty;

  /// Returns true if shared content is an image
  bool get isImage => mimeType?.startsWith('image/') ?? false;

  /// Returns true if shared content is a video
  bool get isVideo => mimeType?.startsWith('video/') ?? false;

  /// Returns true if shared content is a URL
  bool get isUrl {
    if (text == null) return false;
    final t = text!.toLowerCase();
    return t.startsWith('http://') || t.startsWith('https://');
  }

  @override
  String toString() {
    return 'SharedData(text: $text, filePaths: $filePaths, mimeType: $mimeType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SharedData &&
        other.text == text &&
        _listEquals(other.filePaths, filePaths) &&
        other.mimeType == mimeType;
  }

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => text.hashCode ^ filePaths.hashCode ^ mimeType.hashCode;
}
