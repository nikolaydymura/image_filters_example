precision mediump float;

uniform lowp float inputBrightness;
uniform lowp float inputContrast;
uniform sampler2D inputImageTexture;

varying vec2 textureCoordinate;

vec4 processColor0(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness)), sourceColor.w);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}

void main(){
	vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	gl_FragColor = processedColor1;
}