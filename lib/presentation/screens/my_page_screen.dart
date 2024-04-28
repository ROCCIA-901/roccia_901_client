import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyPageScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * (1 / 7),
            color: Color(0xfff8faed),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * (1 / 12),
              right: MediaQuery.of(context).size.width * (1 / 12),
              top: MediaQuery.of(context).size.width * (1 / 20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/titles/my_page_title.svg',
                    height: MediaQuery.of(context).size.width * (1 / 18),
                  ),
                ),
                Container(
                  child: InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/my_page_logout.svg',
                      height: MediaQuery.of(context).size.width * (1 / 18),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "로그아웃",
                              ),
                              content: Text("로그아웃 하시겠습니까?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '네',
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '아니오',
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * (2 / 7),
            color: Color(0xfff8faed),
            child: SvgPicture.asset(
              'assets/profiles/profile_5.svg',
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * (1 / 3),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.width * (1 / 7) - 10,
                    decoration:
                        BoxDecoration(color: Color(0xfff8faed), boxShadow: [
                      BoxShadow(
                        color: Color(0xff9a9a9a),
                        spreadRadius: 0.5,
                        blurRadius: 10,
                      )
                    ]),
                  ),
                ),
                Positioned(
                  top: -10,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 20,
                    color: Color(0xfff8faed),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width * (1 / 14) - 10,
                  left: MediaQuery.of(context).size.width * (1 / 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * (5 / 6),
                    height: MediaQuery.of(context).size.width * (5 / 18),
                    decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Color(0xff878787),
                        )),
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * (1 / 18),
                      right: MediaQuery.of(context).size.width * (1 / 18),
                    ),
                    child: Center(
                      child: Text(
                        "안녕하세요, 이번 11기에 새로 들어왔습니다. 앞으로 잘 부탁드립니다!잘부탁드린다구요제말들리시나요우리앞으로잘해봐요잘부탁드립니다만나서반가워요잘부탁드린다니까요잘부탁해요잘부잘부잘부",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.width * (1 / 4),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * (1 / 8),
              ),
              child: Row(
                children: [
                  Text(
                    '프로필',
                    style: TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 14,
                      color: Color(0xff9a9a9a),
                    ),
                    onPressed: () {}, //프로필 수정
                  )
                ],
              )),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '이름',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '???',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '기수',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '등급',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '부원',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '운동 지점',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '더클라임 ??',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '난이도',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '??',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * (1 / 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xfff1f1f1),
              width: 2,
            ))),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * (1 / 4),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * (1 / 10),
              left: MediaQuery.of(context).size.width * (1 / 8),
            ),
            child: Text(
              '내 출석',
              style: TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
            ),
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '출석',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?회',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '지각',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?회',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '결석',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?회',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * (1 / 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xfff1f1f1),
              width: 2,
            ))),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.width * (1 / 4),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * (1 / 10),
              left: MediaQuery.of(context).size.width * (1 / 8),
            ),
            child: Text(
              '내 기록',
              style: TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
            ),
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '노랑',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '초록',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '파랑',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '빨강',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: MediaQuery.of(context).size.width * (1 / 12),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (1 / 8),
                ),
                child: Text(
                  '보라',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: MediaQuery.of(context).size.width * (1 / 12),
                child: Text(
                  '?개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * (1 / 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xfff1f1f1),
              width: 2,
            ))),
          ),
        ],
      ),
    )));
  }
}
