import 'dart:ui';
// import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:final_project/data.dart';

class Edit extends StatefulWidget {
  String titletitle = " ";
  String notenote = " ";

  @override
  State<StatefulWidget> createState() => _EditState();

  Edit(this.titletitle, this.notenote);
}

class _EditState extends State<Edit> {
  double opic = 1;
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  late int respose;
  @override
  void initState() {
    super.initState();
    title.text = widget.titletitle;
    note.text = widget.notenote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.backup_outlined)),
        backgroundColor: data.c.keys.toList()[data.index],
        title: const Text(
          "New Notes",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _Showbottom();
              },
              icon: Icon(Icons.settings)),
          IconButton(
              onPressed: () async {
                try {
                  setState(() {});

                  // await data.sql.mydeleteData();
                  respose = await data.sql
                      .insertData(''' INSERT INTO notes ('title' , 'note') 
                                  VALUES ("${title.text}","${note.text}")
                               ''');
                  print(respose);
                } catch (ere) {
                  print("errorrrrrrrrrrrrrrr");
                  print(respose);
                }
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.one_k_outlined))
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                      label: Text(
                    widget.titletitle == "" ? "Type Something..." : " ",
                    style: TextStyle(
                      color: data.c.keys.toList()[data.index],
                    ),
                  )),
                ),
              ),
              Card(
                elevation: 5,
                child: TextFormField(
                  controller: note,
                  maxLines: 3,
                  decoration: InputDecoration(
                      label: Text(
                    widget.titletitle == "" ? "Type Something..." : " ",
                    style: TextStyle(color: Colors.grey),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _Showbottom() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
                title: Text("Share with your friend"),
              ),
              InkWell(
                onTap: () async {
                  setState(() {});
                  int response = await data.sql.deleteData(
                      '''DELETE FROM notes WHERE title = "${widget.titletitle}"''');
                  print('Delete****');
                  print(response);
                },
                child: ListTile(
                  leading:
                      IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                  title: Text("Delete"),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    setState(() {});
                    // await data.sql.mydeleteData();
                    respose = await data.sql
                        .insertData(''' INSERT INTO notes ('title' , 'note') 
                                    VALUES ("${title.text}","${note.text}")
                                 ''');
                    print(respose);
                  } catch (ere) {
                    print("errorrrrrrrrrrrrrrr");
                    print(respose);
                  }
                },
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(Icons.control_point_duplicate_outlined),
                      onPressed: () {}),
                  title: Text("Duplicate"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ...data.c.entries.map((e) {
                    return Stack(alignment: Alignment.center, children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: e.key,
                        ),
                        margin: EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                      ),
                      Opacity(
                        opacity: opic,
                        child: InkWell(
                          onTap: () {
                            setState(() {});
                            data.index = e.value;
                          },
                          child: const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ]);
                  }).toList()
                ]),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}
// ListView.builder(

//                 scrollDirection: Axis.horizontal,
//                 itemCount: data.c.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: EdgeInsets.all(15),
//                     width: 50,
//                     height: 50,
//                     color: Colors.red,
//                   );
//                 },
//               )
