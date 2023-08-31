#include <flutter/runtime_effect.glsl>
precision mediump float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
uniform mediump sampler2D inputTextureCubeData;

layout(location = 0) uniform lowp float inputIntensity;
layout(location = 1) uniform lowp float inputContrast;
layout(location = 2) uniform lowp float inputBrightness;
layout(location = 3) uniform highp float inputExposure;
layout(location = 4) uniform vec2 screenSize;

const float cubeSize = 8.0;
const float cubeRows = 64.0;
const float cubeColumns = 8.0;
const vec2 sliceSize = vec2(1.0 / 8.0, 1.0 / 64.0);
vec2 computeSliceOffset(float slice, vec2 sliceSize) {
  return sliceSize * vec2(mod(slice, cubeColumns),
                          floor(slice / cubeColumns));
}
vec4 sampleAs3DTexture(vec3 textureColor) {
  float slice = textureColor.b * 511.0;
  float zOffset = fract(slice);                         // dist between slices
  vec2 slice0Offset = computeSliceOffset(floor(slice), sliceSize);
  vec2 slice1Offset = computeSliceOffset(ceil(slice), sliceSize);
  vec2 slicePixelSize = sliceSize / cubeSize;               // space of 1 pixel
  vec2 sliceInnerSize = slicePixelSize * (cubeSize - 1.0);  // space of size pixels
  vec2 uv = slicePixelSize * 0.5 + textureColor.xy * sliceInnerSize;
  vec2 texPos1 = slice0Offset + uv;
  vec2 texPos2 = slice1Offset + uv;
  vec4 slice0Color = texture(inputTextureCubeData, texPos1);
  vec4 slice1Color = texture(inputTextureCubeData, texPos2);
  return mix(slice0Color, slice1Color, zOffset);
}

vec4 processColor0(vec4 sourceColor){
   vec4 newColor = sampleAs3DTexture(clamp(sourceColor.rgb, 0.0, 1.0));
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensity);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}
vec4 processColor2(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness * sourceColor.a)), sourceColor.a);
}
vec4 processColor3(vec4 sourceColor){
    return vec4(sourceColor.rgb * pow(2.0, inputExposure), sourceColor.w);
}

void main(){
	vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
	vec4 textureColor = texture(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	vec4 processedColor2 = processColor2(processedColor1);
	vec4 processedColor3 = processColor3(processedColor2);
	fragColor = processedColor3;
}