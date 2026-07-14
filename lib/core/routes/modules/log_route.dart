

class LogRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: MainDashboardWrapperScreen.path,
      page: () => MainDashboardWrapperScreen(),
      bindings: [AccountBindings(), ProfileBindings(), LoanBindings()],
    ),
    GetPage(name: DashboardScreen.path, page: () => DashboardScreen()),
    GetPage(name: MoreMenuItemsScreen.path, page: () => MoreMenuItemsScreen()),
    GetPage(name: DashboardMoreActionsScreen.path, page: () => DashboardMoreActionsScreen()),
  ];
}
