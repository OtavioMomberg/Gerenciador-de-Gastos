import 'dart:math';

class SortImage {
  static final Random rand = Random();

  static String getImagePath() {
    return imageMap[rand.nextInt(3)]!;
  }

  static final Map<int, String> imageMap = {
    0: "assets/images/dash_1.png",
    1: "assets/images/dash_2.png",
    2: "assets/images/dash_3.png"
  };
}