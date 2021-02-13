import 'package:flutter/material.dart';
import '../../widgets/common/custom_horizontal_diver.dart';

class CustomListVerticalClickableWithLeadingImage extends StatelessWidget {
  final String id;
  final String label1;
  final String label2;
  final Function callBack;
  final String image;

  CustomListVerticalClickableWithLeadingImage({
    this.id,
    this.label1,
    this.label2,
    this.callBack,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    //print(id);
    return InkWell(
      onTap: () {
        callBack(id: id);
      },
      splashColor: Colors.white,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: image == null
                    ? Text('')
                    : Image.network(
                        image,
                        height: 40,
                      ),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  //color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            label1,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Text(
                            label2,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              CustomHorizontalDiver(),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
