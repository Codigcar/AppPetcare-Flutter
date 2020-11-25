import 'package:flutter/material.dart';
import 'package:petcare/src/models/person_profile_model.dart';
import 'package:petcare/src/models/request_model.dart';
import 'package:petcare/src/services/business_request_service.dart';
import 'package:petcare/src/services/person_profile_service.dart';

import '../../constants.dart';

class BusinessCustomersPage extends StatefulWidget {
  @override
  _BusinessCustomersPageState createState() => _BusinessCustomersPageState();
}

class _BusinessCustomersPageState extends State<BusinessCustomersPage> {
  final businessRequestService = new BusinessRequestService();
  final personProfileService = new PersonProfileService();
  var personProfile = new PersonProfileModel();
  @override
  Widget build(BuildContext context) {
    personProfileService
        .getPersonProfileById(1)
        .then((value) => {personProfile = value});

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Mascotas'),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _createList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createList() {
    return FutureBuilder(
      //future: petService.getAllPetsByPersonId(1),
      future: businessRequestService.getAllRequestByProviderId(1),
      builder:
          (BuildContext context, AsyncSnapshot<List<RequestModel>> snapshot) {
        if (snapshot.hasData) {
          final getRequests = snapshot.data;
          return Expanded(
            child: GridView.builder(
              itemCount: getRequests.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.90),
              itemBuilder: (context, index) =>
                  _createItem(context, getRequests[index]),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, RequestModel request) {
    return Material(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'business_customer_pet',
            arguments: personProfile),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: colorPetCare,
                    radius: 110,
                    child: CircleAvatar(
                      radius: 92,
                      backgroundImage: NetworkImage(personProfile.photo),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  personProfile.document,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
