import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouteEx on BuildContext {
  GoRouter get route => GoRouter.of(this);
  GoRouterState get routeState => GoRouterState.of(this);

  Map<String, String> get pathParams => routeState.pathParameters;
  String? param(String key) => pathParams[key];
  Map<String, String> get queryParams => routeState.uri.queryParameters;
  String? query(String key) => queryParams[key];

  void nPop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension ContextEx on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);

  double get height => mq.size.height;
  double get width => mq.size.width;

  double get safeHeight => height - (mq.padding.top + mq.padding.bottom);
  double get safeWidth => width - (mq.padding.left + mq.padding.right);

  // Orientation helpers
  bool get isLandscape => mq.orientation == Orientation.landscape;
  bool get isPortrait => mq.orientation == Orientation.portrait;

  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;

  Brightness get bright => theme.brightness;

  // Text scaling helpers (use TextScaler to avoid deprecation warnings)
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);
  TextScaler get textScaler => MediaQuery.textScalerOf(this);

  // Legacy helpers
  bool get onMobile => width < AppLayout.maxMobile;
  bool get onTab => width > AppLayout.maxMobile;

  // New granular breakpoints
  bool get isSmallPhone => width < AppLayout.smallPhoneMax;
  bool get isMediumPhone =>
      width >= AppLayout.smallPhoneMax && width < AppLayout.maxMobile;
  bool get isTablet => width >= AppLayout.maxMobile && width < AppLayout.maxTab;
  bool get isXLarge => width >= AppLayout.maxTab;

  // Responsive value helper by width breakpoint
  T vByWidth<T>({required T sp, required T mp, required T tab, required T xl}) {
    if (isSmallPhone) return sp;
    if (isMediumPhone) return mp;
    if (isTablet) return tab;
    return xl;
  }

  // Common helpers for grids and paddings
  int columns({int sp = 2, int mp = 3, int tab = 4, int xl = 5}) =>
      vByWidth<int>(sp: sp, mp: mp, tab: tab, xl: xl);

  double padValue(
          {double sp = Insets.med,
          double mp = Insets.med + 2,
          double tab = Insets.lg,
          double xl = Insets.xl}) =>
      vByWidth<double>(sp: sp, mp: mp, tab: tab, xl: xl);

  EdgeInsets padAll(
          {double sp = Insets.med,
          double mp = Insets.med + 2,
          double tab = Insets.lg,
          double xl = Insets.xl}) =>
      EdgeInsets.all(padValue(sp: sp, mp: mp, tab: tab, xl: xl));

  EdgeInsets padH(
          {double sp = Insets.med,
          double mp = Insets.med + 2,
          double tab = Insets.lg,
          double xl = Insets.xl}) =>
      EdgeInsets.symmetric(
          horizontal: padValue(sp: sp, mp: mp, tab: tab, xl: xl));

  bool get isDark => bright == Brightness.dark;
  bool get isLight => bright == Brightness.light;
  TR get tr => TR.of(this);
}
