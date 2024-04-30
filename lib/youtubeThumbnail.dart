import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoUrl;
  final String videoId;

  YouTubeThumbnail(this.videoUrl)
      : videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchYouTubeVideo(videoId);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            'https://img.youtube.com/vi/$videoId/0.jpg',
            fit: BoxFit.cover,
          ),
          Icon(
            Icons.play_circle_outline,
            color: Colors.white,
            size: 50.0,
          ),
        ],
      ),
    );
  }

  void _launchYouTubeVideo(String videoId) async {
    String url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}