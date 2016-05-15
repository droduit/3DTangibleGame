#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float threshold;
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main (void) {
    gl_FragColor = step(threshold, texture2D(texture, vertTexCoord.st));
}
