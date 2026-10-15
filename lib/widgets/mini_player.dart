import 'package:flutter/material.dart';

import '../player_state.dart';
import '../screens/now_playing_screen.dart';
import '../theme.dart';
import 'album_art.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        final track = player.track;
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Material(
            color: AppColors.grayLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.line),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => openNowPlaying(context),
              child: SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 4),
                  child: Row(
                    children: [
                      AlbumArt(style: track.art, size: 44, radius: 8),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              track.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.grayText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: player.playing ? 'Jeda' : 'Putar',
                        iconSize: 30,
                        color: AppColors.ink,
                        onPressed: player.togglePlay,
                        icon: Icon(
                          player.playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Berikutnya',
                        iconSize: 30,
                        color: AppColors.ink,
                        onPressed: player.next,
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
