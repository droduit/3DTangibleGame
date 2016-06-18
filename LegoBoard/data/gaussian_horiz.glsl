#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

#define WEIGHT 39
#define TEX(dx, dy) texture2D(texture, vertTexCoord.st + vec2(dx, dy))

uniform vec2 resolution;
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main (void) {
    float dy = 1.0 / resolution.y;

    vec4 gaussian = 
        12 * TEX(0.0, -dy) +
        15 * TEX(0.0, 0.0) +
        12 * TEX(0.0, +dy);

    gl_FragColor = gaussian / WEIGHT;
}
