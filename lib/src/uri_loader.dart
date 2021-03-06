// Author: cxx
// Date: 2021-01-30
// GitHub: https://github.com/ccolorcat

import 'dart:io';

/// [total] the file's size
/// [cached] cached file's size
/// [percent] the progress [0, 100]
typedef ProgressListener = void Function(int total, int cached, int percent);

/// Load the file from [uri] and save to [save]
typedef UriLoader = Future<File> Function(
  Uri uri,
  File save, {
  Map<String, Object>? headers,
  ProgressListener? listener,
});

Future<File> loadHttp(
  Uri uri,
  File save, {
  Map<String, Object>? headers,
  ProgressListener? listener,
}) async {
  late HttpClient client;
  IOSink? sink;
  try {
    client = HttpClient();
    final request = await client.getUrl(uri);
    headers?.forEach((key, value) => request.headers.add(key, value));
    final response = await request.close();
    final code = response.statusCode;
    if (code != HttpStatus.ok) {
      throw HttpException(
        'statusCode=$code, message=${response.reasonPhrase}',
        uri: uri,
      );
    }
    sink = save.openWrite();
    final total = response.contentLength;
    var cached = 0, percent = 0, newPercent = 0;
    await for (var bytes in response) {
      sink.add(bytes);
      if (listener == null || total <= 0) continue;
      cached += bytes.length;
      newPercent = cached * 100 ~/ total;
      if (newPercent > percent) {
        percent = newPercent;
        listener(total, cached, percent);
      }
    }
    await sink.flush();
    return save;
  } finally {
    await sink?.close();
    client.close();
  }
}

Future<File> loadFile(
  Uri uri,
  File save, {
  Map<String, Object>? headers,
  ProgressListener? listener,
}) async {
  File src = File(uri.toFilePath());
  if (!src.existsSync()) {
    throw FileSystemException('$uri not exists', uri.toFilePath());
  }
  return src.copy(save.path);
}
