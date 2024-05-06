import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/presentation/screens/record_screen/ranking_tab.dart';
import 'package:untitled/widgets/app_custom_bar.dart';

import '../../../constants/size_config.dart';
import '../../viewmodels/record/record_screen_viewmodel.dart';
import 'my_record_tab.dart';

@RoutePage()
class RecordScreen extends ConsumerStatefulWidget {
  final int? initialIndex;

  const RecordScreen({
    Key? key,
    this.initialIndex,
  }) : super(key: key);

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(

        /// Todo: length magic number 제거
        length: 2,
        vsync: this,
        initialIndex: widget.initialIndex ?? 0);
  }

  @override
  void didUpdateWidget(covariant RecordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != null) {
      _tabController.animateTo(widget.initialIndex!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      Tab(
        height: AppSize.of(context).safeBlockHorizontal * 13,
        child: Text("내 기록",
            style: TextStyle(fontSize: AppSize.of(context).font.headline3)),
      ),
      Tab(
        height: AppSize.of(context).safeBlockHorizontal * 13,
        child: Text("랭킹",
            style: TextStyle(fontSize: AppSize.of(context).font.headline3)),
      ),
    ];
    ref.watch(recordScreenViewmodelProvider);
    return Scaffold(
      appBar: buildAppCommonBar(context, title: "기록"),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TabBar(
              tabs: tabs,
              controller: _tabController,
              //physics: NeverScrollableScrollPhysics(),
              indicatorColor: Color(0xffcae4c1),
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              onTap: (_) {
                if (ref.read(recordScreenViewmodelProvider).bottomSheetState !=
                    RecordScreenBottomSheetState.none) {
                  ref
                      .read(recordScreenViewmodelProvider.notifier)
                      .closeBottomSheet();
                  Navigator.of(context).pop();
                }
              },
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  MyRecordTab(),
                  RankingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
