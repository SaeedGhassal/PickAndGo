import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class selectOrders extends StatefulWidget {
  static const String id = 'selectOrders';
  @override
  _selectOrdersState createState() => _selectOrdersState();
}

Map dataname = {};

class _selectOrdersState extends State<selectOrders> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    dataname = ModalRoute.of(context).settings.arguments;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(dataname["address"].toString()),
            backgroundColor: Colors.brown.shade400,
            bottom: TabBar(
              tabs: [
                Tab(child: Text('Hot Drinks')),
                Tab(text: 'Cold Drinks'),
                Tab(text: 'Pastries'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              kioskStream(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.brown.shade400,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.40),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Kiosks'),
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            title: Text('Cart'),
            icon: Icon(Icons.add_shopping_cart),
          ),
          BottomNavigationBarItem(
            title: Text('About'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

class kioskStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("BarnOrders")
          .document()
          .collection("Hot Drinks")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final cafees = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var caafee in cafees) {
          final CafeName1 = caafee.data["name"];
          final noBranches1 = caafee.data["price"];
          print(CafeName1);
          print(noBranches1);
          final Bubble = MessageBubble(
            noBranches: noBranches1,
            CafeName: CafeName1,
          );
          print(CafeName1);
          print(noBranches1);
          messageBubbles.add(Bubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.noBranches, this.CafeName});

  final String noBranches;
  final String CafeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: RaisedButton(
              onPressed: () {
                //nav to next page
                print(CafeName);
                print(noBranches);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              disabledColor: Colors.brown[50],
              child: Row(
                children: <Widget>[
                  Container(
                    // img
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset('images/$CafeName.jpeg'),
                      ),
                    ),

                    height: 110.0,
                    width: 110.0,
                  ),
                  Text(
                    // cafe name
                    CafeName,
                    style: TextStyle(
                      letterSpacing: 1.45,
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            // branches
            ' Available Branches: $noBranches',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
