// import processing.video.*;
// Capture cam;
PImage raw_img;
PGraphics filtered_img;
PGraphics gauss_img;
PGraphics sobel_img;
PGraphics sobel_threshold_img;

PShader sobel_threshold_shader;

float BRIGHTNESS_LOWER_BOUND =  30.0f;
float BRIGHTNESS_UPPER_BOUND = 200.0f;

float SATURATION_LOWER_BOUND = 125.0f;
float SATURATION_UPPER_BOUND = 255.0f;

float GREEN_HUE_LOWER_BOUND = 100.0f;
float GREEN_HUE_UPPER_BOUND = 139.0f;

int CAM_WIDTH = 600;
int CAM_HEIGHT = 400;
int CAM_FPS = 30;

int sobel_last_max_update = millis() - 1000;
float sobel_max = 0.0f;

void settings() {
    size(2*CAM_WIDTH, 2*CAM_HEIGHT, P2D);
}
void setup() {
    raw_img = loadImage("data/board1.jpg");

    filters_setup(raw_img);
}

void filters_setup(PImage base) {
    filtered_img = createGraphics(base.width, base.height, P2D);
    gauss_img = createGraphics(base.width, base.height, P2D);
    sobel_img = createGraphics(base.width, base.height, P2D);
    sobel_threshold_img = createGraphics(base.width, base.height, P2D);

    PShader filtered_shader = loadShader("filter.glsl");
    filtered_shader.set("HMIN", GREEN_HUE_LOWER_BOUND / 255f);
    filtered_shader.set("HMAX", GREEN_HUE_UPPER_BOUND / 255f);
    filtered_shader.set("SMIN", SATURATION_LOWER_BOUND / 255f);
    filtered_shader.set("SMAX", SATURATION_UPPER_BOUND / 255f);
    filtered_shader.set("VMIN", BRIGHTNESS_LOWER_BOUND / 255f);
    filtered_shader.set("VMAX", BRIGHTNESS_UPPER_BOUND / 255f);
    filtered_img.shader(filtered_shader);

    PShader gaussian_shader = loadShader("gaussian.glsl");
    gaussian_shader.set("resolution", (float)base.width, (float)base.height);
    gauss_img.shader(gaussian_shader);

    PShader sobel_shader = loadShader("sobel.glsl");
    sobel_shader.set("resolution", (float)base.width, (float)base.height);
    sobel_img.shader(sobel_shader);

    sobel_threshold_shader = loadShader("sobel_threshold.glsl");
    sobel_threshold_shader.set("threshold", 0.015);
    sobel_threshold_img.shader(sobel_threshold_shader);
}

void hough(PImage edgeImg) {
    float discretizationStepsPhi = 0.06f;
    float discretizationStepsR = 2.5f;

    //==============================================================================
    // dimensions of the accumulator
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
    // our accumulator (with a 1 pix margin around)
    int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
    // Fill the accumulator: on edge points (ie, white pixels of the edge // image), store all possible (r, phi) pairs describing lines going // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
        for (int x = 0; x < edgeImg.width; x++) {
            // Are we on an edge?
            if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
                // ...determine here all the lines (r, phi) passing through
                // pixel (x,y), convert (r,phi) to coordinates in the
                // accumulator, and increment accordingly the accumulator.
                // Be careful: r may be negative, so you may want to center onto
                // the accumulator with something like: r += (rDim - 1) / 2
                for (float phi = 0; phi < phiDim; phi += discretizationStepsPhi) {
                    for (float r = -rDim; r < rDim; r += discretizationStepsR ) {

                    }
                }
            } 
        }
    }
}

PGraphics threshold(PImage img) {
    filtered_img.beginDraw();

    filtered_img.beginShape();
        filtered_img.texture(img);
        filtered_img.vertex(0, 0, 0, 0);
        filtered_img.vertex(img.width, 0, img.width, 0);
        filtered_img.vertex(img.width, img.height, img.width, img.height);
        filtered_img.vertex(0, img.height, 0, img.height);
    filtered_img.endShape();

    filtered_img.endDraw();

    return filtered_img;
}

PImage gaussian(PImage img) {
    gauss_img.beginDraw();

    gauss_img.beginShape();
        gauss_img.texture(img);
        gauss_img.vertex(0, 0, 0, 0);
        gauss_img.vertex(img.width, 0, img.width, 0);
        gauss_img.vertex(img.width, img.height, img.width, img.height);
        gauss_img.vertex(0, img.height, 0, img.height);
    gauss_img.endShape();

    gauss_img.endDraw();

    return gauss_img;
}

PImage sobel(PImage img) {
    // Première passe du sobel
    sobel_img.beginDraw();

    sobel_img.beginShape();
        sobel_img.texture(img);
        sobel_img.vertex(0, 0, 0, 0);
        sobel_img.vertex(img.width, 0, img.width, 0);
        sobel_img.vertex(img.width, img.height, img.width, img.height);
        sobel_img.vertex(0, img.height, 0, img.height);
    sobel_img.endShape();

    sobel_img.endDraw();

    // On détermine le max
    int now = millis();
    if (now - sobel_last_max_update >= 1000) {
        sobel_img.loadPixels();

        sobel_max = 0;
        int pixels_count = sobel_img.width * sobel_img.height;
        for (int i = 0; i < pixels_count; i++) {
            float val = red(sobel_img.pixels[i]);

            if (val > sobel_max)
                sobel_max = val;
        }


        float threshold = sqrt(sobel_max / 255.0) * 0.3;
        sobel_threshold_shader.set("threshold", threshold * threshold);

        sobel_last_max_update = now;
    }

    // Deuxième passe du sobel
    sobel_threshold_img.beginDraw();

    sobel_threshold_img.beginShape();
        sobel_threshold_img.texture(sobel_img);
        sobel_threshold_img.vertex(0, 0, 0, 0);
        sobel_threshold_img.vertex(img.width, 0, img.width, 0);
        sobel_threshold_img.vertex(img.width, img.height, img.width, img.height);
        sobel_threshold_img.vertex(0, img.height, 0, img.height);
    sobel_threshold_img.endShape();

    sobel_threshold_img.endDraw();

    return sobel_threshold_img;
}

void draw() {
    // background(color(0,0,0));

    threshold(raw_img);
    gaussian(filtered_img);
    sobel(gauss_img);

    image(raw_img, 0, 0, CAM_WIDTH, CAM_HEIGHT);
    image(filtered_img, CAM_WIDTH, 0, CAM_WIDTH, CAM_HEIGHT);
    image(gauss_img, 0, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);
    image(sobel_threshold_img, CAM_WIDTH, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);

    println(frameRate);
}
