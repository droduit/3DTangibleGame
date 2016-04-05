class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    strokeWeight(5);
    for (int i=7; i >= 0; --i) { // Reverse order to print background points first
      int d = i/4*100;
      if (i != 3 && i != 7) {// edge with the next point (6 edges)
        stroke(186-d,12+2*d,180);
        line(s[i].x,s[i].y,s[i+1].x,s[i+1].y);
      }
      else { // closing loop (2 edges)
        stroke(186-d,12+2*d,180);
        line(s[i].x,s[i].y,s[i-3].x,s[i-3].y);
      }

      if (i <= 3) { // edge in depth (4 edges)
        stroke(23,2,233);
        line(s[i].x,s[i].y,s[i+4].x,s[i+4].y);
      }
    }
  }
}