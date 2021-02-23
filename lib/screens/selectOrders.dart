import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class selectOrders extends StatefulWidget {
  // naming this current page to easily route
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
            // title: Text(dataname["address"].toString()),
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
              Column(
                children: <Widget>[
                  kioskStream('Hot Drinks'),
                ],
              ),
              Column(
                children: <Widget>[
                  kioskStream('Cold Drinks'),
                ],
              ),
              Column(
                children: <Widget>[
                  kioskStream('Pastries'),
                ],
              ),
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
  kioskStream(this.type);
  final String type;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('BarnOrders')
          .document('WADcdb3v134DEf0FcjM7')
          .collection(this.type)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final cafees = snapshot.data.documents.reversed;
        List<MessageBubble> orderBubble = [];
        for (var caafee in cafees) {
          final orderName1 = caafee.data['name'];
          final orderPrice1 = caafee.data['price'];
          final Bubble = MessageBubble(
            orderPrice: orderPrice1,
            orderName: orderName1,
          );

          orderBubble.add(Bubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: orderBubble,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.orderPrice, this.orderName});

  final int orderPrice;
  final String orderName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0)),
                        backgroundColor: Colors.white,
                        child: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 555,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 490, 10, 10),
                                  child: Column(
                                    children: [
                                      //buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            color: Colors.redAccent,
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RaisedButton(
                                            onPressed: () {},
                                            color: Colors.green,
                                            child: Text(
                                              'Continue',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: -60,
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.white70,
                              //     radius: 60,
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //   ),
                              // ),
                            ]),
                      );
                    });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.brown[50],
              color: Colors.white10,
              child: Row(
                children: <Widget>[
                  Container(
                    // img
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('images/$orderName.jpeg'),
                      ),
                    ),

                    height: 110.0,
                    width: 110.0,
                  ),
                  Text(
                    // cafe name
                    '$orderName' + '\n$orderPrice',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 1.35,
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
