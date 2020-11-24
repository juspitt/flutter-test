import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class XmlClientOrder {
  String ship_req_id;
  String process_status;
  String comp_name;
  String full_name;
  String addr1_line;
  String addr2_line;
  String city_name;
  String state_code;
  String zip_code;
  String cntry_code;
  String phone_no;
  String email_id;
  String po_number;
  String client_ref_id;
}

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
final _formKey = GlobalKey<FormState>();

class ViewOrder extends StatefulWidget {
  ViewOrder({Key key}) : super(key: key);
  @override
  _ViewOrderState createState() => _ViewOrderState();
}
// i will try something..

class _ViewOrderState extends State<ViewOrder>
    with SingleTickerProviderStateMixin {
  List<XmlClientOrder> clientorder = [];
  List<XmlClientOrder> tab1 = [];
  List<XmlClientOrder> tab2 = [];

// please, run to see if firat tab is ok

  void _fetchClientOrders(status) {
    clientorder.clear();
    tab1.clear();
    tab2.clear();
    API.fetchClientOrders(GLOBAL.clientcode, status).then((value) {
      var document = xml.parse(value.body);
      var items = document.findAllElements('order');
      //items.forEach((var item) {
      for (final item in items) {
        var a = XmlClientOrder();
        a.ship_req_id = item.findElements('ship_req_id').single.text;
        a.process_status = item.findElements('process_status').single.text;
        a.comp_name = item.findElements('comp_name').single.text;
        a.full_name = item.findElements('full_name').single.text;
        a.addr1_line = item.findElements('addr1_line').single.text;
        a.addr2_line = item.findElements('addr2_line').single.text;
        a.city_name = item.findElements('city_name').single.text;
        a.state_code = item.findElements('state_code').single.text;
        a.zip_code = item.findElements('zip_code').single.text;
        a.cntry_code = item.findElements('cntry_code').single.text;
        a.phone_no = item.findElements('phone_no').single.text;
        a.email_id = item.findElements('email_id').single.text;
        a.po_number = item.findElements('po_number').single.text;
        a.client_ref_id = item.findElements('client_ref_id').single.text;
        clientorder.add(a);
      }
      print("status: " + status);
      if (status == "OPEN") {
        tab1 = clientorder;
      } else {
        tab2 = clientorder;
      }
      print(tab1.length);
      print(tab2.length);
      setState(() => {});
    });
  }

  // futurebuiler resolve you problem, What i thihk is happen, the widget tree are update when the array still with old values.. i know.. strage..
  // ok well i just started learning this 3 days ago so i need to research
  // ok.. lets me see, more one minute..

  @override
  void initState() {
    _fetchClientOrders("OPEN");
    super.initState();
  }

  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new TabBar(
            onTap: (index) {
              if (index == 0) {
                _fetchClientOrders("OPEN");
              }
              if (index == 1) {
                _fetchClientOrders("ADDRHOLD");
              }
            },
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            //labelPadding: EdgeInsets.symmetric(horizontal: 90),
            tabs: [
              new Tab(text: 'Open Orders'),
              new Tab(text: 'Hold Orders'),
            ]),
        body: new TabBarView(
          physics: NeverScrollableScrollPhysics(), //disable scroll
          children: [
            Column(
              children: <Widget>[
                const Divider(
                  height: 30.0,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 500,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tab1.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildListItemClientOrder(tab1[index], context);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                const Divider(
                  height: 30.0,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 500,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tab2.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildListItemClientOrder(tab2[index], context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_buildListItemClientOrder(XmlClientOrder news, BuildContext context) {
  return Card(
    child: Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 5),
              child: Text(
                  "Order #: " +
                      news.ship_req_id +
                      "\nPO#: " +
                      news.po_number +
                      "\nClient Ref #: " +
                      news.client_ref_id,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ),
    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
  );
}
