import 'dart:ui';

import 'package:final_project/data.dart';
import 'package:final_project/sqlf.dart';
import 'package:final_project/edit.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  Future readdatafromSql() async {
    var d = data.sql.readData("SELECT * FROM notes ");
    // datata = d;
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: data.c.keys.toList()[data.index],
        title: const Text(
          "MY Notes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(child: listnote1(context)),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 40.0,
        width: 40.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: data.c.keys.toList()[data.index],
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return Edit("", "");
              }));
            },
            child: Icon(Icons.add, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }

  listnote1(BuildContext context) {
    int x = 0;
    Random random = new Random();
    return FutureBuilder(
        future: readdatafromSql(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () async {
                      // int response = await data.sql.deleteData(
                      //     '''DELETE FROM notes WHERE id =${snapshot.data![i]["id"]}''');
                      // print('Delete****');
                      // print(response);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return Edit(snapshot.data![i]["title"],
                            snapshot.data![i]["note"]);
                      }));
                    },
                    child: Card(
                      color: data.c.keys.toList()[x = random.nextInt(9)],
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(left: 2),
                          child: ListTile(
                            title: Text(
                              "${snapshot.data![i]["title"]}",
                              style: TextStyle(
                                  color: data.c.keys.toList()[data.index]),
                            ),
                            subtitle: Text("${snapshot.data![i]["note"]}"),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: 400,
          );

          // return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   Image.asset(
          //     "assets/images/logo.jpg",
          //     width: 200,
          //   ),
          //   const Text(
          //     "No Notes :(",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //   ),
          //   const Text("You have no task to do")
          // ]);
        });
  }

  // listnote2(BuildContext context) {
  //   int x = 0;
  //   Random random = new Random();
  //   return ListView.builder(
  //       itemCount: datata.length,
  //       itemBuilder: (context, index) {
  //         return InkWell(
  //           onTap: () async {
  //             // int response = await data.sql.deleteData(
  //             //     '''DELETE FROM notes WHERE id =${snapshot.data![i]["id"]}''');
  //             // print('Delete****');
  //             // print(response);
  //             Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //               return Edit(datata[index]["title"], datata[index]["note"]);
  //             }));
  //           },
  //           child: Card(
  //             color: data.c.keys.toList()[x = random.nextInt(9)],
  //             elevation: 5,
  //             child: Container(
  //               width: double.infinity,
  //               decoration:
  //                   BoxDecoration(borderRadius: BorderRadius.circular(15)),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(0),
  //                   color: Colors.white,
  //                 ),
  //                 margin: EdgeInsets.only(left: 2),
  //                 child: ListTile(
  //                   title: Text(
  //                     "${datata[index]["title"]}",
  //                     style: TextStyle(color: data.c.keys.toList()[data.index]),
  //                   ),
  //                   subtitle: Text("${datata[index]["note"]}"),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
