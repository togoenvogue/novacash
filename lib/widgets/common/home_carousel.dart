import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomeCarousel extends StatelessWidget {
  final String image1 =
      'https://mastercash.network/_novacash/marketing-digital.jpg';
  final String image2 = 'https://mastercash.network/_novacash/happy_man.jpg';
  final String image3 = 'https://mastercash.network/_novacash/award1.jpg';
  final String image4 = 'https://mastercash.network/_novacash/award2.jpg';
  final String image5 = 'https://mastercash.network/_novacash/award3.jpg';
  @override
  Widget build(BuildContext context) {
    return Carousel(
      images: [
        //ExactAssetImage("assets/images/marketing-digital.jpg"),
        //ExactAssetImage("assets/images/happy_man.jpg"),
        //NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),

        NetworkImage(image1) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(image1),
        NetworkImage(image2) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(image2),
        NetworkImage(image3) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(image3),
        NetworkImage(image4) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(image4),
        NetworkImage(image5) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(image5),

        //ExactAssetImage("assets/images/award1.jpg"),
        //ExactAssetImage("assets/images/award2.jpg"),
        //ExactAssetImage("assets/images/award3.jpg"),
      ],
    );
  }
}
