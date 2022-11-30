// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fita_in_app_purchase/app_module.dart' as _i8;
import 'package:fita_in_app_purchase/in_app_purchase_service/in_app_purchase_service.dart'
    as _i5;
import 'package:fita_in_app_purchase/in_app_purchase_service/in_app_purchase_service_impl.dart'
    as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:graphql/client.dart' as _i3;
import 'package:in_app_purchase/in_app_purchase.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i7;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i3.GraphQLClient>(() => appModule.client);
    gh.lazySingleton<_i4.InAppPurchase>(() => appModule.inAppPurchase);
    gh.lazySingleton<_i5.InAppPurchaseService>(
        () => _i6.InAppPurchaseServiceImpl(
              gh<_i4.InAppPurchase>(),
              gh<_i3.GraphQLClient>(),
            ));
    gh.lazySingleton<_i7.Logger>(() => appModule.logger);
    return this;
  }
}

class _$AppModule extends _i8.AppModule {}
