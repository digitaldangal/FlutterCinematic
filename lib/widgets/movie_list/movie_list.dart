import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/widgets/movie_list/movie_list_item.dart';

class MediaList extends StatefulWidget {
  MediaList(this.provider, this.category, {Key key})
      : super(key: key);

  final MediaProvider provider;
  final String category;

  @override
  _MediaListState createState() => new _MediaListState();
}

class _MediaListState extends State<MediaList> {

  List<MediaItem> _movies;
  int _pageNumber = 1;

  _loadNextPage() async {
    _pageNumber++;
    try {
      var nextMovies = await widget.provider.loadMedia(widget.category, page: _pageNumber);
      _movies.addAll(nextMovies);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        initState: () async =>
        await widget.provider.loadMedia(widget.category),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) =>
        new Text('Sorry, there was an error loading your movie'),
        renderSuccess: ({data}) {
          _movies = data;

          return new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index > (_movies.length * 0.7)) {
                  _loadNextPage();
                }

                return new MovieListItem(_movies[index]);
              });
        }
    );

    return new Center(
        child: _asyncLoader
    );
  }
}