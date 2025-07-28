#include <flutter/runtime_effect.glsl>
precision mediump float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform lowp float inputBrightness;
layout(location = 1) uniform lowp float inputContrast;
layout(location = 2) uniform float inputSaturation;
layout(location = 3) uniform lowp vec2 inputVignetteCenter;
layout(location = 4) uniform lowp vec3 inputVignetteColor;
layout(location = 5) uniform highp float inputVignetteStart;
layout(location = 6) uniform highp float inputVignetteEnd;
layout(location = 7) uniform vec2 screenSize;

// Values from \Graphics Shaders: Theory and Practice\ by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor0(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness * sourceColor.a)), sourceColor.a);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}
vec4 processColor2(vec4 sourceColor){
   lowp float luminance = dot(sourceColor.rgb, luminanceWeighting);
   lowp vec3 greyScaleColor = vec3(luminance);
   return vec4(mix(greyScaleColor, sourceColor.rgb, inputSaturation), sourceColor.w);
}
vec4 processColor3(vec4 sourceColor, vec2 textureCoordinate){
    lowp vec3 rgb = sourceColor.rgb;
    lowp float d = distance(textureCoordinate, vec2(inputVignetteCenter.x, inputVignetteCenter.y));
    lowp float percent = smoothstep(inputVignetteStart, inputVignetteEnd, d);
    return vec4(mix(rgb.x, inputVignetteColor.x, percent), mix(rgb.y, inputVignetteColor.y, percent), mix(rgb.z, inputVignetteColor.z, percent), 1.0);
}

void main(){
	vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
	vec4 textureColor = texture(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	vec4 processedColor2 = processColor2(processedColor1);
	vec4 processedColor3 = processColor3(processedColor2, textureCoordinate);
	fragColor = processedColor3;
}