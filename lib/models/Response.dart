class Response<DATA> {

  final bool success;
  final String message;
  final DATA? data;

  Response({required this.success, required this.message, this.data});

  factory Response.fromJson(Map<String, dynamic> json, String dataKey, Function(dynamic) dataEncoder) {

    var data;

    if (json['success'] == true) {
      data = dataEncoder(json[dataKey]);
    }

    return Response(
        success: json['success'], message: (json.containsKey('message')) ? json['message'] : '', data: data);
  }

}