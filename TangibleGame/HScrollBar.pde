class HScrollbar {
  private PGraphics scrollBar;
  private float barWidth; //Bar's width in pixels
  private float barHeight; //Bar's height in pixels
  private float xPosition; //Bar's x position in pixels
  private float yPosition; //Bar's y position in pixels
  private float sliderPosition, newSliderPosition; //Position of slider
  private float sliderPositionMin, sliderPositionMax; //Max and min values of slider
  private boolean mouseOver; //Is the mouse over the slider?
  private boolean locked; //Is the mouse clicking and dragging the slider now?
 
  /**
  * @brief Creates a new horizontal scrollbar
  *
  * @param x The x position of the top left corner of the bar in pixels
  * @param y The y position of the top left corner of the bar in pixels
  * @param w The width of the bar in pixels
  * @param h The height of the bar in pixels
  */
  public HScrollbar (float x, float y, float w, float h) {
    scrollBar = createGraphics((int)w, (int)h,P2D);
    
    barWidth = w;
    barHeight = h;
    
    xPosition = x;
    yPosition = y;
    
    sliderPosition = barWidth/2 - barHeight/2;
    newSliderPosition = sliderPosition;
    
    sliderPositionMin = 0;
    sliderPositionMax =  barWidth - barHeight;
  }
  
  /**
  * @brief Updates the state of the scrollbar according to the mouse movement
  */
  private void updateSlider() {
    mouseOver = isMouseOver();

    if (mousePressed && mouseOver)
      locked = true;
    
    if (!mousePressed)
      locked = false;
      
    if (locked)
      newSliderPosition = Utils.clamp(mouseX - xPosition - barHeight/2, sliderPositionMin, sliderPositionMax);

    if (abs(newSliderPosition - sliderPosition) > 1)
      sliderPosition = newSliderPosition;
  }

  
  /**
  * @brief Gets whether the mouse is hovering the scrollbar
  *
  * @return Whether the mouse is hovering the scrollbar
  */
  public boolean isMouseOver() {
    return (mouseX > xPosition && mouseX < xPosition+barWidth &&
    mouseY > yPosition && mouseY < yPosition+barHeight);
  }
  
  /**
  * @brief Draws the scrollbar in its current state
  */
  private void updateScrollBar() {
    scrollBar.beginDraw();
    scrollBar.noStroke();
    scrollBar.fill(204);
    scrollBar.clear();
    scrollBar.rect(xPosition, yPosition, barWidth, barHeight);
    
    if (mouseOver || locked) 
      scrollBar.fill(0, 0, 0);
    else 
      scrollBar.fill(102, 102, 102);

    scrollBar.rect(sliderPosition, 0, barHeight, barHeight);
    scrollBar.endDraw();
  }
  
  public PGraphics getGraphics() {
    updateSlider();
    updateScrollBar();;   return scrollBar; 
  }
  
  /**
  * @brief Gets the slider position
  *
  * @return The slider position in the interval [0,1]
  * corresponding to [leftmost position, rightmost position]
  */
  public float getPos() {
    return (sliderPosition)/(barWidth - barHeight);
  }
}