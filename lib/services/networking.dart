import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Map<String, String> requestHeaders = {
    "X-NCP-APIGW-API-KEY-ID": "rdhthwvpa1",
    "X-NCP-APIGW-API-KEY": "BNK3Q8Adf1M2hNevwxkir9D9P1SlV5eJkJDIHZ9D",
  };

  Future getData() async {
    http.Response response =
        await http.get(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode == 200) {
      String data = response.body;

      var result = jsonDecode(data);
      var region = result["results"][0]["region"];
      String area1 = region["area1"]["name"];
      String area2 = region["area2"]["name"];
      String area3 = region["area3"]["name"];
      String area4 = region["area4"]["name"];
      String locationName = "${area1} ${area2} ${area3} ${area4}";
      return locationName;
    } else {
      print(response.statusCode);
    }
  }
}
