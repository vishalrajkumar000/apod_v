import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class POD extends StatelessWidget {
  var data;
  POD({this.data});

  String? getYoutubeVideoId(String Url) {
    RegExp regExp = new RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(Url)?.group(1);
    String? str = match;
    return str;
  }

  @override
  Widget build(BuildContext context) {
    String title = data['title'] ?? "";
    String explanation = data['explanation'] ?? "";
    String credits = data['copyright'] ?? "";
    String date = data['date'] ?? "";
    String type = data['media_type'] ?? "";
    String pic = data['url'] ?? "";
    String hdPic = data['hdurl'] ?? "";

    return SingleChildScrollView(
      child: Column(
        children: [
          title.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    right: 15.0,
                    left: 15.0,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[350],
                      fontSize: 25.0,
                    ),
                  ),
                )
              : Container(),
          explanation.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 7.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    explanation,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              : Container(),
          date.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Picture of the Day : $date",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : Container(),
          credits.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Credits : $credits",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : Container(),
          type == "image"
              ? (hdPic.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 100.0, bottom: 100.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: hdPic,
                          ),
                        ],
                      ),
                    )
                  : Image.network(pic))
              : YoutubePlayerIFrame(
                  controller: YoutubePlayerController(
                      initialVideoId: getYoutubeVideoId(pic) as String,
                      params: YoutubePlayerParams(
                          autoPlay: false, showFullscreenButton: true)),
                ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
