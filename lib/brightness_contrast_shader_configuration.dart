import 'package:flutter_image_filters/flutter_image_filters.dart';

class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
      : super([BrightnessShaderConfiguration(), ContrastShaderConfiguration()]);
}
