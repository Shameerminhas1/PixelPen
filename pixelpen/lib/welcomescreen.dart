import 'package:flutter/material.dart';
import 'package:pixelpen/CameraInput.dart';
import 'package:pixelpen/Chat_screen.dart';
import 'package:pixelpen/Readaloud.dart';
import 'package:pixelpen/Textscreen.dart';
import 'package:pixelpen/translate.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 50, top: 10),
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
              //padding: const EdgeInsets.only(bottom: 30),
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
                    width: 160,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //fixedSize: (),
                          backgroundColor: Colors
                              .green, // Change this color to your desired color
                        ),
                        // onHover: ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraInput(),
                            ),
                          );
                        },
                        child: Text(
                          'Lets Get Started',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  //read btn
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //fixedSize: (),
                        backgroundColor: Colors
                            .green, // Change this color to your desired color
                      ),
                      // onHover: ,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadAloud(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'LETS READ   ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //read btn
                  SizedBox(
                    height: 10,
                  ),
                  //translate
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //fixedSize: (),
                        backgroundColor: Colors
                            .green, // Change this color to your desired color
                      ),
                      // onHover: ,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TranslateScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'LETS TRANSLATE   ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.translate_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //fixedSize: (),
                        backgroundColor: Colors
                            .green, // Change this color to your desired color
                      ),
                      // onHover: ,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'LETS GENERATE   ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.generating_tokens_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //fixedSize: (),
                        backgroundColor: Colors
                            .green, // Change this color to your desired color
                      ),
                      // onHover: ,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Textscreen(),
                            //ChatScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'LETS WRITE   ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.generating_tokens_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
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
