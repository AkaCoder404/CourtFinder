import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:courtfinder/features/main/widgets/circular_buttons.dart';
import 'package:courtfinder/theme/pallete.dart';

class HorizontalButtonCarousel extends StatelessWidget {
  final List<Widget> buttons;
  const HorizontalButtonCarousel({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Pallete.lightGreyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Categories',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          const SizedBox(height: 10),
          // Show Ads here
          CarouselSlider(
            options: CarouselOptions(
                height: 200,
                autoPlay: false,
                initialPage: 0,
                // enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 0.3,
                scrollDirection: Axis.horizontal),
            // items: [
            //   CircularButton(
            //     icon: Icons.movie,
            //     label: 'Movies',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => MoviesPage()),
            //       // );
            //     },
            //   ),
            //   CircularButton(
            //     icon: Icons.music_note,
            //     label: 'Music',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => MusicPage()),
            //       // );
            //     },
            //   ),
            //   CircularButton(
            //     icon: Icons.book,
            //     label: 'Books',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => BooksPage()),
            //       // );
            //     },
            //   ),
            //   CircularButton(
            //     icon: Icons.sports_basketball,
            //     label: 'Sports',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => SportsPage()),
            //       // );
            //     },
            //   ),
            //   CircularButton(
            //     icon: Icons.games,
            //     label: 'Games',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => GamesPage()),
            //       // );
            //     },
            //   ),
            //   CircularButton(
            //     icon: Icons.shopping_cart,
            //     label: 'Shopping',
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => ShoppingPage()),
            //       // );
            //     },
            //   ),
            // ],
            items: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [buttons[0], buttons[1], buttons[2], buttons[3]],
                    ),
                    if (buttons.length > 4)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buttons.sublist(4),
                      ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
