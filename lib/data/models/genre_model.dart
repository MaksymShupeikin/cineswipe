class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});
}

class Country {
  final String code; // ISO 3166-1 alpha-2
  final String name;

  const Country({required this.code, required this.name});
}

const List<Country> allCountries = [
  Country(code: 'US', name: 'USA'),
  Country(code: 'GB', name: 'UK'),
  Country(code: 'FR', name: 'France'),
  Country(code: 'KR', name: 'Korea'),
  Country(code: 'JP', name: 'Japan'),
  Country(code: 'DE', name: 'Germany'),
  Country(code: 'IT', name: 'Italy'),
  Country(code: 'ES', name: 'Spain'),
  Country(code: 'IN', name: 'India'),
  Country(code: 'CN', name: 'China'),
  Country(code: 'AU', name: 'Australia'),
  Country(code: 'CA', name: 'Canada'),
  Country(code: 'BR', name: 'Brazil'),
  Country(code: 'MX', name: 'Mexico'),
  Country(code: 'RU', name: 'Russia'),
  Country(code: 'SE', name: 'Sweden'),
  Country(code: 'DK', name: 'Denmark'),
  Country(code: 'IR', name: 'Iran'),
  Country(code: 'AR', name: 'Argentina'),
  Country(code: 'TH', name: 'Thailand'),
];

final List<Genre> allGenres = [
  Genre(id: 28, name: 'Action'),
  Genre(id: 12, name: 'Adventure'),
  Genre(id: 16, name: 'Animation'),
  Genre(id: 35, name: 'Comedy'),
  Genre(id: 80, name: 'Crime'),
  Genre(id: 99, name: 'Documentary'),
  Genre(id: 18, name: 'Drama'),
  Genre(id: 10751, name: 'Family'),
  Genre(id: 14, name: 'Fantasy'),
  Genre(id: 36, name: 'History'),
  Genre(id: 27, name: 'Horror'),
  Genre(id: 10402, name: 'Music'),
  Genre(id: 9648, name: 'Mystery'),
  Genre(id: 10749, name: 'Romance'),
  Genre(id: 878, name: 'Science Fiction'),
  Genre(id: 10770, name: 'TV Movie'),
  Genre(id: 53, name: 'Thriller'),
  Genre(id: 10752, name: 'War'),
  Genre(id: 37, name: 'Western'),
];