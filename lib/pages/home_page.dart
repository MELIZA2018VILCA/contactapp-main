import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactapp/pages/home_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controlador = HomePageController();
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controlador.init(context, refresh);
    });
  }

  final CollectionReference contactReferences =
      FirebaseFirestore.instance.collection('contacto');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: AppBar(
          title: Text('Contact App'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
          // backgroundColor: Colors.white,
          // actions: [
          //   GestureDetector(
          //     onTap: () => controlador.openDrawer(context),
          //     child: Padding(
          //       padding: EdgeInsets.only(right: 30.0),
          //       child: Icon(
          //         CupertinoIcons.text_alignleft,
          //         color: Colors.white,
          //         size: 30.0,
          //       ),
          //     ),
          //   ),
          // ],
          flexibleSpace: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     // stops: [0.5, 0.6],
            //     colors: [Color(0xff141E30), Color(0xff243B55)],
            //   ),
            // ),
            child: Column(
              children: [
                Gap(55),
                _SearchWidget(
                  controlador: controlador,
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: contactReferences.snapshots(),
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // inspect(snapshot);
            if (snapshot.hasData) {
              QuerySnapshot collection = snapshot.data;
              List<QueryDocumentSnapshot> docs = collection.docs;
              List<Map<String, dynamic>> docMap = docs.map((e) {
                return e.data() as Map<String, dynamic>;
              }).toList();
              inspect(docMap);
              return ListView.builder(
                itemCount: docMap.length,
                itemBuilder: ((context, int i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.indigo,
                      child: Text(
                        docMap[i]['nombre'].substring(0, 2),
                      ),
                    ),
                    title: Text(
                      docMap[i]['nombre'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      color: Colors.green,
                      icon: Icon(
                        CupertinoIcons.phone_arrow_right,
                      ),
                      onPressed: () {
                        log(docMap[i]['telefono']);
                      },
                    ),
                  );
                }),
              );
            }
            return LinearProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
            onPressed: () {
              log('añadir contacto');
            },
            icon: Icon(
              CupertinoIcons.add_circled,
            )),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final HomePageController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 17.0),
      child: TextField(
        onChanged: (texto) => controlador.onChangedText(texto),
        decoration: InputDecoration(
          hintText: 'Buscar Usuario...',
          suffixIcon: Icon(CupertinoIcons.search, color: Colors.white),
          hintStyle: TextStyle(
            fontSize: 17.0,
            color: Colors.grey[100],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
            // borderSide: BorderSide(color: Colors.grey.withOpacity(0.9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.2),
          ),
          contentPadding: EdgeInsets.all(15.0),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
