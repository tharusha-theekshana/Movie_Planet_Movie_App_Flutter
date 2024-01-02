import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/service/http_service.dart';

class MovieService {
  final getIt = GetIt.instance;

  HTTPService? _httpService;

  MovieService() {
    _httpService = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response? _response =
        await _httpService!.get('/movie/popular', query: {'page': page , 'include_adult' : true});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response? _response =
        await _httpService!.get('/movie/upcoming', query: {'page': page , 'include_adult' : true});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies');
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int? page}) async {
    Response? _response =
    await _httpService!.get('/movie/now_playing', query: {'page': page , 'include_adult' : true});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load now playing movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies({int? page}) async {
    Response? _response =
    await _httpService!.get('/movie/top_rated', query: {'page': page , 'include_adult' : true});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load now playing movies');
    }
  }

  Future<List<Movie>> searchMovie(String searchText, int page) async {
    Response? _response = await _httpService!
        .get('/search/movie', query: {'query': searchText, 'page': page , 'include_adult' : true});

    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _moviesSearch = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _moviesSearch;

    } else {
      throw Exception('Couldn\'t load search movies');
    }
  }

  Future<int> getPopularMoviesResult({int? page}) async {
    Response? _response = await _httpService!.get('/movie/popular', query: {'page': page});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      int _result = _data['total_results'];
      return _result;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }

  Future<int> getUpcomingMoviesResult({int? page}) async {
    Response? _response = await _httpService!.get('/movie/upcoming', query: {'page': page});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      int _result = _data['total_results'];
      return _result;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }

  Future<int> getNowPlayingMoviesResult({int? page}) async {
    Response? _response = await _httpService!.get('/movie/now_playing', query: {'page': page});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      int _result = _data['total_results'];
      return _result;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }

  Future<int> getTopRatedMoviesResult({int? page}) async {
    Response? _response = await _httpService!.get('/movie/top_rated', query: {'page': page});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      int _result = _data['total_results'];
      return _result;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }

  Future<int> searchMovieResult(String searchText, int page) async {
    Response? _response = await _httpService!
        .get('/search/movie', query: {'query': searchText, 'page': page});

    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      int _result = _data['total_results'];
      return _result;
    } else {
      throw Exception('Couldn\'t load popular movies');
    }
  }
}
