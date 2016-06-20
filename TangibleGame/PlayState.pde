import processing.video.*;

class PlayState extends State {
  private final String name = "PlayState";
  private final boolean isPopup = false;

  private Movie cam;
  //private Capture cam;
  private TwoDThreeD transCoord;

  @Override
  public void onLoad() {
    cam = new Movie(app, "testvideo.mp4");
    cam.loop();
  }

  @Override
  public void onUpdate(float dt) {
      if (cam.available()) {
          if (transCoord == null)
              transCoord = new TwoDThreeD(cam.width, cam.height);
          if (filter == null)
              filter = new Filter(cam);

          cam.read();
          cam.loadPixels();

          List<PVector> corners = detectCorners(cam.get());
          println("Found corners: " + corners.size());
          if (!corners.isEmpty()) {
              plate.rot = transCoord.get3DRotations(corners);
              println("Rotation: x " + plate.rot.x + " y " + plate.rot.y + " z " + plate.rot.z);
              plate.rot.z -= PI/2;
              plate.clampRotation();
              
          }
      }
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
      image(cam.get(), 0, 0);
    popMatrix();

    lights();

    if (keyPressed && keyCode == CONTROL)
      aboveCamera();

    plate.display();
    ballMover.display();


  }

  @Override
  public void onLoseFocus() {
    cam.pause();
  }

  @Override
  public void onFocus() {
    cam.loop();
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