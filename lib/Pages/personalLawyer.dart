import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thevoice2/SystemUiValues.dart';

class PersonalLawyer extends StatefulWidget {
  const PersonalLawyer({super.key});

  @override
  State<PersonalLawyer> createState() => _PersonalLawyerState();
}

class _PersonalLawyerState extends State<PersonalLawyer> {
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  var lawyersRef = FirebaseFirestore.instance.collection('Lawyers');
  late List<Map<String, dynamic>> result;

  bool isLoaded = false;

  Future getLawyer() async {
    if (cityValue == "" || stateValue == "" || cityValue == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          SystemUi.NormalSnackBar(title: "Please select all the fields"));
    } else {
      print(countryValue);
      print(stateValue);
      print(cityValue);

      List<Map<String, dynamic>> temp = [];
      try {
        var data = await lawyersRef
            .where("state", isEqualTo: stateValue)
            .where("city", isEqualTo: cityValue)
            .get();

        data.docs.forEach((element) {
          temp.add(element.data());
        });

        setState(() {
          isLoaded = true;
          result = temp;
        });
      } on FirebaseFirestore catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SystemUi.systemColor,
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Personal Lawyer", style: SystemUi.headerTextStyle)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find your personal lawyer",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CSCPicker(
                    ///Enable disable state dropdown [OPTIONAL PARAMETER]
                    showStates: true,

                    /// Enable disable city drop down [OPTIONAL PARAMETER]
                    showCities: true,

                    ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]

                    ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(color: Colors.green, width: 1)),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.black, width: 1)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",

                    ///Default Country

                    ///Disable country dropdown (Note: use it with default country)
                    //disableCountry: true,

                    ///Country Filter [OPTIONAL PARAMETER]

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 10.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 10.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value.trim();
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value;
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: CupertinoButton(
                  child: Text("Find"),
                  onPressed: getLawyer,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple,
                )),
                const SizedBox(
                  height: 20,
                ),
                isLoaded
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = result[index];
                          return ListTile(
                            title: Text(data['name']),
                            leading: Icon(Icons.person),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: ${data['email']}"),
                                Text("Phone: ${data['phone']}"),
                                Text("Qualification: ${data['qualification']}")
                              ],
                            ),
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black, width: 1),
                            ),
                            style: ListTileStyle.drawer,
                          );
                        },
                        itemCount: result.length,
                      )
                    : Center(
                        child: Container(
                          height: 300,
                          child: Image(
                            image: AssetImage("images/searchImage.jpg"),
                            colorBlendMode: BlendMode.multiply,
                            color: SystemUi.systemColor,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ));
  }
}
