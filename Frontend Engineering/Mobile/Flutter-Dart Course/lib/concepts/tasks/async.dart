void main() {
  Future.delayed(
    const Duration(seconds: 3),
    () => print("print 3 seconds complete"),
  );
  print("waiting for a value");
}
