import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_streaming_app/models/movie_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class DownloadManager with ChangeNotifier {
  static final Dio dio = Dio();
  static const _MOVIE_FOLDER = 'movies';

  static DownloadManager? _instance;

  static DownloadManager get instance => _instance ?? DownloadManager._();

  DownloadManager._();

  final List<MovieModel> _downloadingMovies = [];

  final HashMap<String, PublishSubject<double>> _movieProgress = HashMap();
  BehaviorSubject<int> onUpdate = BehaviorSubject();

  Stream<double>? getMovieDownloadProgress(MovieModel movie) => _movieProgress[movie.id];

  List<MovieModel> get movies => _downloadingMovies;

  Future<Directory> _getMovieDirectory() async {
    log("Directory initialized");
    Directory movieDirectory = Directory(join((await getTemporaryDirectory()).path, _MOVIE_FOLDER));
    movieDirectory.createSync();
    return movieDirectory;
  }

  // void removeMovie(MovieModel movie) {
  //   var id = movie.id;
  //   for (var mov in movies) {
  //     if (id == mov.id) {
  //       _downloadingMovies.remove(movie);
  //     }
  //   }
  // }

  bool downloadMovie(MovieModel movie) {
    if (_downloadingMovies.contains(movie) || _downloadingMovies.length >= 4) return false;
    _download(movie);
    return true;
  }

  Future<void> _download(MovieModel movie) async {
    log('Downloading movie: ${movie.name}');
    Directory movieDirectory = await _getMovieDirectory();

    _downloadingMovies.add(movie);
    log('New movie added. movie count = ${movies.length}');
    onUpdate.add(math.Random().nextInt(100000000));

    File movieFile = File(join(movieDirectory.path, movie.id.toString()));
    if (movieFile.existsSync()) {
      movieFile.deleteSync();
    }
    movieFile.createSync();

    _movieProgress[movie.id] = PublishSubject();
    _movieProgress[movie.id]?.add(12);
    // dio.download(movie.videoUrl, movieFile.path, onReceiveProgress: (cur, fileLength) {
    //   _movieProgress[movie.id]?.add(cur / fileLength);
    //   log('Download in progress: ${movie.name}: ${cur * 1.0 / fileLength}');
    //   if (cur >= fileLength) {
    //     _movieProgress[movie.id]?.close();
    //     _movieProgress.remove(movie.id);
    //   }
    // });
  }

  // Future<bool> saveVideo(String url, String fileName) async {}

// 1232_finish_234234242342
//   ${context.watch<Counter>().count()   => view variable
// context.read<Counter>().increment(),
}
