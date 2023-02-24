import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

class BrightnessContrastFilterConfiguration extends BunchFilterConfiguration {
  BrightnessContrastFilterConfiguration()
      : super(
          'video_shaders',
          [GPUBrightnessConfiguration(), GPUContrastConfiguration()],
        );
}
