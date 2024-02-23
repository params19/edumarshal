// import 'package:edumarshals/Screens/OverAllAttendance.dart';
import 'dart:convert';

import 'package:edumarshals/Screens/Attendance/OverAllAttendance.dart';
import 'package:edumarshals/Screens/User_Info/Document/Document_Image.dart';
import 'package:edumarshals/Widget/My_Document_View_Card.dart';
import 'package:edumarshals/main.dart';
import 'package:edumarshals/repository/Document_Repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';

class MyDocument extends StatefulWidget {
 const  MyDocument({Key? key}) : super(key: key);

  @override
  State<MyDocument> createState() => _MyDocumentState();
}

class _MyDocumentState extends State<MyDocument> {
  
final DocumentRepository _documentRepository = DocumentRepository();
  List<String> items = [
    "My Document",
    "Upload/Update Document",
  ];
  Map<String, dynamic>? document;
  
  @override
  void initState() {
    super.initState();
    fetchDocuments(); // Fetch documents when the screen initializes
  }
 void fetchDocuments() async {
    try {
      final data = await _documentRepository.fetchDocuments(); // Fetch documents
      print("hellodube$data");
      if (data != null) {
        // Parse the data (Assuming the data is a list of strings)
        print("vidhi");
        setState(() {
          document=json.decode(data)["documents"];
          print("dududududududud");
          print(document?.keys);
          print(document?.length);
          print("vaibhav");
        });
      }
    } catch (error) {
      print("vidhisdfg");
      print('Error fetching documents: $error');
    }
  }
List<Widget> _buildDocumentCards() {
  if (document == null) {
    return []; // Return an empty list if document is null
  }
  print("hg");
  print(document!['studentPhoto']);
  
          PreferencesManager().studentPhoto=document!['studentPhoto'];

  return document!.keys.map((documentName) {
    return My_Document_View_Card(
      documentname: documentName,
      textbuttonname: 'View',
      onpressed: () {
        // Navigate to a new screen to display the image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Document_Image(imageUrl: document![documentName],),
          ),
        );
      },
    );
  }).toList();
}

  List<List<Widget>> cards = [
    [
      const My_Document_View_Card(
        documentname: "Aadhar Card 1",
        textbuttonname: 'View',
      ),
      // const My_Document_View_Card(
      //   documentname: "Graduation/Diploma Marksheet",
      //   textbuttonname: 'View',
      // ),
      // const My_Document_View_Card(
      //   documentname: "Aadhar Card 1",
      //   textbuttonname: 'View',
      // ),
      // const My_Document_View_Card(
      //   documentname: "Graduation/Diploma Marksheet",
      //   textbuttonname: 'View',
      // ),


 
    ],
    [
      const My_Document_View_Card(
        documentname: "10th Marksheet",
        textbuttonname: 'Upload',
      ),
      const My_Document_View_Card(
        documentname: "Passport ",
        textbuttonname: 'Upload',
      ),
    ],
  ];
  int current = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 243, 255, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        toolbarHeight: 100.0, // Adjust the height as needed
        title:  Center(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(document!['studentPhoto']),
                backgroundColor: Color.fromARGB(255, 17, 37, 218),
              ),
              Text(PreferencesManager().name),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                  child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> OverAllAttd()));
                      }, icon: const Icon(Icons.arrow_back)),
                  const Text(
                    "My Documents",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              )),

              /// Tab Bar
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ListView.builder(
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(5),
                              width: screenwidth * 0.45,
                              height: 55,
                              decoration: BoxDecoration(
                                color: current == index
                                    ? const Color.fromRGBO(0, 88, 214, 1)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: current == index
                                    ? BorderRadius.circular(12)
                                    : BorderRadius.circular(7),
                                border: current == index
                                    ? Border.all(
                                        color:
                                            const Color.fromRGBO(0, 88, 214, 1),
                                        width: 2.5)
                                    : null,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      items[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: current == index
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                0, 88, 214, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  // margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  height: screenHeight * 6,
                  child: PageView.builder(
                    itemCount: cards.length,
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListView(
                       children:  _buildDocumentCards(),
                      );
                    },
                  ),
                ),
              ),
            //      Column(
            //   children: documents.map((documentList) {
            //     return Column(
            //       children: documentList.map((document) {
            //         return My_Document_View_Card(documentname: document, textbuttonname: 'View');
            //       }).toList(),
            //     );
            //   }).toList(),
            // ),
            ],
          ),
        ),
      ),
    );
  }
}
