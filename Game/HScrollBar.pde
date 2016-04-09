class HScrollbar {
  PGraphics scrollBar;
  float barWidth; //Bar's width in pixels
  float barHeight; //Bar's height in pixels
  float xPosition; //Bar's x position in pixels
  float yPosition; //Bar's y position in pixels
  float sliderPosition, newSliderPosition; //Position of slider
  float sliderPositionMin, sliderPositionMax; //Max and min values of slider
  boolean mouseOver; //Is the mouse over the slider?
  boolean locked; //Is the mouse clicking and dragging the slider now?
 
  /**
  * @brief Creates a new horizontal scrollbar
  *
  * @param x The x position of the top left corner of the bar in pixels
  * @param y The y position of the top left corner of the bar in pixels
  * @param w The width of the bar in pixels
  * @param h The height of the bar in pixels
  */
  public HScrollbar (float w, float h) {
    scrollBar = createGraphics((int)w, (int)h,P2D);
    barWidth = w;
    barHeight = h;
    xPosition = 0;
    yPosition = 0;
    sliderPosition = xPosition + barWidth/2 - barHeight/2;
    newSliderPosition = sliderPosition;
    sliderPositionMin = xPosition;
    sliderPositionMax = xPosition + barWidth - barHeight;
  }
  
  /**
  * @brief Updates the state of the scrollbar according to the mouse movement
  */
  void update() {
    mouseOver = isMouseOver();

    if (mousePressed && mouseOver)
      locked = true;
    
    if (!mousePressed)
      locked = false;
    
    if (locked)
      newSliderPosition = Utils.clamp(mouseX - barHeight/2, sliderPositionMin, sliderPositionMax);
    
    if (abs(newSliderPosition - sliderPosition) > 1)
      sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
    
  }

  
  /**
  * @brief Gets whether the mouse is hovering the scrollbar
  *
  * @return Whether the mouse is hovering the scrollbar
  */
  boolean isMouseOver() {
    return (mouseX > xPosition && mouseX < xPosition+barWidth &&
      mouseY > yPosition && mouseY < yPosition+barHeight);
  }
  
  /**
  * @brief Draws the scrollbar in its current state
  */
  void display() {
    scrollBar.beginDraw();
    scrollBar.noStroke();
    scrollBar.fill(204);
    scrollBar.rect(xPosition, yPosition, barWidth, barHeight);
    
    if (mouseOver || locked) 
      scrollBar.fill(0, 0, 0);
    else 
      scrollBar.fill(102, 102, 102);

    scrollBar.rect(sliderPosition, 0, barHeight, barHeight);
    //scrollBar.rect(sliderPosition, yPosition, barHeight, barHeight);
    scrollBar.endDraw();
  }
  
  PGraphics getGraphics() {
     display();
     return scrollBar; 
  }
  
  /**
  * @brief Gets the slider position
  *
  * @return The slider position in the interval [0,1]
  * corresponding to [leftmost position, rightmost position]
  */
  float getPos() {
    return (sliderPosition - xPosition)/(barWidth - barHeight);
  }
}