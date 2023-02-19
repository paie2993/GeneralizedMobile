class Response<T> {
  const Response({
    required this.status,
    this.value,
    this.error,
  });

  final bool status;
  final T? value;
  final String? error;
}
