// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

import 'dart:collection';

typedef SizeOf<K, V> = int Function(K, V);

int _defaultSizeOf(dynamic key, dynamic value) => 1;

class LruCache<K, V> {
  LinkedHashMap<K, V> _cache;
  int _maxSize;
  SizeOf<K, V> _sizeOf;
  int _size = 0;

  int get size => _size;

  int get maxSize => _maxSize;

  int get length => _cache.length;

  LruCache(int maxSize, {SizeOf<K, V> sizeOf = _defaultSizeOf}) {
    if (maxSize <= 0) {
      throw ArgumentError.value(maxSize, 'maxSize', 'maxSize must be positive');
    }
    _sizeOf = _requireNonNull(sizeOf, 'sizeOf');
    _maxSize = maxSize;
    _cache = LinkedHashMap();
  }

  void resize(int maxSize) {
    if (maxSize <= 0) {
      throw ArgumentError.value(
          maxSize, 'maxSize', 'maxSize must be non-negative');
    }
    _maxSize = maxSize;
    _trimToSize(_maxSize);
  }

  V operator [](K key) => _get(key);

  void operator []=(K key, V value) => _put(key, value);

  V remove(K key) => _remove(key);

  V getOrPut(K key, V produce()) {
    var value = _get(key);
    if (value == null && (value = produce?.call()) != null) {
      _put(key, value);
    }
    return value;
  }

  void evictAll() {
    _trimToSize(-1);
    return;
  }

  Map<K, V> snapshot() {
    return Map.unmodifiable(_cache);
  }

  V _get(K key) {
    _requireNonNull(key, 'key');
    final value = _cache.remove(key);
    if (value != null) {
      _cache[key] = value;
    }
    return value;
  }

  V _put(K key, V value) {
    _requireNonNull(key, 'key');
    _requireNonNull(value, 'value');
    var previous = _remove(key);
    _cache[key] = value;
    _size += _safeSizeOf(key, value);
    _trimToSize(_maxSize);
    return previous ?? value;
  }

  V _remove(K key) {
    var previous = _cache.remove(_requireNonNull(key, 'key'));
    if (previous != null) {
      _size -= _safeSizeOf(key, previous);
    }
    return previous;
  }

  void _trimToSize(int maxSize) {
    while (true) {
      _checkSize();
      if (_size <= maxSize || _cache.isEmpty) break;
      final toEvict = _cache.entries.first;
      final key = toEvict.key;
      final value = toEvict.value;
      _cache.remove(key);
      _size -= _safeSizeOf(key, value);
    }
    return;
  }

  int _safeSizeOf(K key, V value) {
    final result = _sizeOf(key, value);
    if (result < 0) {
      throw StateError('sizeOf($key, $value) returns a negative value');
    }
    return result;
  }

  void _checkSize() {
    if (_size < 0) {
      throw StateError('size is negative');
    }
    if (_cache.isEmpty && _size != 0) {
      throw StateError('cache is empty, but size not equal to 0');
    }
  }

  @override
  String toString() {
    return 'LruCache{cache: $_cache, maxSize: $_maxSize, size: $_size}';
  }
}

T _requireNonNull<T>(T value, [String name]) {
  return ArgumentError.checkNotNull(value, name);
}
