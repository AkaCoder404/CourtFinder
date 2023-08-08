// Main page for the app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/features/explore/view/explore_view.dart';
import 'package:courtfinder/features/main/widgets/circular_buttons.dart';
import 'package:courtfinder/features/main/widgets/horizontal_button_carousel.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:getwidget/getwidget.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onPressed() {
      print("pressed");
    }

    void onSearchPressed() {
      Navigator.push(context, ExploreView.route());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Court Finder',
          style: TextStyle(color: Pallete.blackColor),
        ),
        actions: const [],
        centerTitle: true,
      ),
      body: Column(
        children: [
          GFItemsCarousel(
            rowCount: 1,
            children: imageList.map(
              (url) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
                  ),
                );
              },
            ).toList(),
          ),
          Container(
            color: Pallete.lightGreyColor,
            height: 100,
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 水平方向居中
              mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中

              children: [
                CircularCenteredButton(
                  icon: Icons.map,
                  label: '地图',
                  onPressed: onPressed,
                ),
                CircularCenteredButton(
                  icon: Icons.search,
                  label: '找人找队',
                  onPressed: onSearchPressed,
                ),
                CircularCenteredButton(
                  icon: Icons.sports_basketball,
                  label: '赛事',
                  onPressed: onPressed,
                ),
                CircularCenteredButton(
                  icon: Icons.shop,
                  label: '商场',
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
          // Add more widgets here
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5.0),
              color: Colors.amber,
              alignment: Alignment.center,
              child: const Text(
                "数据",
                style: TextStyle(color: Pallete.blackColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

final List<String> imageList = [
  "https://ts1.cn.mm.bing.net/th/id/R-C.22ee5232bb7edafa7d2170ab9bf19d6a?rik=I438UlaYX2VvDQ&riu=http%3a%2f%2fwww.morncorp.com%2fguanli%2fkindeditor%2fattached%2fimage%2f20190527%2f2019052716440181181.jpg&ehk=ezbhuyqKFUmki%2fkab5sKH77RN56WiPXQppgcHewY6%2fk%3d&risl=&pid=ImgRaw&r=0",
  "https://ts1.cn.mm.bing.net/th/id/R-C.22ee5232bb7edafa7d2170ab9bf19d6a?rik=I438UlaYX2VvDQ&riu=http%3a%2f%2fwww.morncorp.com%2fguanli%2fkindeditor%2fattached%2fimage%2f20190527%2f2019052716440181181.jpg&ehk=ezbhuyqKFUmki%2fkab5sKH77RN56WiPXQppgcHewY6%2fk%3d&risl=&pid=ImgRaw&r=0",
  "https://ts1.cn.mm.bing.net/th/id/R-C.22ee5232bb7edafa7d2170ab9bf19d6a?rik=I438UlaYX2VvDQ&riu=http%3a%2f%2fwww.morncorp.com%2fguanli%2fkindeditor%2fattached%2fimage%2f20190527%2f2019052716440181181.jpg&ehk=ezbhuyqKFUmki%2fkab5sKH77RN56WiPXQppgcHewY6%2fk%3d&risl=&pid=ImgRaw&r=0",
  "https://ts1.cn.mm.bing.net/th/id/R-C.22ee5232bb7edafa7d2170ab9bf19d6a?rik=I438UlaYX2VvDQ&riu=http%3a%2f%2fwww.morncorp.com%2fguanli%2fkindeditor%2fattached%2fimage%2f20190527%2f2019052716440181181.jpg&ehk=ezbhuyqKFUmki%2fkab5sKH77RN56WiPXQppgcHewY6%2fk%3d&risl=&pid=ImgRaw&r=0",
];
