enum ArtStyle {
  rings,
  ringsFine,
  diagonal,
  diagonalInv,
  stripes,
  dot,
  grey,
  dots,
}

class Track {
  const Track(this.title, this.artist, this.art);

  final String title;
  final String artist;
  final ArtStyle art;
}

class Recent {
  const Recent(this.title, this.subtitle, this.art, this.trackIndex);

  final String title;
  final String subtitle;
  final ArtStyle art;
  final int trackIndex;
}

const tracks = [
  Track('Malam Pelan', 'Artis Contoh', ArtStyle.dot),
  Track('Garis Tipis', 'Artis Contoh', ArtStyle.grey),
  Track('Jalan Pulang', 'Band Contoh', ArtStyle.dots),
  Track('Hujan di Seberang', 'Artis Contoh', ArtStyle.diagonalInv),
];

const recents = [
  Recent('Malam Pelan', 'Playlist', ArtStyle.ringsFine, 0),
  Recent('Garis Tipis', 'Album', ArtStyle.diagonal, 1),
  Recent('Jalan Pulang', 'Playlist', ArtStyle.stripes, 2),
];
