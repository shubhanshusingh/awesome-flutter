import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/src/classes/sources.dart';
import 'package:url_launcher/url_launcher.dart';

const kUrl = 'https://github.com/Solido/awesome-flutter';
const kBreakpoint = 720.0;

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
    return Material(
      child: LayoutBuilder(
        builder: (_, dimens) {
          if (dimens.maxWidth > kBreakpoint) {
            return Scaffold(
              appBar: _buildAppBar(),
              floatingActionButton: _buildFab(),
              body: Row(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: _buildAuthors(),
                  ),
                  Expanded(
                    child: _buildSources(),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: _buildAppBar(),
            floatingActionButton: _buildFab(),
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
        },
      ),
    );
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton(
      heroTag: 'search',
      child: Icon(Icons.search),
      onPressed: () {},
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Awesome Flutter"),
      actions: <Widget>[
        IconButton(
          tooltip: "View Website",
          icon: Icon(Icons.web),
          onPressed: () => launch(kUrl),
        ),
      ],
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
          children: _source.sources.map((s) {
            final _authorIds = s.authors.split(",");
            final List<Contributor> contributors = [];
            for (var id in _authorIds) {
              final _author =
                  _sources.contributors.firstWhere((c) => c.id == id);
              if (_author != null) {
                contributors.add(_author);
              }
            }
            return ListTile(
              title: Text(s.name),
              subtitle: Text(s.description),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SourceDetails(
                  source: s,
                  authors: contributors,
                ),
              )),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAuthors() {
    return ListView.builder(
      itemCount: _sources.contributors.length,
      itemBuilder: (context, index) {
        final _author = _sources.contributors[index];
        return AuthorTile(author: _author);
      },
    );
  }
}

class SourceDetails extends StatelessWidget {
  final Source source;
  final List<Contributor> authors;

  const SourceDetails({
    Key key,
    @required this.source,
    this.authors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(source.name),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            initiallyExpanded: true,
            title: Text("Authors"),
            children: authors.map((c) => AuthorTile(author: c)).toList(),
          )
        ],
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

class AuthorTile extends StatelessWidget {
  const AuthorTile({
    Key key,
    @required Contributor author,
  })  : _author = author,
        super(key: key);

  final Contributor _author;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_author.name),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AuthorDetails(author: _author),
      )),
    );
  }
}
