import 'package:get/get.dart';

import '../middlewares/auth_middleware.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/phone_login_view.dart';
import '../modules/distributeurpage/bindings/distributeurpage_binding.dart';
import '../modules/distributeurpage/views/distributeurpage_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/transaction/bindings/transaction_binding.dart';
import '../modules/transaction/views/transaction_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [
        RouteGuard(),
      ],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION,
      page: () => const TransactionView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const PhoneLoginView(),
    ),
    GetPage(
      name: _Paths.DISTRIBUTEURPAGE,
      page: () => const DistributeurpageView(),
      binding: DistributeurpageBinding(),
    ),
  ];
}
