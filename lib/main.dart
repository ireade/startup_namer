import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions()
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {

        if (i.isOdd) return Divider();

        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  void _pushSaved () {
    Navigator.of(context).push(

      new MaterialPageRoute<void>(
        builder: (BuildContext context) {

          final tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(pair.asPascalCase, style: _biggerFont),
              );
            },
          );

          final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
          
          return new Scaffold(
            appBar: new AppBar(title: Text('Saved Suggestions')),
            body: new ListView(children: divided),
          );

        }
      ) 
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
