import 'package:flutter/material.dart';

class EditingCustomCaption extends StatefulWidget {
  const EditingCustomCaption({Key? key}) : super(key: key);

  @override
  State<EditingCustomCaption> createState() => _EditingCustomCaptionState();
}

class _EditingCustomCaptionState extends State<EditingCustomCaption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        title: Text("Editing Custom Caption"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextField(
            decoration: InputDecoration(
                focusColor: Colors.grey,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                hintText: "Enter Custom Caption",
                contentPadding: EdgeInsets.only(left: 10)),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 125, 64, 121)),
                        onPressed: () {},
                        child: const Text(
                          "Insert Original\nUsername",
                          textAlign: TextAlign.center,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                                        height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 125, 64, 121)),
                        onPressed: () {},
                        child: const Text(
                          "Insert Original\nCaption",
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 68, right: 68),
                child: SizedBox(
                  
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 73, 65, 125)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Save"))),
              ),
              SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
