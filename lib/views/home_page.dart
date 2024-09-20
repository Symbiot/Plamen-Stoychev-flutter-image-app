import 'package:flutter/material.dart';
import 'package:plm_image_app/views/components/custom_app_bar.dart';
import 'package:plm_image_app/views/components/image_grid_view.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        child: const ImageGridView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
        },
        tooltip: 'Favorites',
        child: const Icon(Icons.favorite_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}