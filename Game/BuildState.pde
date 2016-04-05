class BuildState extends State {
  private final String name = "BuildState";
  private final boolean isPopup = false;
  
  @Override
  public void onFocus() {
    plate.shiftMode(true);
  }
  
  @Override
  public void onDraw() {
    cursor(ARROW);
    
    pushMatrix();
    
    plate.displayInfo();
    plate.display();
    
    ballMover.display();
    
    popMatrix();
  }
  
  @Override
  public void onUpdate(float dt) {}
  
  @Override
  public void mousePressed() {
    if (mouseButton == LEFT)
      plate.addObstacle();
  }
  
  @Override
  public void keyReleased() {
    if (key == CODED && keyCode == SHIFT)
      stateManager.pop();
  }
}