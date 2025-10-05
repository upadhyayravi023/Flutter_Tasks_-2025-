import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/colors.dart';
import '../utils/routes/routesName.dart';
import 'package:notes_app/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';



class Notes extends StatefulWidget{
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _titleController= TextEditingController();
  final TextEditingController _descriptionController= TextEditingController();
  bool _isSaving =false;
  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
  Future<void> _saveNote() async{
if (_isSaving) return;
final title = _titleController.text.trim();
final description = _descriptionController.text.trim();
final user = FirebaseAuth.instance.currentUser;

if (user == null || (title.isEmpty && description.isEmpty)) {
  Navigator.pop(context);
  return;
}

setState(()=>_isSaving=true);
try{
  final collectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('notes');

await collectionRef.add({
  'title':title,
  'description':description,
  'createdAt':Timestamp.now(),

});
if(mounted){
  Navigator.pop(context);
}
}catch(e){
  if (mounted) {
    Utils.flushBarErrorMessage(e.toString(), context);
  }
}finally{
  if (mounted) {
    setState(() => _isSaving = false);
  }
}
 }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
 final containerColor = Theme.of(context).cardColor;
 final iconsColor = Theme.of(context).hintColor;
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
    child: IconButton(onPressed: (){

    Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_outlined,size: 24,color: iconsColor,)),
    ),
    ),
    ),

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: containerColor),
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child:
              _isSaving? Padding(padding: const EdgeInsets.all(12.0),child: CircularProgressIndicator(strokeWidth: 2,color: iconsColor,),):IconButton(
                  onPressed: _saveNote,
              icon: Icon(Icons.save_alt_outlined,size: 24,color:iconsColor ,)),
            ),
          ),],

      ),
    )
  ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          children: [
            TextField(

              controller: _titleController,
              maxLines: 1,
              style: TextStyle(fontSize: 50, color: iconsColor),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: "Title..",
                hintStyle: TextStyle(fontSize: 50, color: containerColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: containerColor),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _descriptionController,
                style: TextStyle(fontSize: 30, color: iconsColor),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: "Type Something...",
                  hintStyle: TextStyle(fontSize: 20,color: containerColor),
                  border: InputBorder.none,
                ),
              ),
            )
          ],



        ),
      ),



    );

  }
}