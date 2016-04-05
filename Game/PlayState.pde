class PlayState extends State {
  private final String name = "PlayState";
  private final boolean isPopup = false;

  @Override
  public void onFocus() {
    plate.shiftMode(false);
  }

  @Override
  public void onUpdate(float dt) {
    ballMover.update(dt);
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
  public void mouseDragged() {
    plate.mouseDraggedEvent();
  }
  
  @Override
  public void mouseWheel(MouseEvent event) {
    plate.mouseWheelEvent(event.getCount());
  }
  
  @Override
  public void keyPressed() {
    if (key == CODED && keyCode == SHIFT)
      stateManager.push(new BuildState());
  }
}