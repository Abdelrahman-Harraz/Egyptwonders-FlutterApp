/// A class to manage liked items.
class LikesList {
  static List<String> _likes = []; // List to store liked items

  /// Getter for the list of liked items.
  static List<String> get likes {
    return _likes;
  }

  /// Setter for the list of liked items.
  static set likes(List<String> value) {
    _likes = value;
  }

  /// Adds a new item to the liked list if it doesn't already exist.
  static void addLike(String item) {
    if (!_likes.contains(item)) {
      _likes.add(item);
    }
  }

  /// Removes an item from the liked list.
  static void removeLike(String item) {
    _likes.remove(item);
  }

  /// Creates and returns a copy of the liked list.
  static List<String> copyOflikes() {
    return List<String>.from(_likes);
  }
}
