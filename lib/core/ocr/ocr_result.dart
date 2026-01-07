enum OcrQuality { none, weak, good }

class OcrResult {
  final List<String> imagePaths;
  final List<String> normalizedTextsPerImage;
  final String mergedText;

  final OcrQuality quality;

  final List<String> foundBrands;
  final List<String> foundMaterials;
  final List<String> foundColors;

  const OcrResult({
    required this.imagePaths,
    required this.normalizedTextsPerImage,
    required this.mergedText,
    required this.quality,
    required this.foundBrands,
    required this.foundMaterials,
    required this.foundColors,
  });
}
