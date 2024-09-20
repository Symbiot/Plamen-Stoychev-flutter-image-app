import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base/data_source/SharedPreferencesInstance.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<dynamic> _imageList = [];
  late SharedPreferencesInstance sPrefs;


  @override
   initState()  {
    sPrefs = context.read<SharedPreferencesInstance>();
    _getAllFavorites();
    super.initState();
  }

  Future<void> _getAllFavorites() async {
    List<String> imageList = await sPrefs.getAllFavorites();
    setState(() {
      _imageList.addAll(imageList);
    });
  }




  @override
  Widget build(BuildContext context) {
    var title = 'Favorites';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: const TextStyle(color: Colors.white),),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: GridView.builder(
            shrinkWrap: true,
            itemCount: _imageList.length,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      json.decode(_imageList.elementAt(index))['previewURL']),
                                  fit: BoxFit.cover))));
            })),
    );
  }
}
