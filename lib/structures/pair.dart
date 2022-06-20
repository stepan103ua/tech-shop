class Pair {
  dynamic first;
  dynamic second;

  Pair(this.first, this.second);
  @override
  String toString() {
    return '[ $first, $second ]';
  }
}
