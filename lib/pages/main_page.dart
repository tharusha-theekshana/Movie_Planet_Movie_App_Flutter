import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/controllers/main_page_data_controller.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/search_category.dart';
import 'package:movie_app/widgets/movie_tile.dart';

import '../models/movie.dart';


final mainPageDataControllerProvider = StateNotifierProvider<MainPageDataController>((ref) {
  return MainPageDataController();
});

final selectMoviePosterUrlProvider = StateProvider<String>((ref) {
  final _movies = ref.watch(mainPageDataControllerProvider.state).movies;
  return _movies.length != 0 ? _movies[0].posterUrl().toString() : "";
});

class MainPage extends ConsumerWidget {
  late double _deviceWidth, _deviceHeight;

  var _selectMoviePosterURL;

  TextEditingController? _searchController;
  MainPageDataController? _mainPageDataController;
  late MainPageData _mainPageData;


  @override
  Widget build(BuildContext context, ScopedReader watch) {

    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    _searchController = TextEditingController();

    _mainPageDataController = watch(mainPageDataControllerProvider);
    _mainPageData = watch(mainPageDataControllerProvider.state);

    _searchController!.text = _mainPageData!.searchText;

    _selectMoviePosterURL = watch(selectMoviePosterUrlProvider).state;

    return _buildUI();

  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [_backgroundWidget(), _foregroundWidgets()],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    if(_selectMoviePosterURL != '') {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                _selectMoviePosterURL,
              ),
              fit: BoxFit.cover,
            )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
          ),
        ),
      );
    }else{
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          0, _deviceHeight * 0.02, 0, _deviceHeight * 0.01),
      width: _deviceWidth * 0.88,
      height:_deviceHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          _movieResults(),
          _filmsList()
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectWidget()
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    return Container(
      width: _deviceWidth * 0.5,
      height: _deviceHeight * 0.05,
      child: TextField(
        style: const TextStyle(
            color: Colors.white
        ),
        controller: _searchController,
        onSubmitted: (_input) => _mainPageDataController!.updateTextSearch(_input),
        decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search ....'
        ),
      ),
    );
  }

  Widget _categorySelectWidget() {
    return DropdownButton(
      items: const [
        DropdownMenuItem(
          value: SearchCategory.nowPlaying,
          child: Text(
            SearchCategory.nowPlaying,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.topRated,
          child: Text(
            SearchCategory.topRated,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        DropdownMenuItem(
            value: SearchCategory.popular,
            child: Text(
              SearchCategory.popular,
              style: TextStyle(
                color: Colors.white
              ),
            ),
        ),
        DropdownMenuItem(
            value: SearchCategory.upcoming,
            child: Text(
              SearchCategory.upcoming,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ],
      onChanged: (value) =>
        value.toString().isNotEmpty ? _mainPageDataController!.updateSearchCategory(value.toString()) : null
      ,
      dropdownColor: Colors.black38,
      value: _mainPageData!.category,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }
  
  Widget _movieResults(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: _deviceHeight * 0.02 , bottom: _deviceHeight * 0.02),
          child: Text("Results : ${_mainPageData.resultCount}" , style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white54
          ),),
        )
      ],
    );
  }

  Widget _filmsList() {
    return Container(
      height: _deviceHeight * 0.82,
      child: _movieList(),
    );
  }

  Widget _movieList() {
    final List<Movie> _movies = _mainPageData.movies;

    if(_movies.length != 0){
      return NotificationListener(
        onNotification: (scrollNotification) {
          if(scrollNotification is ScrollEndNotification){
            final before = scrollNotification.metrics.extentBefore;
            final max = scrollNotification.metrics.maxScrollExtent;
            if( before == max){
              _mainPageDataController!.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight * 0.01,
                  horizontal: 0
                ),
              child: GestureDetector(
                onTap: () {
                  // print("Print" + _movies[index].posterUrl());
                  // _selectMoviePosterURL = _movies[index].posterUrl().toString();
                },
                child: MovieTile(
                  movie: _movies[index],
                  width: _deviceWidth * 0.85,
                  height: _deviceHeight* 0.21,
                ),
              ),
            );
          },
        ),
      );
    }else{
      return const Center(
        child: Text("No Movies Found", style: TextStyle(
          color: Colors.white,
          fontSize: 17.0
        ),),
      );
    }

  }
}



