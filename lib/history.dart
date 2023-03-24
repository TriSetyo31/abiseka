import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/controller/firestore.dart';
import 'package:login_flutter/models/model_user.dart';
import 'package:intl/intl.dart';

class History extends StatelessWidget {
  Future<List<ModelUser>> getDataUser() async {
    return await FirestoreHelper.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HALAMAN HISTORY"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: getDataUser(),
          builder: (context, AsyncSnapshot<List<ModelUser>> snapshot) {
            var data = snapshot.data;
            if (snapshot.connectionState==ConnectionState.done)
           { if (data != null && data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var item = data[index];
                  var image = base64.decode(item.fileBlob ?? "");
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nama ?? '',
                                      style: TextStyle(
                                        fontFamily: 'SourceSansPro-Regular',
                                        fontSize: 20.0,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(item.eMail ?? ''),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${item.latitude ?? ''}, ${item.longitude ?? ''}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      DateFormat('dd MMMM yyyy, HH:mm:ss')
                                          .format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(item.created!),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      item.tipe ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "TIDAK ADA DATA",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }}else{
              return Center(
                child: SizedBox(
                  width: 50, height: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
