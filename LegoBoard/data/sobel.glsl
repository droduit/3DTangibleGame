#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

#define TEX(dx, dy) texture2D(texture, vertTexCoord.st + vec2(dx, dy))

uniform vec2 resolution;
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float brightness (vec4 color) {
    return dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
}

void main (void) {
    float dx = 1.0 / resolution.x;
    float dy = 1.0 / resolution.y;

    float sum_h = brightness(TEX(0.0, -dy)) - brightness(TEX(0.0, +dy));
    float sum_v = brightness(TEX(-dx, 0.0)) - brightness(TEX(+dx, 0.0));
    float sum = sum_h * sum_h + sum_v * sum_v;

    gl_FragColor = vec4(sum, sum, sum, 1.0);
}
