import 'package:flutter/material.dart';

import '../theme.dart';

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

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Cari', style: AppText.largeTitle),
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Artis, lagu, atau podcast',
              hintStyle: const TextStyle(color: AppColors.grayText),
              prefixIcon: const Icon(Icons.search, color: AppColors.grayText),
              filled: true,
              fillColor: AppColors.grayLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                  border: g.outlined
                      ? Border.all(color: AppColors.ink, width: 2)
                      : null,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    g.name,
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
        ],
      ),
    );
  }
}
