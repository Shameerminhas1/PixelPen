import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 50, top: 80),
        child: Row(
          children: [
            Expanded(
              child: Container(
                //height: 1500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pen.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              // padding: const EdgeInsets.all(20),
              color: Colors.white, // Background color for the column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    'WELCOME',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TO PIXELPEN',
                    style: TextStyle(
                      color: Colors.red,
                      //color: Colors.lightBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //fixedSize: (),
                          backgroundColor: Colors
                              .green, // Change this color to your desired color
                        ),
                        // onHover: ,
                        onPressed: () {},
                        child: Text('Lets Get Started')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
