import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

class MyRecordScreen extends StatefulWidget {
  const MyRecordScreen({Key? key}) : super(key: key);

  @override
  State<MyRecordScreen> createState() => _recordState();
}

class _recordState extends State<MyRecordScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;


  final List<Widget> _tabs = [
    const Tab(text: "내 기록"),
    const Tab(text: "랭킹"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                '기록',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              width: 100,
              height: 50,
            ),
            TabBar(
              tabs: _tabs,
              controller: _tabController,
              //physics: NeverScrollableScrollPhysics(),
              indicatorColor: Color(0xffcae4c1),
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "내 기록"
                        ),
                        height: 550,
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: InkWell(
                          child: SvgPicture.asset(
                            'assets/icons/record_myrecord.svg',
                            height: 50,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(alignment: Alignment.center,
                    child: Text(
                        "랭킹"
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}