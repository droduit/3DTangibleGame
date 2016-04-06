void defaultCamera() {
  camera();
}

void aboveCamera() {
  camera(
    width/2.0, -height / 3.0, 0,
    width/2.0, 0, 0,
    0, 0, 1
  );
}