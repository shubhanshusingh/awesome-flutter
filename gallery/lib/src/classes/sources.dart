// To parse this JSON data, do
//
//     final sources = sourcesFromJson(jsonString);

import 'dart:convert';

Sources sourcesFromJson(String str) => Sources.fromJson(json.decode(str));

String sourcesToJson(Sources data) => json.encode(data.toJson());

class Sources {
  String version;
  List<Section> sections;
  List<Contributor> contributors;

  Sources({
    this.version,
    this.sections,
    this.contributors,
  });

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        version: json["version"],
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
        contributors: List<Contributor>.from(
            json["contributors"].map((x) => Contributor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
        "contributors": List<dynamic>.from(contributors.map((x) => x.toJson())),
      };
}

class Contributor {
  String id;
  String name;
  String email;
  String twitter;
  String facebook;
  String instagram;
  String website;
  String github;

  Contributor({
    this.id,
    this.name,
    this.email,
    this.twitter,
    this.facebook,
    this.instagram,
    this.website,
    this.github,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        website: json["website"],
        github: json["github"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "twitter": twitter,
        "facebook": facebook,
        "instagram": instagram,
        "website": website,
        "github": github,
      };
}

class Section {
  String name;
  String selector;
  List<Source> sources;

  Section({
    this.name,
    this.selector,
    this.sources,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        name: json["name"],
        selector: json["selector"],
        sources:
            List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "selector": selector,
        "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
      };
}

class Source {
  String name;
  String description;
  String pub;
  String source;
  String authors;
  String demo;

  Source({
    this.name,
    this.description,
    this.pub,
    this.source,
    this.authors,
    this.demo,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
        description: json["description"],
        pub: json["pub"],
        source: json["source"],
        authors: json["authors"],
        demo: json["demo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "pub": pub,
        "source": source,
        "authors": authors,
        "demo": demo,
      };
}
