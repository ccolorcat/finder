// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

import 'dart:async';
import 'dart:io';

/// returns [File] must not be null, the file will be used for saving.
typedef PathResolver = FutureOr<File> Function(Uri uri, Directory root);

FutureOr<File> defaultResolve(Uri uri, Directory root) {
  final segments = uri.pathSegments;
  final path = segments.isEmpty ? _defaultGenerate(uri) : segments.last;
  return File('${root.path}/$path');
}

int _defaultGenerate(Uri uri) => uri.hashCode;
