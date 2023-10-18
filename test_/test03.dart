main() {
  int repeat = 15;
  for (int n = 0; n < repeat; n++) {
    BigInt a = pow((n + 1), (n + 1));
    BigInt b = pow((n + 2), (n + 2));
    BigInt c = pow((n + 3), (n + 3));
    print('$a+$b+$c=${a + b + c}');
  }
  print('');
  for (int n = 0; n < repeat; n++) {
    print('2023^$n= ${pow(2023, n)}');
  }
}

BigInt pow(int x, int exponent) {
  // BigInt result = 1;
  var bigValue = BigInt.from(x).pow(exponent);
  return bigValue;
}
