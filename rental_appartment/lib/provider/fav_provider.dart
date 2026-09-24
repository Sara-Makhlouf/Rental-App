import 'package:flutter/material.dart';
import '../data/models/apartment.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Apartment> _favorites = [];

  List<Apartment> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Apartment apartment) {
    return _favorites.contains(apartment);
  }

  void addFavorite(Apartment apartment) {
    if (!_favorites.contains(apartment)) {
      _favorites.add(apartment);
      notifyListeners();
    }
  }

  void removeFavorite(Apartment apartment) {
    if (_favorites.contains(apartment)) {
      _favorites.remove(apartment);
      notifyListeners();
    }
  }

  void toggleFavorite(Apartment apartment) {
    if (isFavorite(apartment)) {
      removeFavorite(apartment);
    } else {
      addFavorite(apartment);
    }
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
