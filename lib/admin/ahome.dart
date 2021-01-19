import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> litems = [];
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("users").get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            var document = snapshot.data.docs;
            document.forEach((data) {
              String variable =
                  data.get("name") + " " + data.get("surname") + ": ";

              if (data.get("task1_approve") == 1) {
                litems.add(variable + data.get("task1_name"));
              }
              if (data.get("task2_approve") == 1) {
                litems.add(variable + data.get("task2_name"));
              }
              if (data.get("task3_approve") == 1) {
                litems.add(variable + data.get("task3_name"));
              }
            });

            return CustomScrollView(
              slivers: [
                _title(context, 'Tasks'),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    margin: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: ListView.builder(
                        itemExtent: 40,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.all(5.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                                color: Colors.orangeAccent,
                                child: Text(litems[index]),
                                onPressed: () {},
                              ),
                            ),
                        itemCount: litems.length),
                  ),
                ),
              ],
            );
          }),
    );
  }

  _title(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(title,
              style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(fontSize: 16.0, color: Colors.deepOrange[900]))),
        ),
      ),
    );
  }
}
