import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

class BrightnessContrastFilterConfiguration extends BunchFilterConfiguration {
  BrightnessContrastFilterConfiguration()
    : super('video_shaders', [
        GPUBrightnessConfiguration(),
        GPUContrastConfiguration(),
      ]);
}

class LookupContrastBrightnessExposureFilterConfiguration
    extends BunchFilterConfiguration {
  LookupContrastBrightnessExposureFilterConfiguration()
    : super('video_shaders', [
        GPUSquareLookupTableConfiguration(),
        GPUContrastConfiguration(),
        GPUBrightnessConfiguration(),
        GPUExposureConfiguration(),
      ]);
}


class ExposureContrastSaturationWhiteBalanceHALDLookupFilterConfiguration
    extends BunchFilterConfiguration {
  ExposureContrastSaturationWhiteBalanceHALDLookupFilterConfiguration()
      : super('video_shaders', [
    GPUExposureConfiguration(),
    GPUContrastConfiguration(),
    GPUSaturationConfiguration(),
    GPUWhiteBalanceConfiguration(),
    GPUHALDLookupTableConfiguration(),
  ]);
}
