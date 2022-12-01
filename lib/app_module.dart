import 'package:graphql/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Register here all the third party libraries or global services so they can be provided
/// for the rest of the packages.

const kGatewayEndPoint = 'END_POINT HERE';
const kAccessToken = 'ACCESS_TOKEN_HERE';

@module
abstract class AppModule {
  @lazySingleton
  GraphQLClient get client => GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: HttpLink(
          kGatewayEndPoint,
          defaultHeaders: {'Authorization': 'Bearer $kAccessToken'},
        ).concat(
          AuthLink(
            getToken: () async => 'Bearer $kAccessToken',
          ),
        ),
      );

  @lazySingleton
  InAppPurchase get inAppPurchase => InAppPurchase.instance;

  @lazySingleton
  Logger get logger => Logger(level: Level.verbose);
}
