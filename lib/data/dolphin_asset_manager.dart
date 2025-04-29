import 'dart:math';

class DolphinAssetManager {
  final Map<String, double> _assetScales = {
    'assets/images/dolphins/happy/dolphin1.png': 0.77,
    'assets/images/dolphins/happy/dolphin2.png': 1.66,
    'assets/images/dolphins/happy/dolphin3.png': 1.66,
    'assets/images/dolphins/happy/dolphin4.png': 1.66,
    'assets/images/dolphins/happy/dolphin5.png': 1.66,
    'assets/images/dolphins/happy/dolphin6.png': 1.66,
    'assets/images/dolphins/happy/dolphin7.png': 1.66,
    'assets/images/dolphins/happy/dolphin8.png': 1.66,
    'assets/images/dolphins/happy/dolphin9.png': 1.66,
    'assets/images/dolphins/happy/dolphin10.png': 1.66,
    // Add more entries as needed
  };

  late List<String> _shuffledAssets;
  int _currentIndex = 0;

  DolphinAssetManager() {
    _resetShuffledAssets();
  }

  void _resetShuffledAssets() {
    _shuffledAssets = _assetScales.keys.toList();
    _shuffledAssets.shuffle(Random());
    _currentIndex = 0;
  }

  (String assetPath, double scale) getNextAsset() {
    if (_currentIndex >= _shuffledAssets.length) {
      _resetShuffledAssets();
    }
    final assetPath = _shuffledAssets[_currentIndex];
    final scale = _assetScales[assetPath]!;
    _currentIndex++;
    return (assetPath, scale);
  }
}
