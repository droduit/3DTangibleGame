class BuildState extends State {
  private final String name = "BuildState";
  private final boolean isPopup = false;
  
  private PVector plateRotation = null;
  private PShape ghostCylinder = null;
  private color validPosColor = color(50, 200, 50, 100);
  private color invalidPosColor = color(200, 50, 50, 100);
  
  @Override
  public void onLoad() {
    plateRotation = plate.rotation();
    plate.rotation(new PVector(0f, 0f, 0f));

    ghostCylinder = new Cylinder().getShape();
  }
  
  @Override
  public void onUnload() {
    plate.rotation(plateRotation);
  }
  
  @Override
  public void onDraw() {
    cursor(ARROW);
    
    defaultCamera();
    plate.displayInfo();
    
    aboveCamera();
    plate.display();

    if (plate.isValidObstaclePosition(mouseX, mouseY))
      ghostCylinder.setFill(validPosColor);
    else
      ghostCylinder.setFill(invalidPosColor);

    pushMatrix();
    translate(mouseX - plate.pos.x, 0, mouseY - plate.pos.y);
    shape(ghostCylinder);
    popMatrix();
    
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