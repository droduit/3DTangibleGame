class Filter {
  PImage raw_img;
  PGraphics filtered_img;
  PGraphics gauss_img;
  PGraphics sobel_img;
  PGraphics sobel_threshold_img;
  
  PShader filtered_shader;
  PShader gaussian_shader;
  PShader sobel_shader;
  PShader sobel_threshold_shader;
  
  float BRIGHTNESS_LOWER_BOUND =  30.0f;
  float BRIGHTNESS_UPPER_BOUND = 200.0f;
  
  float SATURATION_LOWER_BOUND = 125.0f;
  float SATURATION_UPPER_BOUND = 255.0f;
  
  float GREEN_HUE_LOWER_BOUND = 80.0f;
  float GREEN_HUE_UPPER_BOUND = 130.0f;
  
  int sobel_last_max_update = millis() - 1000;
  float sobel_max = 0.0f;
  
  
  public Filter(PImage raw_img) {
     this.raw_img = raw_img;
     init(raw_img);
  }
  
  public PImage getRawImg() { return raw_img; }
  public PGraphics getFilteredImg() { return filtered_img; }
  public PGraphics getGaussImg() { return gauss_img; }
  public PGraphics getSobelImg() { return sobel_img; }
  public PGraphics getSobelThresholdImg() { return sobel_threshold_img; }

  private void init(PImage base) {
      filtered_img = createGraphics(base.width, base.height, P2D);
      gauss_img = createGraphics(base.width, base.height, P2D);
      sobel_img = createGraphics(base.width, base.height, P2D);
      sobel_threshold_img = createGraphics(base.width, base.height, P2D);
  
      filtered_shader = loadShader("filter.glsl");
      filtered_shader.set("HMIN", GREEN_HUE_LOWER_BOUND / 255f);
      filtered_shader.set("HMAX", GREEN_HUE_UPPER_BOUND / 255f);
      filtered_shader.set("SMIN", SATURATION_LOWER_BOUND / 255f);
      filtered_shader.set("SMAX", SATURATION_UPPER_BOUND / 255f);
      filtered_shader.set("VMIN", BRIGHTNESS_LOWER_BOUND / 255f);
      filtered_shader.set("VMAX", BRIGHTNESS_UPPER_BOUND / 255f);
      filtered_img.shader(filtered_shader);
  
      gaussian_shader = loadShader("gaussian.glsl");
      gaussian_shader.set("resolution", (float)base.width, (float)base.height);
      gauss_img.shader(gaussian_shader);
  
      sobel_shader = loadShader("sobel.glsl");
      sobel_shader.set("resolution", (float)base.width, (float)base.height);
      sobel_img.shader(sobel_shader);
  
      sobel_threshold_shader = loadShader("sobel_threshold.glsl");
      sobel_threshold_shader.set("threshold", 0.015);
      sobel_threshold_img.shader(sobel_threshold_shader);
  }

  PGraphics graphicsDraw(PGraphics dst, PImage src) {
      dst.beginDraw();

      dst.beginShape();
          dst.texture(src);
          dst.vertex(0, 0, 0, 0);
          dst.vertex(dst.width, 0, src.width, 0);
          dst.vertex(dst.width, dst.height, src.width, src.height);
          dst.vertex(0, dst.height, 0, src.height);
      dst.endShape();

      dst.endDraw();

      return dst;
  }

  PGraphics threshold(PImage img) {
    return graphicsDraw(filtered_img, img);
  }
  
  PImage gaussian(PImage img) {
      return graphicsDraw(gauss_img, img);
  }
  
  PImage sobel(PImage img) {
      // Première passe du sobel
      graphicsDraw(sobel_img, img);
  
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
      return graphicsDraw(sobel_threshold_img, img);
  } 
}
