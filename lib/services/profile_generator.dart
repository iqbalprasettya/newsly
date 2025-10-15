import 'dart:math';
import '../models/user_profile.dart';

class ProfileGenerator {
  static final List<String> _firstNames = [
    'Alex',
    'Jordan',
    'Taylor',
    'Casey',
    'Morgan',
    'Riley',
    'Avery',
    'Quinn',
    'Blake',
    'Cameron',
    'Drew',
    'Emery',
    'Finley',
    'Hayden',
    'Jamie',
    'Kendall',
    'Logan',
    'Parker',
    'Reese',
    'Sage',
    'Skyler',
    'Sydney',
    'Tatum',
    'River',
    'Phoenix',
    'Rowan',
    'Sage',
    'Indigo',
    'Ocean',
    'Forest',
    'Meadow',
    'Brook',
    'Dawn',
    'Sunny',
    'Storm',
    'Rain',
    'Snow',
    'Autumn',
    'Spring',
    'Summer',
    'Winter',
    'Crystal',
    'Diamond',
    'Ruby',
    'Sapphire',
    'Emerald',
    'Pearl',
    'Amber',
    'Jade',
    'Opal',
    'Topaz',
    'Garnet',
    'Onyx',
    'Jasper',
    'Quartz',
  ];

  static final List<String> _lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez',
    'Wilson',
    'Anderson',
    'Thomas',
    'Taylor',
    'Moore',
    'Jackson',
    'Martin',
    'Lee',
    'Perez',
    'Thompson',
    'White',
    'Harris',
    'Sanchez',
    'Clark',
    'Ramirez',
    'Lewis',
    'Robinson',
    'Walker',
    'Young',
    'Allen',
    'King',
    'Wright',
    'Scott',
    'Torres',
    'Nguyen',
    'Hill',
    'Flores',
    'Green',
    'Adams',
    'Nelson',
    'Baker',
    'Hall',
    'Rivera',
    'Campbell',
    'Mitchell',
    'Carter',
    'Roberts',
    'Gomez',
    'Phillips',
    'Evans',
    'Turner',
    'Diaz',
    'Parker',
    'Cruz',
    'Edwards',
    'Collins',
    'Reyes',
    'Stewart',
    'Morris',
  ];

  static final List<String> _emailDomains = [
    'gmail.com',
    'yahoo.com',
    'hotmail.com',
    'outlook.com',
    'icloud.com',
    'protonmail.com',
    'fastmail.com',
    'zoho.com',
    'mail.com',
    'yandex.com',
  ];

  static final List<String> _categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  static final List<String> _languages = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'pt',
    'ru',
    'ja',
    'ko',
    'zh',
    'ar',
    'hi',
  ];

  static final List<String> _countries = [
    'us',
    'gb',
    'ca',
    'au',
    'de',
    'fr',
    'it',
    'es',
    'jp',
    'kr',
    'cn',
    'in',
    'br',
    'mx',
    'ar',
    'ru',
    'nl',
    'se',
    'no',
    'dk',
    'fi',
    'ch',
    'at',
    'be',
  ];

  static String _getRandomElement(List<String> list) {
    return list[Random().nextInt(list.length)];
  }

  static String _generateRandomName() {
    final firstName = _getRandomElement(_firstNames);
    final lastName = _getRandomElement(_lastNames);
    return '$firstName $lastName';
  }

  static String _generateRandomEmail(String name) {
    final firstName = name.split(' ')[0].toLowerCase();
    final lastName = name.split(' ')[1].toLowerCase();
    final domain = _getRandomElement(_emailDomains);
    final randomNumber = Random().nextInt(9999);

    // Random email format
    final formats = [
      '$firstName.$lastName$randomNumber@$domain',
      '$firstName$lastName$randomNumber@$domain',
      '$firstName.$lastName@$domain',
      '$firstName$lastName@$domain',
    ];

    return _getRandomElement(formats);
  }

  static List<String> _generateFavoriteCategories() {
    final numCategories = Random().nextInt(3) + 2; // 2-4 categories
    final shuffled = List<String>.from(_categories)..shuffle();
    return shuffled.take(numCategories).toList();
  }

  static UserProfile generateRandomProfile() {
    final name = _generateRandomName();
    final email = _generateRandomEmail(name);
    final favoriteCategories = _generateFavoriteCategories();
    final preferredLanguage = _getRandomElement(_languages);
    final preferredCountry = _getRandomElement(_countries);

    return UserProfile(
      name: name,
      email: email,
      favoriteCategories: favoriteCategories,
      favoriteSources: [], // Empty initially
      preferredLanguage: preferredLanguage,
      preferredCountry: preferredCountry,
    );
  }

  static UserProfile generateDefaultProfile() {
    return UserProfile(
      name: 'News Reader',
      email: 'reader@newsly.app',
      favoriteCategories: ['general', 'technology'],
      favoriteSources: [],
      preferredLanguage: 'en',
      preferredCountry: 'us',
    );
  }
}
