import 'package:graphql/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Register here all the third party libraries or global services so they can be provided
/// for the rest of the packages.

const kGatewayEndPoint = 'https://api.dev.munalively.com/graphql';
const kAccessToken =
    'eyJ0eXAiOiJKV1QiLCJraWQiOiJ3VTNpZklJYUxPVUFSZVJCL0ZHNmVNMVAxUU09IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1M2I4ZDAyMi00YjY1LTRjNTItYmQxNi0yZjg0NTViY2ZlZjAiLCJjdHMiOiJPQVVUSDJfR1JBTlRfU0VUIiwiYXV0aF9sZXZlbCI6MCwiYXVkaXRUcmFja2luZ0lkIjoiNDU5ZTBjOGQtMWU2Yy00NWViLWI2MjUtMTk1MGIxYTE5YWMzLTI1Mjc3MTUiLCJpc3MiOiJodHRwczovL2NpYW1hbXByZXBkYXBwLmNpYW0udGVsa29tc2VsLmNvbToxMDAwMy9vcGVuYW0vb2F1dGgyL3RzZWwvZml0YS9tb2JpbGUiLCJ0b2tlbk5hbWUiOiJhY2Nlc3NfdG9rZW4iLCJ0b2tlbl90eXBlIjoiQmVhcmVyIiwiYXV0aEdyYW50SWQiOiJ3RFNaUFZPWDRFSmljWFZZMThaWnVrODFFT0EudkFWdHJjRE1oRWRpcUUzemhHRkVuY3BncDU4Iiwibm9uY2UiOiJ0cnVlIiwiYXVkIjoiMWZkZGJjYmZmMzZhNGVjMDhiNTVkZGI3YjIyN2Q2MGMiLCJuYmYiOjE2Njk3ODEyNTMsImdyYW50X3R5cGUiOiJhdXRob3JpemF0aW9uX2NvZGUiLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImF1dGhfdGltZSI6MTY2OTc4MTI1MywicmVhbG0iOiIvdHNlbC9maXRhL21vYmlsZSIsImV4cCI6MTY2OTg2NzY1MywiaWF0IjoxNjY5NzgxMjUzLCJleHBpcmVzX2luIjo4NjQwMCwianRpIjoid0RTWlBWT1g0RUppY1hWWTE4Wlp1azgxRU9BLjVwY2wxcWpIOUNfd0RUdV9wNndFU0I0WGhScyJ9.0w3tLDMqdIWURZXdTgirRTXJkESYWXpg2-G-hR61cOVBH5tKzJkmBM70zrv7wfUdoZLAYmRIDzxP-ucz61VICvF6sw_MFxqgnw6aQmM5mb1kO5daXG7g1hGBzeQv5UR0EfotIw2hc6S0k5Fgsy53ixLvviKFPCEneTwHoGJyjxErs6gcbHTcopQaxVQbSn7Y7P4LK3nH0HwsOjU3G_d_pwV6zb4fJSiwO0-Tgq2ZV8W4sEEQNdCc2xcMh0mqj85kidnceVRkXVpQHU_Y-arh2pmVUBIbYBjHnc3jfm6JLBuYYHK5bKL_OZDFO8kMmZWB3vSf2c2-6QpYsmUOsK5Vkg';

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
