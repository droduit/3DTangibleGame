#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

#define WEIGHT 99
#define TEX(dx, dy) texture2D(texture, vertTexCoord.st + vec2(dx, dy))

uniform vec2 resolution;
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main (void) {
    float dx = 1.0 / resolution.x;
    float dy = 1.0 / resolution.y;

    vec4 gaussian = 
         9 * TEX(-dx, -dy) + 12 * TEX(0.0, -dy) +  9 * TEX(+dx, -dy) +
        12 * TEX(-dx, 0.0) + 15 * TEX(0.0, 0.0) + 12 * TEX(+dx, 0.0) +
         9 * TEX(-dx, +dy) + 12 * TEX(0.0, +dy) +  9 * TEX(+dx, +dy);

    gl_FragColor = gaussian / WEIGHT;
}
