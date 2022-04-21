import 'package:flutter/material.dart';
import 'package:flutter_install_test/component/category_card.dart';
import 'package:flutter_install_test/component/hourly_card.dart';
import 'package:flutter_install_test/component/main_app_bar.dart';
import 'package:flutter_install_test/component/main_drawer.dart';
import 'package:flutter_install_test/const/colors.dart';
import 'package:flutter_install_test/const/regions.dart';
import 'package:flutter_install_test/model/stat_model.dart';
import 'package:flutter_install_test/repository/stat_repository.dart';
import 'package:flutter_install_test/utils/data_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Future> futures = [];

    for (ItemCode itemCode in ItemCode.values) {
      futures.add(
        StatRepository.fetchData(
          itemCode: itemCode,
        ),
      );
    }

    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      // ItemCode
      final key = ItemCode.values[i];
      // List<StatModel>
      final value = results[i];

      final box = Hive.box(key.name);

      for (StatModel stat in value) {
        box.put(stat.dataTime.toString(), stat);
      }
    }
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        final recentStat = (box.values.toList().last as StatModel);

        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: recentStat.getLevelFromRegion(region),
          itemCode: ItemCode.PM10,
        );

        return Scaffold(
          backgroundColor: primaryColor,
          drawer: MainDrawer(
            darkColor: status.darkColor,
            lightColor: status.lightColor,
            selectedRegion: region,
            onRegionTap: (String region) {
              setState(() {
                this.region = region;
              });
              Navigator.of(context).pop();
            },
          ),
          body: Container(
            color: status.primaryColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                MainAppBar(
                  isExpanded: isExpanded,
                  region: region,
                  stat: recentStat,
                  status: status,
                  dateTime: recentStat.dataTime,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryCard(
                        region: region,
                        darkColor: status.darkColor,
                        lightColor: status.lightColor,
                      ),
                      SizedBox(height: 16.0),
                      ...ItemCode.values.map(
                        (itemCode) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: HourlyCard(
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              region: region,
                              itemCode: itemCode,
                            ),
                          );
                        },
                      ).toList(),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
