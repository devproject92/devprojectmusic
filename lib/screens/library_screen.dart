import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/album_art.dart';
import 'now_playing_screen.dart';

class _LibItem {
  const _LibItem(this.title, this.subtitle, {this.art, this.icon, this.tile});

  final String title;
  final String subtitle;
  final ArtStyle? art;
  final IconData? icon;
  final Color? tile;
}

const _filters = ['Playlist', 'Artis', 'Album'];

const _items = <List<_LibItem>>[
  [
    _LibItem('Lagu Disukai', 'Playlist · 128 lagu',
        icon: Icons.favorite_rounded, tile: AppColors.ink),
    _LibItem('Malam Pelan', 'Playlist · 24 lagu', art: ArtStyle.ringsFine),
    _LibItem('Jalan Pulang', 'Playlist · 18 lagu', art: ArtStyle.stripes),
    _LibItem('Diunduh', 'Tersedia tanpa internet',
        icon: Icons.arrow_downward_rounded, tile: AppColors.darkCard),
  ],
  [
    _LibItem('Artis Contoh', 'Artis', art: ArtStyle.dot),
    _LibItem('Band Contoh', 'Artis', art: ArtStyle.diagonalInv),
  ],
  [
    _LibItem('Garis Tipis', 'Album · Artis Contoh', art: ArtStyle.diagonal),
    _LibItem('Hujan di Seberang', 'Album · Artis Contoh',
        art: ArtStyle.diagonalInv),
  ],
];

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Pustaka', style: AppText.largeTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < _filters.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _FilterChip(
                  label: _filters[i],
                  selected: i == _filter,
                  onTap: () => setState(() => _filter = i),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          for (final item in _items[_filter])
            InkWell(
              onTap: () => openNowPlaying(context),
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    if (item.art != null)
                      AlbumArt(style: item.art!, size: 56, radius: 12)
                    else
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: item.tile,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 26),
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.rowTitle,
                          ),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.rowSub,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.chevron,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.ink : AppColors.grayLight,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
