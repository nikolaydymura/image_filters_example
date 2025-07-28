// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// BunchShaderConfigurationsGenerator
// **************************************************************************

import 'dart:ui';

import 'package:flutter_image_filters/flutter_image_filters.dart';

class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
    : super([BrightnessShaderConfiguration(), ContrastShaderConfiguration()]);

  BrightnessShaderConfiguration get brightnessShader => configuration(at: 0);

  ContrastShaderConfiguration get contrastShader => configuration(at: 1);
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

  SquareLookupTableShaderConfiguration get squareLookupTableShader =>
      configuration(at: 0);

  ContrastShaderConfiguration get contrastShader => configuration(at: 1);

  BrightnessShaderConfiguration get brightnessShader => configuration(at: 2);

  ExposureShaderConfiguration get exposureShader => configuration(at: 3);
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

  HALDLookupTableShaderConfiguration get hALDLookupTableShader =>
      configuration(at: 0);

  ContrastShaderConfiguration get contrastShader => configuration(at: 1);

  BrightnessShaderConfiguration get brightnessShader => configuration(at: 2);

  ExposureShaderConfiguration get exposureShader => configuration(at: 3);
}

class WhiteBalanceExposureContrastSaturationShaderConfiguration
    extends BunchShaderConfiguration {
  WhiteBalanceExposureContrastSaturationShaderConfiguration()
    : super([
        WhiteBalanceShaderConfiguration(),
        ExposureShaderConfiguration(),
        ContrastShaderConfiguration(),
        SaturationShaderConfiguration(),
      ]);

  WhiteBalanceShaderConfiguration get whiteBalanceShader =>
      configuration(at: 0);

  ExposureShaderConfiguration get exposureShader => configuration(at: 1);

  ContrastShaderConfiguration get contrastShader => configuration(at: 2);

  SaturationShaderConfiguration get saturationShader => configuration(at: 3);
}

class BrightnessContrastSaturationVignetteShaderConfiguration
    extends BunchShaderConfiguration {
  BrightnessContrastSaturationVignetteShaderConfiguration()
    : super([
        BrightnessShaderConfiguration(),
        ContrastShaderConfiguration(),
        SaturationShaderConfiguration(),
        VignetteShaderConfiguration(),
      ]);

  BrightnessShaderConfiguration get brightnessShader => configuration(at: 0);

  ContrastShaderConfiguration get contrastShader => configuration(at: 1);

  SaturationShaderConfiguration get saturationShader => configuration(at: 2);

  VignetteShaderConfiguration get vignetteShader => configuration(at: 3);
}

void registerBunchShaders() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(
    () => FragmentProgram.fromAsset('shaders/brightness_contrast.frag'),
  );

  FlutterImageFilters.register<
    LookupContrastBrightnessExposureShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/lookup_contrast_brightness_exposure.frag',
    ),
  );

  FlutterImageFilters.register<
    HALDLookupContrastBrightnessExposureShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/hald_lookup_contrast_brightness_exposure.frag',
    ),
  );

  FlutterImageFilters.register<
    WhiteBalanceExposureContrastSaturationShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/white_balance_exposure_contrast_saturation.frag',
    ),
  );

  FlutterImageFilters.register<
    BrightnessContrastSaturationVignetteShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/brightness_contrast_saturation_vignette.frag',
    ),
  );
}
