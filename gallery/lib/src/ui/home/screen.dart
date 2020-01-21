import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/src/classes/sources.dart';
import 'package:url_launcher/url_launcher.dart';

const kUrl = 'https://github.com/Solido/awesome-flutter';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Sources _sources;
  int _index = 0;

  @override
  void initState() {
    rootBundle.loadString("assets/source.json").then((data) {
      if (mounted)
        setState(() {
          _sources = sourcesFromJson(data);
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome Flutter"),
        actions: <Widget>[
          IconButton(
            tooltip: "View Website",
            icon: Icon(Icons.web),
            onPressed: () => launch(kUrl),
          ),
        ],
      ),
      body: _sources == null
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _index,
              children: <Widget>[
                _buildSources(),
                _buildAuthors(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (val) {
          if (mounted) setState(() => _index = val);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            title: Text("Sources"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text("Authors"),
          )
        ],
      ),
    );
  }

  Widget _buildSources() {
    return ListView.builder(
      itemCount: _sources.sections.length,
      itemBuilder: (context, index) {
        final _source = _sources.sections[index];
        return ExpansionTile(
          leading: IconButton(
            tooltip: "View Website",
            icon: Icon(Icons.web),
            onPressed: () => launch('$kUrl${_source.selector}'),
          ),
          title: Text(_source.name),
          children: _source.sources
              .map((s) => ListTile(
                    title: Text(s.name),
                    subtitle: Text(s.description),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SourceDetails(source: s),
                    )),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildAuthors() {
    return ListView.builder(
      itemCount: _sources.contributors.length,
      itemBuilder: (context, index) {
        final _author = _sources.contributors[index];
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(_author.name),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AuthorDetails(author: _author))),
        );
      },
    );
  }
}

class SourceDetails extends StatelessWidget {
  final Source source;

  const SourceDetails({Key key, @required this.source}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(source.name),
      ),
    );
  }
}

class AuthorDetails extends StatelessWidget {
  final Contributor author;

  const AuthorDetails({Key key, @required this.author}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(author.name),
      ),
    );
  }
}
