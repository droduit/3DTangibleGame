// import processing.video.*;
// Capture cam;

Filter filter;
PImage raw_img;
PGraphics filtered_img;
PGraphics gauss_img;
PGraphics sobel_img;
PGraphics sobel_threshold_img;


int CAM_WIDTH = 600;
int CAM_HEIGHT = 400;
int CAM_FPS = 30;

void settings() {
    size(2*CAM_WIDTH, 2*CAM_HEIGHT, P2D);
}
void setup() {
    raw_img = loadImage("data/board3.jpg");
    filter = new Filter(raw_img);
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
                for (float phi = 0; phi < Math.PI; phi += discretizationStepsPhi) {
                  float r = x*cos(phi) + y*sin(phi);
                  r = r / discretizationStepsR;
                  r += (rDim-1) / 2;
                  accumulator[(int)((1+phi/discretizationStepsPhi)*(rDim + 2) + (r + 1))]++;
                }
            } 
        }
    }
}


void draw() {
    // background(color(0,0,0));

    filter.threshold(raw_img);
    filter.gaussian(filter.getFilteredImg());
    filter.sobel(filter.getGaussImg());

    image(filter.getRawImg(), 0, 0, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getFilteredImg(), CAM_WIDTH, 0, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getGaussImg(), 0, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getSobelThresholdImg(), CAM_WIDTH, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);

    println(frameRate);
}