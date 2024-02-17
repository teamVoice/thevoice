import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:thevoice2/Models/VideoData.dart';
import 'package:thevoice2/SystemUiValues.dart';

import 'customPlayer.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.videoData});

  final VideoData videoData;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late BetterPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoDispose: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            controlsHideTime: const Duration(seconds: 1),
            playerTheme: BetterPlayerTheme.custom,
            customControlsBuilder:
                (videoController, onPlayerVisibilityChanged) =>
                    CustomPlayerControl(controller: videoController),
          ),
          aspectRatio: 16 / 9,
          looping: true,
          autoPlay: true),
      betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
        widget.videoData.videoUrl
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.videoData.title,
              style: SystemUi.profilePagePTextStyle,
            ),
            backgroundColor: SystemUi.systemColor,
          ),
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _videoController),
            ),
          )
        ],
      ),
    );
  }
}


