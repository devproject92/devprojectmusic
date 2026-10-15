import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../player_state.dart';
import '../theme.dart';
import '../widgets/album_art.dart';
import '../widgets/volume_pill.dart';

/// Membuka layar Sedang Diputar dengan transisi naik dari bawah.
void openNowPlaying(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const NowPlayingScreen(),
      transitionsBuilder: (_, animation, __, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    ),
  );
}

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: player,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, c) {
                  final art = math.min(c.maxWidth - 40, c.maxHeight * 0.4);
                  final track = player.track;
                  final artStyle =
                      track.art == ArtStyle.dot ? ArtStyle.rings : track.art;

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 44,
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Tutup pemutar',
                                    iconSize: 32,
                                    color: Colors.white,
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Center(
                                      child: Text(
                                        'SEDANG DIPUTAR',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                          color: AppColors.lightText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Opsi lainnya',
                                    color: Colors.white,
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_horiz_rounded),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            AlbumArt(
                              style: artStyle,
                              size: art,
                              radius: 24,
                              borderColor: AppColors.darkTrack,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        track.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          height: 1.25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        track.artist,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: AppColors.lightText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: AppColors.darkCard,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    tooltip: 'Sukai lagu',
                                    color: Colors.white,
                                    onPressed: player.toggleLike,
                                    icon: Icon(
                                      player.liked
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: AppColors.darkTrack,
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                  elevation: 0,
                                  pressedElevation: 0,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: player.elapsed.toDouble(),
                                min: 0,
                                max: PlayerState.duration.toDouble(),
                                onChanged: player.seek,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatTime(player.elapsed),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.lightText,
                                    ),
                                  ),
                                  Text(
                                    '-${formatTime(PlayerState.duration - player.elapsed)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.lightText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  tooltip: 'Acak',
                                  iconSize: 24,
                                  color: player.shuffle
                                      ? Colors.white
                                      : AppColors.lightText,
                                  onPressed: player.toggleShuffle,
                                  icon: const Icon(Icons.shuffle_rounded),
                                ),
                                IconButton(
                                  tooltip: 'Sebelumnya',
                                  iconSize: 38,
                                  color: Colors.white,
                                  onPressed: player.previous,
                                  icon: const Icon(Icons.skip_previous_rounded),
                                ),
                                Semantics(
                                  button: true,
                                  label: player.playing ? 'Jeda' : 'Putar',
                                  child: Material(
                                    color: Colors.white,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: player.togglePlay,
                                      child: SizedBox(
                                        width: 72,
                                        height: 72,
                                        child: Icon(
                                          player.playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 42,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Berikutnya',
                                  iconSize: 38,
                                  color: Colors.white,
                                  onPressed: player.next,
                                  icon: const Icon(Icons.skip_next_rounded),
                                ),
                                IconButton(
                                  tooltip: 'Ulangi',
                                  iconSize: 24,
                                  color: player.repeat
                                      ? Colors.white
                                      : AppColors.lightText,
                                  onPressed: player.toggleRepeat,
                                  icon: const Icon(Icons.repeat_rounded),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  tooltip: 'Lirik',
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Perangkat',
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: const Icon(Icons.speaker_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Antrean',
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: const Icon(Icons.queue_music_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const Positioned(
                        right: 14,
                        top: 64,
                        child: VolumePill(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
