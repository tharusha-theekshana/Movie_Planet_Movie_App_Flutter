import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/search_category.dart';
import 'package:movie_app/service/movie_service.dart';

import '../models/movie.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.inital()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];
      int _result = 0;

      if (state.searchText.isEmpty) {
        if (state.category == SearchCategory.popular) {
          _movies = await _movieService.getPopularMovies(page: state.page);
          _result = await _movieService.getPopularMoviesResult(page: state.page);

        } else if (state.category == SearchCategory.upcoming) {
          _movies = await _movieService.getUpcomingMovies(page: state.page);
          _result = await _movieService.getUpcomingMoviesResult(page: state.page);

        } else if (state.category == SearchCategory.nowPlaying) {
          _movies = await _movieService.getNowPlayingMovies(page: state.page);
          _result = await _movieService.getNowPlayingMoviesResult(page: state.page);

        } else if (state.category == SearchCategory.topRated) {
          _movies = await _movieService.getTopRatedMovies(page: state.page);
          _result = await _movieService.getTopRatedMoviesResult(page: state.page);

        } else if (state.category == SearchCategory.none) {
          _movies = [];
          _result = 0;
        }
      } else {
        _movies = await _movieService.searchMovie(state.searchText, state.page);
        _result = await _movieService.searchMovieResult(state.searchText, state.page);
      }

      state = state.copyWith(
          movies: [...state.movies, ..._movies],
          page: state.page + 1,
          category: state.category,
          searchText: state.searchText,
          resultCount: _result
      );
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          category: _category,
          searchText: '',
          resultCount: 0);
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          category: SearchCategory.none,
          searchText: _searchText,
          resultCount: 0);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
