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
    vec4 texcolor = texture2D(texture, vertTexCoord.st);
    gl_FragColor = mix(
            vec4(0.0, 0.0, 0.0, 1.0),
            texcolor,
            step(threshold, (texcolor.r + texcolor.g + texcolor.b) / 3.0));
}
