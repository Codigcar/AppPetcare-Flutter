import 'package:flutter/material.dart';
import 'package:petcare/constants.dart';
import 'package:petcare/src/models/request_model.dart';
import 'package:petcare/src/services/business_request_service.dart';

class HomeBusinessPage extends StatefulWidget {
  @override
  _HomeBusinessPageState createState() => _HomeBusinessPageState();
}

class _HomeBusinessPageState extends State<HomeBusinessPage> {

  final businessRequestService = new BusinessRequestService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          SafeArea(
            child: _requestList()
          )
        ],
      ),
    );
  }

  Widget _background() {
    final totalSize = MediaQuery.of(context).size;
    
    return Container(
      height: totalSize.height *0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(100.0) ),
        color: colorPetCare
      ),
    );
  }

  Widget _requestItem(BuildContext context, RequestModel request ){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                       /*  leading: Icon(Icons.photo_album, color: Colors.blue), */
                        title: Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(request.productName)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(request.personName),
                            Text(request.petName),
                            Text(request.dateReservation.toString()),
                            Text(request.startTime),
                            Text(request.personPhone)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            ClipRRect (
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                color: Colors.red,
                                child: FadeInImage(
                                  placeholder: AssetImage('assets/jar-loading.gif'),
                                  image: NetworkImage( request.petPhoto),
                                ),
                          ),
                            ),
                            Icon(Icons.call, color: Color.fromRGBO(241, 234, 71, 1.0), size: 40.0),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    /* padding: EdgeInsets.only(left: 20.0), */
                    child: FlatButton(onPressed: () {}, child: Text('Rechazar', style: TextStyle(color: Colors.red)))),
                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    child: FlatButton(onPressed: () {}, child: Text('Aceptar', style: TextStyle(color: Colors.green),))),
                ],
              )
            ],
          ),
      ),
    );
  }

  Widget _requestList(){
    return FutureBuilder(
      future: businessRequestService.getAllRequestByProviderId(1),
      builder: (BuildContext context,
        AsyncSnapshot<List<RequestModel>> snapshot) {
          if ( snapshot.hasData ){
            final requests = snapshot.data;
            print(requests.length);
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) =>
                _requestItem(context, requests[index])
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}