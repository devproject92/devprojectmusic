import 'package:flutter/material.dart';

import '../data.dart';
import '../player_state.dart';
import '../theme.dart';
import '../widgets/album_art.dart';
import 'now_playing_screen.dart';

class _Genre {
  const _Genre(this.name, this.bg, this.fg, {this.outlined = false});

  final String name;
  final Color bg;
  final Color fg;
  final bool outlined;
}

const _genres = [
  _Genre('Pop', AppColors.ink, Colors.white),
  _Genre('Rock', Colors.white, AppColors.ink, outlined: true),
  _Genre('Jazz', AppColors.darkCard, Colors.white),
  _Genre('Akustik', AppColors.grayLight, AppColors.ink),
  _Genre('Hip-hop', Colors.white, AppColors.ink, outlined: true),
  _Genre('Elektronik', AppColors.ink, Colors.white),
  _Genre('Indie', AppColors.grayLight, AppColors.ink),
  _Genre('Klasik', AppColors.darkCard, Colors.white),
];

/// Satu baris hasil pencarian: lagu, atau playlist/album dari daftar terakhir.
class _Result {
  const _Result({
    required this.title,
    required this.subtitle,
    required this.art,
    required this.trackIndex,
  });

  final String title;
  final String subtitle;
  final ArtStyle art;
  final int trackIndex;

  bool matches(String query) {
    return title.toLowerCase().contains(query) ||
        subtitle.toLowerCase().contains(query);
  }
}

List<_Result> _allResults() {
  return [
    for (var i = 0; i < tracks.length; i++)
      _Result(
        title: tracks[i].title,
        subtitle: 'Lagu · ${tracks[i].artist}',
        art: tracks[i].art,
        trackIndex: i,
      ),
    for (final recent in recents)
      _Result(
        title: recent.title,
        subtitle:
            '${recent.subtitle} · ${tracks[recent.trackIndex].artist}',
        art: recent.art,
        trackIndex: recent.trackIndex,
      ),
  ];
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results =
        query.isEmpty ? const <_Result>[] : _allResults().where((r) => r.matches(query)).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Cari', style: AppText.largeTitle),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Artis, lagu, atau podcast',
              hintStyle: const TextStyle(color: AppColors.grayText),
              prefixIcon: const Icon(Icons.search, color: AppColors.grayText),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Bersihkan pencarian',
                      icon: const Icon(Icons.close, color: AppColors.grayText),
                      onPressed: _clear,
                    ),
              filled: true,
              fillColor: AppColors.grayLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (query.isEmpty)
            ..._exploreGrid()
          else if (results.isEmpty)
            _EmptyResult(query: _query.trim())
          else ...[
            Text('Hasil', style: AppText.section),
            const SizedBox(height: 4),
            for (final result in results) _ResultRow(result: result),
          ],
        ],
      ),
    );
  }

  List<Widget> _exploreGrid() {
    return [
      const Text('Jelajahi Semua', style: AppText.section),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _genres.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 88,
        ),
        itemBuilder: (context, i) {
          final g = _genres[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: g.bg,
              borderRadius: BorderRadius.circular(16),
              border:
                  g.outlined ? Border.all(color: AppColors.ink, width: 2) : null,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                g.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: g.fg,
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});

  final _Result result;

  @override
  Widget build(BuildContext context) {
    final current = player.index == result.trackIndex;
    return InkWell(
      onTap: () {
        player.select(result.trackIndex);
        openNowPlaying(context);
      },
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            AlbumArt(style: result.art, size: 52, radius: 10),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.rowTitle.copyWith(
                      fontWeight: current ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  Text(
                    result.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.rowSub,
                  ),
                ],
              ),
            ),
            Icon(
              current ? Icons.equalizer_rounded : Icons.play_arrow_rounded,
              color: current ? AppColors.ink : AppColors.chevron,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.chevron),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil untuk "$query"',
            textAlign: TextAlign.center,
            style: AppText.rowTitle,
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba kata lain, atau periksa ejaannya.',
            textAlign: TextAlign.center,
            style: AppText.rowSub,
          ),
        ],
      ),
    );
  }
}
