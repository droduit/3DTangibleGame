public static class Utils {
  public static final float g = 9.81;
  
  public static int clamp (int val, int min, int max) {
    return Math.max(min, Math.min(val, max));
  }
  
  public static float clamp (float val, float min, float max) {
    return Math.max(min, Math.min(val, max));
  }
}