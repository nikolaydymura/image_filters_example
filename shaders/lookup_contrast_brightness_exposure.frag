#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform sampler2D inputImageTexture;
layout(location = 1) uniform lowp float inputIntensityL;
layout(location = 2) uniform mediump sampler2D inputTextureCubeDataL;
layout(location = 3) uniform lowp float inputContrast;
layout(location = 4) uniform lowp float inputBrightness;
layout(location = 5) uniform highp float inputExposure;
layout(location = 6) uniform vec2 screenSize;

vec4 lookupFrom2DTexture(vec3 textureColor) {
    float blueColor = textureColor.b * 63.0;
    vec2 quad1 = vec2(0.0, 0.0);
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    vec2 quad2 = vec2(0.0, 0.0);
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    vec2 texPos1 = vec2(0.0, 0.0);
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    vec2 texPos2 = vec2(0.0, 0.0);
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    vec4 newColor1 = texture(inputTextureCubeDataL, texPos1);
    vec4 newColor2 = texture(inputTextureCubeDataL, texPos2);
    return mix(newColor1, newColor2, fract(blueColor));
}

vec4 processColor0(vec4 sourceColor){
   vec4 newColor = lookupFrom2DTexture(sourceColor.rgb);
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensityL);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}
vec4 processColor2(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness)), sourceColor.w);
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