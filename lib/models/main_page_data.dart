import 'package:movie_app/models/search_category.dart';

import 'movie.dart';

class MainPageData{
  final List<Movie> movies;
  final int page;
  final String category;
  final String searchText;
  final int resultCount;

  MainPageData({required this.movies,required this.page,required this.category,required this.searchText,required this.resultCount});

  MainPageData.inital() : movies = [],page = 1 , category = SearchCategory.nowPlaying , searchText = '' , resultCount = 0;

  MainPageData copyWith({
    required List<Movie> movies,
    required int page,
    required String category,
    required String searchText,
    required int resultCount
  }){
    return MainPageData(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        category: category ?? this.category ,
        searchText: searchText ?? this.searchText,
        resultCount: resultCount ?? this.resultCount
    );
  }
}