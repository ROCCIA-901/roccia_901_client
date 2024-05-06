class AppConstants {
  /// Api request timeout
  static const int apiRequestTimeout = 10;

  /// 최신 기수 값
  static const int maxGeneration = 11;

  /// 정기 운동 지점 개수
  static const int workoutLocationCount = 5;

  /// 인증 번호 타임 아웃 시간(sec)
  static const int authenticationTimeOut = 600;

  /// 배너 하이퍼링크 (asset, URL) 리스트
  static const List<({String asset, String url})> banners = [
    (
      asset: 'assets/banners/howto.svg',
      url:
          'https://crystal-bowler-ff6.notion.site/71819cd3705b44eeb5b521ecfe1b7081?pvs=4',
    ),
    (
      asset: 'assets/banners/notice.svg',
      url:
          'https://crystal-bowler-ff6.notion.site/ba37dd63ec12486a98c34a14a7eb0cc2?pvs=4',
    ),
    (
      asset: 'assets/banners/rules.svg',
      url:
          'https://crystal-bowler-ff6.notion.site/Roccia-901-caedf2c1c911416c8162f7aaa25b59ae?pvs=4',
    ),
    (
      asset: 'assets/banners/report.png',
      url:
          'https://docs.google.com/forms/d/1Fg3Nk0H3nAoAYAq5elkzUyn69latA9Nv6tJGgD-aENU/edit',
    ),
  ];

  static const String reportUrl =
      "https://docs.google.com/forms/d/1Fg3Nk0H3nAoAYAq5elkzUyn69latA9Nv6tJGgD-aENU/edit";

  static const String version = "1.0.0";
}
