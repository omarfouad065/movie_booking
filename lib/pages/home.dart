import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/core/utils/app_images.dart';
import 'package:movie_booking/pages/detail_page/detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.name});

  @override
  State<Home> createState() => _HomeState();
  final String name;
}

class _HomeState extends State<Home> {
  final List<String> imageList = [
    Assets.assetsImagesInfinity,
    Assets.assetsImagesSalman,
    Assets.assetsImagesShahrukhmovies
  ];
  String? id, name, email, image;

  getTheSharedPref() async {
    SharedPreferanceHelper sharedPrefHelper = SharedPreferanceHelper();
    id = await sharedPrefHelper.getUserId();
    name = await sharedPrefHelper.getUserName();
    email = await sharedPrefHelper.getUserEmail();
    image = await sharedPrefHelper.getUserImage();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 30,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(Assets.assetsImagesWave,
                      width: 40, height: 40, fit: BoxFit.cover),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Hello, ${widget.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(Assets.assetsImagesBoy,
                          width: 60, height: 60, fit: BoxFit.cover),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Welcome To,',
                style: TextStyle(
                  color: const Color.fromARGB(186, 255, 255, 255),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(children: [
                Text(
                  'Filmy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Fun',
                  style: TextStyle(
                    color: Color(0xffedb41d),
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CarouselSlider(
                  items: imageList.map((e) {
                    return Builder(
                      builder: (context) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              e,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Top Trending Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 250,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  MovieCard(
                    image: Assets.assetsImagesInfinity,
                    title: 'Infinity War',
                    subtitle: 'Action, Adventure',
                    movieDetail:
                        'The Avaengers and their allies must be wield their powers and use them for good in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.',
                    ticketPrice: 10,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MovieCard(
                    image: Assets.assetsImagesPushpa,
                    title: 'Pushpa 2',
                    subtitle: 'Action',
                    movieDetail: '2',
                    ticketPrice: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MovieCard(
                    image: Assets.assetsImagesSalman,
                    title: 'Salman',
                    subtitle: 'Action',
                    movieDetail: '3',
                    ticketPrice: 30,
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.movieDetail,
    required this.ticketPrice,
  });

  final String image;
  final String title;
  final String subtitle;
  final String movieDetail;
  final int ticketPrice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      image: image,
                      name: title,
                      shortDetail: subtitle,
                      movieDetail: movieDetail,
                      ticketPrice: ticketPrice,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: 220,
                width: 220,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(top: 180),
              width: 220,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: TextStyle(
                          color: const Color.fromARGB(173, 255, 255, 255),
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
