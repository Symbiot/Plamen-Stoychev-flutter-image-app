import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../base/data_source/SharedPreferencesInstance.dart';

class ImageSinglePage extends StatefulWidget {
  final Map<String, dynamic> imageData;
  const ImageSinglePage({super.key, required this.imageData});

  @override
  State<ImageSinglePage> createState() => _ImageSinglePageState();
}

class _ImageSinglePageState extends State<ImageSinglePage> {

  late SharedPreferencesInstance sPrefs;
  late bool itemIsFavorite;

  @override
  void initState() {
    sPrefs = context.read<SharedPreferencesInstance>();
    _isFavorite();
    super.initState();
  }

  // Set image as favorite
  Future<void> _setAsFavorite() async {
    await sPrefs.addToFavorite(widget.imageData);
  }

  // Removes image from favorite
  Future<void> _removeFromFavorite() async {
    await sPrefs.removeFromFavorite(widget.imageData['id']);
  }

  // Check image in favorite list
  Future<bool> _isFavorite() async {
    return  await sPrefs.isFavorite(widget.imageData['id']);
  }

  // Set/Unset as favorite
  void _changeFavorite(bool switchFavorite) async{
    (!switchFavorite) ? await _setAsFavorite() : await _removeFromFavorite();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    var title = 'Web Image';
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
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.imageData['largeImageURL'],
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),
              Text(
                widget.imageData['user'],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  decorationThickness: 0.4,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationColor: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.orangeAccent,
                      offset: Offset(4, 4),
                      blurRadius: 11,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Likes: ${widget.imageData['likes']}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        floatingActionButton: FutureBuilder<bool>(
            future: _isFavorite(),
            builder: (ctx, AsyncSnapshot<bool>snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              } else if (snapshot.hasData){
                return FloatingActionButton(
                  backgroundColor: Colors.yellow,
                  onPressed: () {
                    _changeFavorite(snapshot.data!);
                  },
                  tooltip: 'Add to favorites',
                  child: (snapshot.data!) ?  const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite, color: Colors.white,),
                );
              } else {
                return Text("Error: ${snapshot.error}");
              }
            }
        )
      ),
    );
  }
}