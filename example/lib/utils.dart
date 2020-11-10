extension IterableExtensions<T> on Iterable<T> {
  void forEachIndexed(void Function(int index, T element) action) {
    int i = 0;
    for (final e in this) {
      action(i, e);
      i += 1;
    }
  }

  Iterable<U> mapIndexed<U>(U Function(int index, T element) transform) sync* {
    int i = 0;
    final it = iterator;
    while (it.moveNext()) {
      yield transform(i, it.current);
      i += 1;
    }
  }
}
