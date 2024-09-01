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
  @JsonValue("더클라임 사당")
  theclimbSadang,
  @JsonValue("더클라임 신림")
  theclimbSillim,
  @JsonValue("더클라임 양재")
  theclimbYangjae,
  @JsonValue("더클라임 연남")
  theclimbYeonnam,
  @JsonValue("더클라임 일산")
  theclimbIlsan,
  @JsonValue("더클라임 문래")
  theclimbMullae,
  @JsonValue("더클라임 마곡")
  theclimbMagok,
  @JsonValue("더클라임 홍대")
  theclimbHongdae,
  @JsonValue("더클라임 서울대")
  theclimbSeoulUniv,
  @JsonValue("더클라임 강남")
  theclimbGangnam,
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
    "더클라임 문래": Location.theclimbMullae,
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
    Location.theclimbMullae: "더클라임 문래",
  };
}

enum BoulderLevel {
  @JsonValue("노란색")
  yellow,
  @JsonValue("주황색")
  orange,
  @JsonValue("초록색")
  green,
  @JsonValue("파란색")
  blue,
  @JsonValue("빨간색")
  red,
  @JsonValue("보라색")
  purple,
  @JsonValue("회색")
  gray,
  @JsonValue("갈색")
  brown,
  @JsonValue("검정색")
  black;

  static final Map<String, BoulderLevel> fromName = {
    "노란색": BoulderLevel.yellow,
    "주황색": BoulderLevel.orange,
    "초록색": BoulderLevel.green,
    "파란색": BoulderLevel.blue,
    "빨간색": BoulderLevel.red,
    "보라색": BoulderLevel.purple,
    "회색": BoulderLevel.gray,
    "갈색": BoulderLevel.brown,
    "검정색": BoulderLevel.black,
  };

  static final Map<BoulderLevel, String> toName = {
    BoulderLevel.yellow: "노란색",
    BoulderLevel.orange: "주황색",
    BoulderLevel.green: "초록색",
    BoulderLevel.blue: "파란색",
    BoulderLevel.red: "빨간색",
    BoulderLevel.purple: "보라색",
    BoulderLevel.gray: "회색",
    BoulderLevel.brown: "갈색",
    BoulderLevel.black: "검정색"
  };
}

// enum AttendanceStatus {
//   @JsonValue("attendance")
//   present,
//   @JsonValue("absent")
//   absent,
//   @JsonValue("late")
//   late;
//
//   static final Map<String, AttendanceStatus> fromName = {
//     "출석": AttendanceStatus.present,
//     "결석": AttendanceStatus.absent,
//     "지각": AttendanceStatus.late,
//   };
//
//   static final Map<AttendanceStatus, String> toName = {
//     AttendanceStatus.present: "출석",
//     AttendanceStatus.absent: "결석",
//     AttendanceStatus.late: "지각",
//   };
// }
