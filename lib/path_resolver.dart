// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

part of finder;

/// returns [File] must not be null, the file will be used for saving.
typedef PathResolver = Future<File> Function(Uri uri, Directory root);

Future<File> _defaultResolve(Uri uri, Directory root) async {
  final segments = uri.pathSegments;
  final path = segments.isEmpty ? _defaultGenerate(uri) : segments.last;
  return File('${root.path}/$path');
}

int _defaultGenerate(Uri uri) => uri.hashCode;
