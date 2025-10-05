import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/buttons.dart';
import '../res/colors.dart';
import '../utils/theme.dart';
import '../utils/routes/routesName.dart';
import 'notes.dart';


class EntryScreen extends StatefulWidget{
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  final List<Color> notesColors =[
    Color(0xFFEEC1D7),
    Color(0xFFC1DDF3),
    Color(0xFFAFDFAE),
    Color(0xFFF2E899),
    Color(0xFFC6B4DD),
    Color(0xFFEC9596),
  ];


  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final containerColor = Theme.of(context).cardColor;
    final iconsColor = Theme.of(context).hintColor;
    final user = FirebaseAuth.instance.currentUser;


    return Scaffold(

      appBar:  AppBar(

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: containerColor),
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: IconButton(onPressed: ()  {
                showDialog<void>(
                  context: context,
                  barrierDismissible:false,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[

                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () async {

                            await FirebaseAuth.instance.signOut();
                            if(mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesName.login,
                                    (route) => false,
                              );
                            }

                          },
                        ),
                      ],
                    );
                  },
                );
              }, icon: Icon(Icons.logout_outlined,size: 24,color: iconsColor)),
            ),
          ),
        ),
        title: Text("Notes",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color:iconsColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: containerColor),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: IconButton(onPressed: (){
                    if(themeChanger.themeMode == ThemeMode.light){
                      themeChanger.setTheme(ThemeMode.dark);
                    }else{
                      themeChanger.setTheme(ThemeMode.light);
                    }

                  }, icon: Icon(themeChanger.themeMode ==ThemeMode.light?Icons.dark_mode:Icons.light_mode,size: 24,color: iconsColor,)),
                ),
              ),
                SizedBox(width: 10,),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:containerColor),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: IconButton(onPressed: (){

                    }, icon: Icon(Icons.bookmark,size: 24,color: iconsColor,)),
                  ),
                ),],

            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('notes').orderBy('createdAt', descending: true).snapshots(),  builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError){
              return Center(child: Text("Something went wrong."),);
            }
            if(!snapshot.hasData||snapshot.data!.docs.isEmpty||user==null){
              return Center(
                child: Text("No Notes to display. \nTap the '+' button to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,color: iconsColor),),
              );
            }
            else{
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ( context, index) {
                    var noteDoc = snapshot.data!.docs[index];
                    Map<String, dynamic> note = noteDoc.data() as Map<String, dynamic>;
                    final color = notesColors[index % notesColors.length];
                    final String title= note['title']??"Untitled";
                    final String description= note['description']??"";
                    return Container(
                      margin: EdgeInsets.only(  left: 10, top: 15, right: 10, bottom: 15),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: color,),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title.isEmpty ? 'Untitled' : title, style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),
                                maxLines: 1,overflow: TextOverflow.ellipsis,),SizedBox(height: 1,),
                              if(description.isNotEmpty)...[
                                const SizedBox(height: 2,),

                                Text(description, style: TextStyle(fontSize: 20,color:Colors.black),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,)
                              ]

                            ]

                        ),
                      ),
                    );

                  }
              );
            }

          }
      ),

floatingActionButton: Padding(
  padding: const EdgeInsets.all(40.0),
  child: FloatingActionButton(
    onPressed: (){
      Navigator.pushNamed(context, RoutesName.notes);
    },
    backgroundColor: containerColor,
    child: Icon(Icons.add,color: iconsColor,),),
)


    );

  }
}