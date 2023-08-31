#include <flutter/runtime_effect.glsl>
precision mediump float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform lowp float inputBrightness;
layout(location = 1) uniform lowp float inputContrast;
layout(location = 2) uniform vec2 screenSize;

vec4 processColor0(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness * sourceColor.a)), sourceColor.a);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}

void main(){
	vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
	vec4 textureColor = texture(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	fragColor = processedColor1;
}