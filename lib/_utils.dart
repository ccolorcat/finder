// Author: cxx
// Date: 2021-03-05
// GitHub: https://github.com/ccolorcat

part of finder;

Future<Directory> _resolveCacheDirectory() async {
  final dir = Platform.isAndroid ? getExternalStorageDirectory() : getApplicationSupportDirectory();
  final path = await dir.then((value) => Directory('${value.path}/finder'));
  _log(() => 'find directory path: $path');
  return path;
}

void _safeDelete(File file) {
  try {
    if (file.existsSync()) {
      file.deleteSync();
    }
  } catch (ignore) {}
}

T _requireNonNull<T>(T value, [String name]) {
  if (value == null) {
    throw ArgumentError.notNull(name);
  }
  return value;
}

Future<File> _safeRename(File from, File to) async {
  try {
    return from.renameSync(to.path);
  } catch (e) {
    if (to.existsSync()) {
      return to;
    }
    rethrow;
  }
}

void _log(String Function() log) {
  if (Finder.loggable) {
    print(log.call());
  }
}

extension _MapFunc<K, V> on Map<K, V> {
  V getOrPut(K key, V produce()) {
    var value;
    if (containsKey(key)) {
      value = this[key];
    } else if (produce != null) {
      value = produce();
      this[key] = value;
    }
    return value;
  }
}
