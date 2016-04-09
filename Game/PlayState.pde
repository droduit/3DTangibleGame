class PlayState extends State {
  private final String name = "PlayState";
  private final boolean isPopup = false;

  @Override
  public void onUpdate(float dt) {
    ballMover.update(dt);
  }
  
  @Override
  public void onDraw() {
    cursor(ARROW);
    
    defaultCamera();
    plate.displayInfo();
    
    pushMatrix();
      noLights();
      statsView.drawAll();
    popMatrix();
    
    lights();
    
    if (keyPressed && keyCode == CONTROL)
      aboveCamera();
      
    plate.display();
    ballMover.display();
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