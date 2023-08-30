import 'package:http/http.dart';

import '../utilities/coin_data.dart';

class NetworkHelper {
  static String kAPIKey = 'FC07898C-3ED6-4E49-A4CD-7232B933874F';

  static Future<Response> getCurrencyData(String coin, String currency) async {
    final Uri httpsUri = Uri(
      scheme: 'https',
      host: 'rest.coinapi.io',
      path: '/v1/exchangerate/$coin/$currency',
      queryParameters: <String, String>{'apikey': kAPIKey},
    );

    return await get(httpsUri);
  }

  static CoinData responseToCoinData(Response response) {
    print(response.statusCode);
    if (response.statusCode == 200) {
      return CoinData.response(response);
    } else {
      return CoinData();
    }
  }

  static void buildHTTPSRequest(String coin, String currency) {
    final Uri httpsUri = Uri(
      scheme: 'https',
      host: 'rest.coinapi.io',
      path: '/v1/exchangerate/$coin/$currency',
      queryParameters: <String, String>{'apikey': kAPIKey},
    );

    print(httpsUri.toString());
  }
}
