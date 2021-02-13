import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class EmptyFolder extends StatelessWidget {
  final bool isLoading;
  final String message;
  EmptyFolder({
    this.isLoading = false,
    this.message = 'Aucune donnée disponible',
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: !isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage('assets/images/empty_folder.png'),
                    width: 85,
                  ),
                  SizedBox(height: 8),
                  Text(
                    message,
                    style: TextStyle(
                      color: MyColors().primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
    );
  }
}
