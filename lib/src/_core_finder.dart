// Author: cxx
// Date: 2021-03-05
// GitHub: https://github.com/ccolorcat

part of finder;

class _CoreFinder extends Finder {
  final Future<Directory> _rootPath = _resolveCacheDirectory();

  final _loaders = <String, UriLoader>{
    'http': loadHttp,
    'https': loadHttp,
    'file': loadFile,
    kScheme: loadAsset,
  };

  final _resolvers = <String, PathResolver>{
    kScheme: resolveAsset,
  };

  final _cached = LruCache<Uri, Uint8List>(
    50 * 1024 * 1024,
    sizeOf: (_, v) => v.lengthInBytes,
  );

  final _running = <Uri, LoaderTask>{};

  _CoreFinder() : super._internal();

  @override
  void registerUriLoader(String scheme, UriLoader loader) {
    _loaders[scheme.toLowerCase()] =
        ArgumentError.checkNotNull(loader, 'loader');
  }

  @override
  void unregisterUriLoader(String scheme) {
    _loaders.remove(scheme?.toLowerCase());
  }

  @override
  void registerPathResolver(String scheme, PathResolver resolver) {
    _resolvers[scheme.toLowerCase()] =
        ArgumentError.checkNotNull(resolver, 'resolver');
  }

  @override
  void unregisterPathResolver(String scheme) {
    _resolvers.remove(scheme?.toLowerCase());
  }

  @override
  Future<Uint8List> getData(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  }) async {
    var value = onlyMemory(uri);
    if (value != null) {
      log(() => 'hit memory by $uri');
      return value;
    }

    final file = await getFile(uri, headers: headers, listener: listener);
    if (file?.existsSync() == true) {
      value = file.readAsBytesSync();
      _cacheToMemory(uri, value);
    }
    return value;
  }

  @override
  Future<File> getFile(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  }) async {
    final file = await _resolvePath(uri);
    if (file.existsSync()) {
      log(() => 'hit cached by $uri');
      return file;
    }
    return _load(uri, file, headers: headers, listener: listener);
  }

  @override
  Future<File> onlyRemote(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  }) async {
    final save = await _resolvePath(uri);
    return _load(
      uri,
      save,
      headers: headers,
      listener: listener,
    );
  }

  @override
  Future<File> onlyStorage(Uri uri) async {
    final file = await _resolvePath(uri);
    if (file.existsSync()) {
      log(() => 'hit cached by $uri');
      return file;
    }
    return null;
  }

  @override
  Uint8List onlyMemory(Uri uri) {
    return _cached[uri];
  }

  void _cacheToMemory(Uri uri, Uint8List data) {
    _cached[uri] = data;
  }

  Future<File> _load(
    Uri uri,
    File save, {
    Map<String, Object> headers,
    ProgressListener listener,
  }) async {
    final task = _computeTask(uri, save, headers: headers, listener: listener);
    return task.result.whenComplete(() => _removeTask(uri, task));
  }

  LoaderTask _computeTask(
    Uri uri,
    File save, {
    Map<String, Object> headers,
    ProgressListener listener,
  }) {
    return _running.getOrPut(uri, () {
      final loader = _resolveLoader(uri);
      return LoaderTask(loader, uri, save, headers, listener);
    });
  }

  void _removeTask(Uri uri, LoaderTask task) {
    _running.removeWhere((key, value) => key == uri && value == task);
  }

  Future<File> _resolvePath(Uri uri) async {
    final root = await _rootPath;
    final resolver = _resolvers[uri.scheme] ?? defaultResolver;
    if (resolver == null) {
      throw UnsupportedError('no PathResolver support scheme: ${uri.scheme}');
    }
    return resolver(uri, root);
  }

  UriLoader _resolveLoader(Uri uri) {
    final loader = _loaders[uri.scheme] ?? defaultLoader;
    if (loader == null) {
      throw UnsupportedError('no UriLoader support scheme: ${uri.scheme}');
    }
    return loader;
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

Future<Directory> _resolveCacheDirectory() async {
  final dir = Platform.isAndroid
      ? getExternalStorageDirectory()
      : getApplicationSupportDirectory();
  final path = await dir.then((value) => Directory('${value.path}/finder'));
  log(() => 'find directory path: $path');
  return path;
}
