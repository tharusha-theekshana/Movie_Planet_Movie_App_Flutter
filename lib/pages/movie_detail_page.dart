import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  MovieDetailPage({required this.movie});

  final Movie movie;

  late double _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      child: Stack(
        children: [
          Container(
            width: _deviceWidth,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      movie.posterUrl().toString(),
                    ),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              width: _deviceWidth,
              height: _deviceHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _movieName(movie.name.toString()),
                  _movieImage(movie.posterUrl()),
                  _movieDetails(),
                  _movieReleasedDate(movie.releaseDate.toString()),
                  _movieDescription(movie.description.toString()),
                  _movieDownloadLink(movie.name.toString())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _movieName(String name) {
    return Padding(
      padding: EdgeInsets.only(left: _deviceWidth * 0.01,right: _deviceWidth * 0.01),
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 27.0, color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _movieDescription(String des) {
    return Padding(
      padding: EdgeInsets.only(left: _deviceWidth * 0.03,right: _deviceWidth * 0.03),
      child: Text(
        des.toString(),
        style: const TextStyle(
            fontSize: 14.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _movieReleasedDate(String date) {
    return Padding(
      padding: EdgeInsets.only(left: _deviceWidth * 0.01,right: _deviceWidth * 0.01),
      child: Text(
        "Release Date : ${date.toString()}",
        style: const TextStyle(
            fontSize: 14.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _movieImage(String url) {
    return Container(
      height: _deviceHeight * 0.35,
      width: _deviceWidth * 0.45,
      decoration:
      BoxDecoration(image: DecorationImage(image: NetworkImage(url))),
    );
  }

  Widget _movieDetails(){
    return Container(
      width: _deviceWidth * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _movieRating(movie.rating),
          _movieIsAdult(movie.isAdult),
          _movieLanguage(movie.language.toString().toUpperCase())
        ],
      ),
    );
  }

  Widget _movieRating(double rate) {
    if (rate > 5.0) {
      return Container(
        height: _deviceHeight * 0.035,
        width: _deviceWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                rate.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: _deviceHeight * 0.035,
        width: _deviceWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.red,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rate.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _movieLanguage(String lang) {
      return Container(
        height: _deviceHeight * 0.035,
        width: _deviceWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.red,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lang.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
              ),
            ),
          ],
        ),
      );
  }

  Widget _movieIsAdult(bool adult){
    if(adult == true){
      return Container(
        height: _deviceHeight * 0.035,
        width: _deviceWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "18+",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
              ),
            ),
          ],
        ),
      );
    }else{
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget _movieDownloadLink(String movieName) {

    String url = "https://yts.mx/browse-movies/$movieName/all/all/0/latest/0/all";

    return InkWell(
      child: Container(
        height: _deviceHeight * 0.07,
        width: _deviceWidth * 0.45,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Download Torrent',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            Icon(Icons.download,color: Colors.white,)
          ],
        ),
      ),
      onTap: () => launchUrlString(url),
    );
  }
}
