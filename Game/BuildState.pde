class BuildState extends State {
  private final String name = "BuildState";
  private final boolean isPopup = false;
  
  @Override
  public void onDraw() {
    cursor(ARROW);
    
    defaultCamera();
    plate.displayInfo();
    
    aboveCamera();
    plate.display();
    ballMover.display();
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