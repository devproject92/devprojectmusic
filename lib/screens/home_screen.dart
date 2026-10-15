import 'package:flutter/material.dart';

import '../data.dart';
import '../player_state.dart';
import '../theme.dart';
import '../widgets/album_art.dart';
import 'now_playing_screen.dart';

void _play(BuildContext context, int index) {
  player.select(index);
  openNowPlaying(context);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: player,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              const Text('Beranda', style: AppText.largeTitle),
              const SizedBox(height: 20),
              const Text('Putar Ulang', style: AppText.section),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, c) {
                  final w = (c.maxWidth - 20) / 3;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < recents.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        _RecentCard(item: recents[i], width: w),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Untuk Kamu', style: AppText.section),
              const SizedBox(height: 8),
              for (var i = 0; i < tracks.length; i++) _TrackRow(index: i),
            ],
          );
        },
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.item, required this.width});

  final Recent item;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _play(context, item.trackIndex),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlbumArt(style: item.art, size: width, radius: 14),
            const SizedBox(height: 8),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            Text(
              item.subtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.grayText),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final track = tracks[index];
    final current = player.index == index;
    return InkWell(
      onTap: () => _play(context, index),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            AlbumArt(style: track.art, size: 52, radius: 10),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.rowTitle.copyWith(
                      fontWeight: current ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  Text(track.artist, style: AppText.rowSub),
                ],
              ),
            ),
            Icon(
              current ? Icons.equalizer_rounded : Icons.more_horiz_rounded,
              color: current ? AppColors.ink : AppColors.grayText,
            ),
          ],
        ),
      ),
    );
  }
}
