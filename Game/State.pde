class State {
  private final String name = "State";
  private final boolean isPopup = false;
  
  public boolean isPopup() { return this.isPopup; }
  
  public void onLoad() {
    println("WARNING - onLoad not implemented for state '" + this.name + '"');
  }
  
  public void onFocus() {
    println("WARNING - onFocus not implemented for state '" + this.name + '"');
  }
    
  public void onLoseFocus() {
    println("WARNING - onLoseFocus not implemented for state '" + this.name + '"');
  }
  
  public void onUnload() {
    println("WARNING - onUnload not implemented for state '" + this.name + '"');
  }

  public void onUpdate(float dt) {
    println("WARNING - onUpdate not implemented for state '" + this.name + '"');
  }

  public void onDraw() {
    println("WARNING - onDraw not implemented for state '" + this.name + '"');
  }
  
  // Keyboard Events
  public void keyPressed() {}
  public void keyReleased() {}
  public void keyTyped() {}
  
  // Mouse Events
  public void mousePressed() {}
  public void mouseReleased() {}
  public void mouseClicked() {}
  public void mouseMoved() {}
  public void mouseDragged() {}
  public void mouseWheel(MouseEvent event) {}
}