import 'package:flutter_image_filters/flutter_image_filters.dart';

class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
    : super([BrightnessShaderConfiguration(), ContrastShaderConfiguration()]);
}

class LookupContrastBrightnessExposureShaderConfiguration
    extends BunchShaderConfiguration {
  LookupContrastBrightnessExposureShaderConfiguration()
    : super([
        SquareLookupTableShaderConfiguration(),
        ContrastShaderConfiguration(),
        BrightnessShaderConfiguration(),
        ExposureShaderConfiguration(),
      ]);
}

class HALDLookupContrastBrightnessExposureShaderConfiguration
    extends BunchShaderConfiguration {
  HALDLookupContrastBrightnessExposureShaderConfiguration()
    : super([
        HALDLookupTableShaderConfiguration(),
        ContrastShaderConfiguration(),
        BrightnessShaderConfiguration(),
        ExposureShaderConfiguration(),
      ]);
}

class WhiteBalanceExposureContrastSaturationShaderConfiguration
    extends BunchShaderConfiguration {
  WhiteBalanceExposureContrastSaturationShaderConfiguration()
    : super([
        WhiteBalanceShaderConfiguration()
          ..tint = 50
          ..temperature = 0,
        ExposureShaderConfiguration(),
        ContrastShaderConfiguration(),
        SaturationShaderConfiguration(),
      ]);
}
