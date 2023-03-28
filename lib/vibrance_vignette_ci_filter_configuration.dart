import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';

class VibranceVignetteCIFilterConfiguration extends BunchCIFilterConfiguration {
  VibranceVignetteCIFilterConfiguration()
      : super(
          [CIVibranceConfiguration(), CIVignetteConfiguration()],
        );
}
