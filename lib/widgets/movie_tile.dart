import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double width, height;
  final Movie movie;

  MovieTile({required this.width, required this.height, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie,)
        ));
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_moviePosterWidget(movie.posterUrl()), _movieInfo()],
        ),
      ),
    );
  }

  Widget _moviePosterWidget(String posterUrl) {
    print(posterUrl);
    if(posterUrl == "null"){
      return Container(
        height: height,
        width: width * 0.35,
        child: const Image(
            image: AssetImage("assets/images/no_image.png"),
          fit: BoxFit.cover,
        ),
      );
    }else{
      return Container(
        height: height,
        width: width * 0.35,
        decoration:
        BoxDecoration(image: DecorationImage(image: NetworkImage(posterUrl))),
      );
    }

  }

  Widget _movieInfo() {
    return Container(
      height: height,
      width: width * 0.62,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.30,
                child: Text(
                  movie.name.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                double.parse(movie.rating.toStringAsFixed(1)).toString(),
                style: const TextStyle(color: Colors.white, fontSize: 22),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              '${movie.language.toString().toUpperCase()} | R: ${movie.isAdult} | ${movie.releaseDate}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              movie.description.toString(),
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
