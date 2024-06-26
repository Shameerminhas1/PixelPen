// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:pixelpen/Textscreen.dart';
// import 'package:share_plus/share_plus.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<File> savedFiles = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedFiles();
//   }

//   void _loadSavedFiles() async {
//     final directory = await getExternalStorageDirectory();
//     final files = directory!
//         .listSync()
//         .where((file) {
//           final path = file.path;
//           return path.endsWith('.pdf') || path.endsWith('.doc');
//         })
//         .map((file) => File(file.path))
//         .toList();

//     setState(() {
//       savedFiles = files;
//     });
//   }

//   void _renameFile(File file) async {
//     TextEditingController _renameController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Rename File'),
//           content: TextField(
//             controller: _renameController,
//             decoration: InputDecoration(hintText: 'Enter new file name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Update'),
//               onPressed: () async {
//                 final directory = await getExternalStorageDirectory();
//                 String newName = _renameController.text;
//                 if (newName.isNotEmpty) {
//                   String newPath =
//                       '${directory!.path}/$newName${file.path.endsWith('.pdf') ? '.pdf' : '.doc'}';
//                   file.renameSync(newPath);
//                   setState(() {
//                     _loadSavedFiles(); // Refresh the file list
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _shareFile(File file) async {
//     final box = context.findRenderObject() as RenderBox?;
//     final shareResult = await Share.shareXFiles(
//       [XFile(file.path)],
//       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.blue.shade500,
//         behavior: SnackBarBehavior.floating,
//         content: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 shareResult.status == ShareResultStatus.success
//                     ? Icons.check_circle_outline
//                     : Icons.error_outline,
//                 color: shareResult.status == ShareResultStatus.success
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               SizedBox(width: 12.0),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       shareResult.status == ShareResultStatus.success
//                           ? 'Shared successfully!'
//                           : 'Share failed!',
//                       style: TextStyle(
//                         color: shareResult.status == ShareResultStatus.success
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     if (shareResult.status == ShareResultStatus.success)
//                       Text(
//                         'Shared to: ${shareResult.raw}',
//                         style: TextStyle(fontSize: 14.0),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         action: SnackBarAction(
//           label: 'Close',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _editFileContent(File file) async {
//     String fileContent = await file.readAsString();
//     String fileName = file.path.split('/').last;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Textscreen(
//           initialFileName: fileName,
//           initialFileContent: fileContent,
//         ),
//       ),
//     );
//   }

//   void _viewFile(File file) {
//     OpenFilex.open(file.path);
//   }

//   void _deleteFile(File file) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete File'),
//           content: Text(
//               'Are you sure you want to delete ${file.path.split('/').last}?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Delete'),
//               onPressed: () {
//                 file.deleteSync(); // Delete the file
//                 setState(() {
//                   savedFiles.remove(file); // Remove from the list
//                 });
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: ListView.builder(
//         itemCount: savedFiles.length,
//         itemBuilder: (context, index) {
//           final file = savedFiles[index];
//           return ListTile(
//             title: Text(file.path.split('/').last), // Display file name
//             onTap: () => _viewFile(file),
//             trailing: PopupMenuButton<String>(
//               onSelected: (value) {
//                 if (value == 'rename') {
//                   _renameFile(file);
//                 } else if (value == 'share') {
//                   _shareFile(file);
//                 } else if (value == 'edit') {
//                   _editFileContent(file);
//                 } else if (value == 'delete') {
//                   _deleteFile(file);
//                 }
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                 PopupMenuItem<String>(
//                   value: 'rename',
//                   child: Text('Rename'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'share',
//                   child: Text('Share'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'edit',
//                   child: Text('Edit'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'delete',
//                   child: Text('Delete'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
////----------------------------

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pixelpen/Camerainput.dart';
import 'package:pixelpen/Textscreen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> savedFiles = [];
  List<File> searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
    _searchController.addListener(_searchFiles);
  }

  void _loadSavedFiles() async {
    final directory = await getExternalStorageDirectory();
    final files = directory!
        .listSync()
        .where((file) {
          final path = file.path;
          return path.endsWith('.pdf') || path.endsWith('.doc');
        })
        .map((file) => File(file.path))
        .toList();

    setState(() {
      savedFiles = files;
      searchResults = files;
    });
  }

  void _searchFiles() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        searchResults = savedFiles;
      } else {
        searchResults = savedFiles.where((file) {
          return file.path.toLowerCase().contains(query);
        }).toList();

        searchResults
            .sort((a, b) => a.path.toLowerCase().contains(query) ? -1 : 1);
      }
    });
  }

  void _renameFile(File file) async {
    TextEditingController _renameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename File'),
          content: TextField(
            controller: _renameController,
            decoration: InputDecoration(hintText: 'Enter new file name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                final directory = await getExternalStorageDirectory();
                String newName = _renameController.text;
                if (newName.isNotEmpty) {
                  String newPath =
                      '${directory!.path}/$newName${file.path.endsWith('.pdf') ? '.pdf' : '.doc'}';
                  file.renameSync(newPath);
                  setState(() {
                    _loadSavedFiles(); // Refresh the file list
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _shareFile(File file) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareResult = await Share.shareXFiles(
      [XFile(file.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                shareResult.status == ShareResultStatus.success
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: shareResult.status == ShareResultStatus.success
                    ? Colors.green
                    : Colors.red,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shareResult.status == ShareResultStatus.success
                          ? 'Shared successfully!'
                          : 'Share failed!',
                      style: TextStyle(
                        color: shareResult.status == ShareResultStatus.success
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    if (shareResult.status == ShareResultStatus.success)
                      Text(
                        'Shared to: ${shareResult.raw}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<bool> isTextFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      for (var i = 0; i < bytes.length && i < 1024; i++) {
        if (bytes[i] > 0x7F) {
          return false; // Non-ASCII byte detected, likely a binary file
        }
      }
      return true; // No non-ASCII bytes detected, likely a text file
    } catch (e) {
      return false; // Reading bytes failed, consider it non-text
    }
  }

  void _editFileContent(File file) async {
    if (await isTextFile(file)) {
      try {
        String fileContent = await file.readAsString();
        String fileName = file.path.split('/').last;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Textscreen(
              initialFileName: fileName,
              initialFileContent: fileContent,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Unable to read file content.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: The file is not a text file.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewFile(File file) {
    OpenFilex.open(file.path);
  }

  void _deleteFile(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete File'),
          content: Text(
              'Are you sure you want to delete ${file.path.split('/').last}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                file.deleteSync(); // Delete the file
                setState(() {
                  savedFiles.remove(file); // Remove from the list
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.blue.shade700,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 65.0, left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Text(
                'WELCOME TO PIXELPEN',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                  hintText: 'Search',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final file = searchResults[index];
                    bool isHighlighted = _searchController.text.isNotEmpty &&
                        file.path
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase());

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: isHighlighted ? Colors.blue.shade100 : null,
                      child: ListTile(
                        leading: Icon(
                          file.path.endsWith('.pdf')
                              ? Icons.picture_as_pdf
                              : Icons.insert_drive_file,
                          color: Colors.blue.shade700,
                        ),
                        title: Text(file.path.split('/').last),
                        subtitle: Text(
                            'Modified: ${file.lastModifiedSync().toLocal()}'),
                        onTap: () => _viewFile(file),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'rename') {
                              _renameFile(file);
                            } else if (value == 'share') {
                              _shareFile(file);
                            } else if (value == 'edit') {
                              _editFileContent(file);
                            } else if (value == 'delete') {
                              _deleteFile(file);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'rename',
                              child: Text('Rename'),
                            ),
                            PopupMenuItem<String>(
                              value: 'share',
                              child: Text('Share'),
                            ),
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 35,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraInput()),
            );
          },
          backgroundColor: Colors.white,
          child: Icon(Icons.camera_enhance, color: Colors.blue.shade700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
