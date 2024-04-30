import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

class InstagramVideoThumbnail extends StatefulWidget {
  final String videoUrl;

  InstagramVideoThumbnail(this.videoUrl);

  @override
  _InstagramVideoThumbnailState createState() => _InstagramVideoThumbnailState();
}

class _InstagramVideoThumbnailState extends State<InstagramVideoThumbnail> {
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _fetchThumbnailUrl();
  }

  Future<void> _fetchThumbnailUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.videoUrl));
      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        final metaTags = document.getElementsByTagName('meta');
        for (var tag in metaTags) {
          final property = tag.attributes['property'];
          if (property == 'og:image') {
            setState(() {
              _thumbnailUrl = tag.attributes['content'];
            });
            break;
          }
        }
      } else {
        throw 'Failed to load webpage';
      }
    } catch (e) {
      print('Error fetching video thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchInstagram();
      },
      child: _thumbnailUrl != null
          ? Image.network(_thumbnailUrl!, fit: BoxFit.cover)
          : CircularProgressIndicator(),
    );
  }

  void _launchInstagram() async {
    String url = 'https://www.instagram.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}