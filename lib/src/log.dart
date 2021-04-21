// Author: cxx
// Date: 2021-03-05
// GitHub: https://github.com/ccolorcat

import '../finder.dart';

void log(String Function() log) {
  if (Finder.loggable) {
    print(log.call());
  }
}
