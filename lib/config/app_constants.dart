/// Enums
enum UserRole {
  staff,
  member;

  static final Map<String, UserRole> fromName = {
    "운영진": UserRole.staff,
    "일반 회원": UserRole.member,
  };

  static final Map<UserRole, String> toName = {
    UserRole.staff: "운영진",
    UserRole.member: "일반 회원",
  };
}

enum Location {
  theclimbHongdae,
  theclimbIlsan,
  theclimbMagok,
  theclimbSeoulUniv,
  theclimbYangjae,
  theclimbSillim,
  theclimbYeonnam,
  theclimbGangnam,
  theclimbSadang,
  theclimbSinsa,
  theclimbNonhyeon;

  static final Map<String, Location> fromName = {
    "더클라임 홍대": Location.theclimbHongdae,
    "더클라임 일산": Location.theclimbIlsan,
    "더클라임 마곡": Location.theclimbMagok,
    "더클라임 서울대": Location.theclimbSeoulUniv,
    "더클라임 양재": Location.theclimbYangjae,
    "더클라임 신림": Location.theclimbSillim,
    "더클라임 연남": Location.theclimbYeonnam,
    "더클라임 강남": Location.theclimbGangnam,
    "더클라임 사당": Location.theclimbSadang,
    "더클라임 신사": Location.theclimbSinsa,
    "더클라임 논현": Location.theclimbNonhyeon,
  };

  static final Map<Location, String> toName = {
    Location.theclimbHongdae: "더클라임 홍대",
    Location.theclimbIlsan: "더클라임 일산",
    Location.theclimbMagok: "더클라임 마곡",
    Location.theclimbSeoulUniv: "더클라임 서울대",
    Location.theclimbYangjae: "더클라임 양재",
    Location.theclimbSillim: "더클라임 신림",
    Location.theclimbYeonnam: "더클라임 연남",
    Location.theclimbGangnam: "더클라임 강남",
    Location.theclimbSadang: "더클라임 사당",
    Location.theclimbSinsa: "더클라임 신사",
    Location.theclimbNonhyeon: "더클라임 논현",
  };
}

enum Level {
  yellow,
  orange,
  green,
  blue,
  red,
  purple,
  gray,
  brown,
  black;

  static final Map<String, Level> fromName = {
    "노랑": Level.yellow,
    "주황": Level.orange,
    "초록": Level.green,
    "파랑": Level.blue,
    "빨강": Level.red,
    "보라": Level.purple,
    "회색": Level.gray,
    "갈색": Level.brown,
    "검정": Level.black,
  };

  static final Map<Level, String> toName = {
    Level.yellow: "노랑",
    Level.orange: "주황",
    Level.green: "초록",
    Level.blue: "파랑",
    Level.red: "빨강",
    Level.purple: "보라",
    Level.gray: "회색",
    Level.brown: "갈색",
    Level.black: "검정"
  };
}

/// Constants
class AppConstants {
  /// 최신 기수 값
  static const int maxGeneration = 11;

  /// 인증 번호 타임 아웃 시간(sec)
  static const int authenticationTimeOut = 60;
}
