precision mediump float;

uniform sampler2D inputTextureCubeData; // lookup texture
uniform lowp float inputIntensity;
uniform lowp float inputContrast;
uniform lowp float inputBrightness;
uniform highp float inputExposure;
uniform sampler2D inputImageTexture;

varying vec2 textureCoordinate;

vec4 lookupFrom2DTexture(vec3 textureColor) {
    mediump float blueColor = textureColor.b * 63.0;
    mediump vec2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    mediump vec2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    mediump vec2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    mediump vec2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);
    mediump vec4 newColor1 = texture2D(inputTextureCubeData, texPos1);
    mediump vec4 newColor2 = texture2D(inputTextureCubeData, texPos2);
    return mix(newColor1, newColor2, fract(blueColor));
}

vec4 processColor0(vec4 sourceColor){
   vec4 newColor = lookupFrom2DTexture(clamp(sourceColor.rgb, 0.0, 1.0));
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensity);
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
	vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	vec4 processedColor2 = processColor2(processedColor1);
	vec4 processedColor3 = processColor3(processedColor2);
	gl_FragColor = processedColor3;
}