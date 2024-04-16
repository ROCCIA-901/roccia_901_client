import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('운영진')
  staff,
  @JsonValue('부원')
  member;

  static final Map<String, UserRole> fromName = {
    "운영진": UserRole.staff,
    "부원": UserRole.member,
  };

  static final Map<UserRole, String> toName = {
    UserRole.staff: "운영진",
    UserRole.member: "부원",
  };
}

/// 순서 바꿀 시에 정기 지점이 먼저 와야 함.
/// 정기 지점 갯수 Constant 수정 필수.
enum Location {
  @JsonValue("더클라임 일산")
  theclimbIlsan,
  @JsonValue("더클라임 마곡")
  theclimbMagok,
  @JsonValue("더클라임 양재")
  theclimbYangjae,
  @JsonValue("더클라임 신림")
  theclimbSillim,
  @JsonValue("더클라임 연남")
  theclimbYeonnam,
  @JsonValue("더클라임 홍대")
  theclimbHongdae,
  @JsonValue("더클라임 서울대")
  theclimbSeoulUniv,
  @JsonValue("더클라임 강남")
  theclimbGangnam,
  @JsonValue("더클라임 사당")
  theclimbSadang,
  @JsonValue("더클라임 신사")
  theclimbSinsa,
  @JsonValue("더클라임 논현")
  theclimbNonhyeon;

  static final Map<String, Location> fromName = {
    "더클라임 일산": Location.theclimbIlsan,
    "더클라임 마곡": Location.theclimbMagok,
    "더클라임 양재": Location.theclimbYangjae,
    "더클라임 신림": Location.theclimbSillim,
    "더클라임 연남": Location.theclimbYeonnam,
    "더클라임 홍대": Location.theclimbHongdae,
    "더클라임 서울대": Location.theclimbSeoulUniv,
    "더클라임 강남": Location.theclimbGangnam,
    "더클라임 사당": Location.theclimbSadang,
    "더클라임 신사": Location.theclimbSinsa,
    "더클라임 논현": Location.theclimbNonhyeon,
  };

  static final Map<Location, String> toName = {
    Location.theclimbIlsan: "더클라임 일산",
    Location.theclimbMagok: "더클라임 마곡",
    Location.theclimbYangjae: "더클라임 양재",
    Location.theclimbSillim: "더클라임 신림",
    Location.theclimbYeonnam: "더클라임 연남",
    Location.theclimbHongdae: "더클라임 홍대",
    Location.theclimbSeoulUniv: "더클라임 서울대",
    Location.theclimbGangnam: "더클라임 강남",
    Location.theclimbSadang: "더클라임 사당",
    Location.theclimbSinsa: "더클라임 신사",
    Location.theclimbNonhyeon: "더클라임 논현",
  };
}

enum Level {
  yellow,
  @JsonValue("노랑색")
  orange,
  @JsonValue("주황색")
  green,
  @JsonValue("초록색")
  blue,
  @JsonValue("파랑색")
  red,
  @JsonValue("빨강색")
  purple,
  @JsonValue("보라색")
  gray,
  @JsonValue("회색")
  brown,
  @JsonValue("갈색")
  black;

  @JsonValue("검정색")
  static final Map<String, Level> fromName = {
    "노랑색": Level.yellow,
    "주황색": Level.orange,
    "초록색": Level.green,
    "파랑색": Level.blue,
    "빨강색": Level.red,
    "보라색": Level.purple,
    "회색": Level.gray,
    "갈색": Level.brown,
    "검정색": Level.black,
  };

  static final Map<Level, String> toName = {
    Level.yellow: "노랑색",
    Level.orange: "주황색",
    Level.green: "초록색",
    Level.blue: "파랑색",
    Level.red: "빨강색",
    Level.purple: "보라색",
    Level.gray: "회색",
    Level.brown: "갈색",
    Level.black: "검정색"
  };
}

/// Navigator.pop에 ApiCall의 결과를 전달할 때 사용
enum ApiCallResult {
  success,
  failure,
}
