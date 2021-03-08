// Author: cxx
// Date: 2021-02-04
// GitHub: https://github.com/ccolorcat
part of finder;

class _LoaderTask {
  final UriLoader _loader;
  final Uri _uri;
  final File _save;
  final Map<String, Object> _headers;
  final ProgressListener _listener;

  _LoaderTask(
    this._loader,
    this._uri,
    this._save,
    this._headers,
    this._listener,
  );

  Future<File> _result;

  Future<File> get result {
    return _result ??= _execute();
  }

  Future<File> _execute() async {
    var file, temp = File('${_save.path}.temp');
    try {
      _save.parent.createSync(recursive: true);
      file = await _loader(
        _uri,
        temp,
        headers: _headers,
        listener: _listener,
      );
      _log(() => '<- $_uri download success');
      return _safeRename(file, _save);
    } catch (e) {
      _log(() => '<- $_uri download failure: $e');
      _safeDelete(file ?? temp);
      rethrow;
    }
  }
}
