import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/http_client/http_client.dart';
import '../../base/notifiers/search_value_notifier.dart';
import '../image_single_page.dart';

class ImageGridView extends StatefulWidget {
  const ImageGridView({super.key});

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  final ScrollController _scrollController = ScrollController();
  String searchValue = '';
  int _currentPage = 1;
  final _imageList = <dynamic>[];

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    fetchGalleryData(_currentPage);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      fetchGalleryData(_currentPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchValueProvider>(
      builder: (context, searchQuery, child) {
        if (searchQuery.searchValue.compareTo(searchValue) != 0) {
          searchValue = searchQuery.searchValue;
          _currentPage = 1;
          _imageList.clear();
          fetchGalleryData(_currentPage);
        }
        return Center(
            child: (_imageList.isNotEmpty && _imageList.first.containsKey('error'))? Text(
                "${_imageList.first['error']}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                )
            ) : GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _imageList.length,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageSinglePage(
                                    imageData: _imageList[index])));
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          _imageList[index]['previewURL']),
                                      fit: BoxFit.cover)))));
                }));
      },
    );
  }

  // Fetch image list from server
  Future<void> fetchGalleryData(int page) async {
    Map imageData = {};
    Map<String, dynamic> queryParameters = {
      'q': 'all',
      'page': page,
      'per_page': 30
    };
    if (searchValue.isNotEmpty) queryParameters['q'] = searchValue;
    try {
      imageData = await context.read<HttpClient>().getImageData(queryParameters);
      _imageList.addAll(imageData['hits']);
    } catch (e) {
      _imageList.add({'error': 'Error! Cannot load images from server.'});
    }

    setState(() {});
  }
}
