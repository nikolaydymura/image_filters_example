precision mediump float;

uniform highp float inputExposure;
uniform lowp float inputContrast;
uniform lowp float inputSaturation;
uniform lowp float inputTemperature;
uniform lowp float inputTint;
uniform sampler2D inputTextureCubeData; // lookup texture
uniform lowp float inputIntensity;
uniform sampler2D inputImageTexture;

varying vec2 textureCoordinate;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
const lowp vec3 warmFilter = vec3(0.93, 0.54, 0.0);
const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
vec2 computeSliceOffset(float slice, float slicesPerRow, vec2 sliceSize) {
  return sliceSize * vec2(mod(slice, slicesPerRow),
                          floor(slice / slicesPerRow));
}
vec4 sampleAs3DTexture(vec3 textureColor, float size, float numRows, float slicesPerRow) {
  float slice   = textureColor.z * 511.0;
  float zOffset = fract(slice);                         // dist between slices
  vec2 sliceSize = vec2(1.0 / slicesPerRow,             // u space of 1 slice
                        1.0 / numRows);                 // v space of 1 slice
  vec2 slice0Offset = computeSliceOffset(floor(slice), slicesPerRow, sliceSize);
  vec2 slice1Offset = computeSliceOffset(ceil(slice), slicesPerRow, sliceSize);
  vec2 slicePixelSize = sliceSize / size;               // space of 1 pixel
  vec2 sliceInnerSize = slicePixelSize * (size - 1.0);  // space of size pixels
  vec2 uv = slicePixelSize * 0.5 + textureColor.xy * sliceInnerSize;
  vec4 slice0Color = texture2D(inputTextureCubeData, slice0Offset + uv);
  vec4 slice1Color = texture2D(inputTextureCubeData, slice1Offset + uv);
  return mix(slice0Color, slice1Color, zOffset);
}

vec4 processColor0(vec4 sourceColor){
    return vec4(sourceColor.rgb * pow(2.0, inputExposure), sourceColor.w);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}
vec4 processColor2(vec4 sourceColor){
    lowp float luminance = dot(sourceColor.rgb, luminanceWeighting);
    lowp vec3 greyScaleColor = vec3(luminance);
    return vec4(mix(greyScaleColor, sourceColor.rgb, inputSaturation), sourceColor.w);
}
vec4 processColor3(vec4 sourceColor){
    mediump vec3 yiq = RGBtoYIQ * sourceColor.rgb;//adjusting inputTint
    yiq.b = clamp(yiq.b + inputTint*0.5226*0.1, -0.5226, 0.5226);
    lowp vec3 rgb = YIQtoRGB * yiq;
    lowp vec3 processed = vec3(
    (rgb.r < 0.5 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))), //adjusting inputTemperature
    (rgb.g < 0.5 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
    (rgb.b < 0.5 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b))));
    return vec4(mix(rgb, processed, inputTemperature), sourceColor.a);
}
vec4 processColor4(vec4 sourceColor){
   vec4 newColor = sampleAs3DTexture(clamp(sourceColor.rgb, 0.0, 1.0), 64.0, 64.0, 8.0);
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensity);
}

void main(){
	vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	vec4 processedColor2 = processColor2(processedColor1);
	vec4 processedColor3 = processColor3(processedColor2);
	vec4 processedColor4 = processColor4(processedColor3);
	gl_FragColor = processedColor4;
}