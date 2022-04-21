import 'package:flutter/material.dart';
import 'package:flutter_install_test/component/card_title.dart';
import 'package:flutter_install_test/component/main_card.dart';
import 'package:flutter_install_test/component/main_stat.dart';
import 'package:flutter_install_test/model/stat_and_status_model.dart';
import 'package:flutter_install_test/utils/data_utils.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color darkColor;
  final Color lightColor;
  final List<StatAndStatusModel> models;

  const CategoryCard({
    required this.region,
    required this.darkColor,
    required this.lightColor,
    required this.models,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        backgroundColor: lightColor,
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardTitle(
                  title: '종류별 통계',
                  backgroundColor: darkColor,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    children: models
                        .map(
                          (model) => MainStat(
                            category: DataUtils.getItemCodeKrString(
                              itemCode: model.itemCode,
                            ),
                            imgPath: model.status.imagePath,
                            level: model.status.label,
                            stat: '${model.stat.getLevelFromRegion(
                              region,
                            )}${DataUtils.getUnitFromItemCode(
                              itemCode: model.itemCode,
                            )}',
                            width: constraint.maxWidth / 3,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
