public static class Utils {
  public static final float g = 9.81;
  
  /**
  * @brief Clamps the value into the interval
  *
  * @param val The value to be clamped
  * @param minVal Smallest value possible
  * @param maxVal Largest value possible
  *
  * @return val clamped into the interval [minVal, maxVal]
  */
  public static int clamp (int val, int min, int max) {
    return Math.max(min, Math.min(val, max));
  }
  
  public static float clamp (float val, float min, float max) {
    return Math.max(min, Math.min(val, max));
  }
}