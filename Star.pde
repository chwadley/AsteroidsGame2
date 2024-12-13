class star extends Floater {
  public star() {
    col = 255;
    x = _random(0,width);
    y = _random(0,height);
    dir = _random(0,2*PI);
    dx = (float)Math.cos(dir);
    dy = (float)Math.sin(dir);
  }
  
  public star(int _col, float _x, float _y, float _dir, float _dx, float _dy) {
    col = _col;
    x = _x;
    y = _y;
    dir = _dir;
    dx = _dx;
    dy = _dy;
  }
  
  public star copy() {
    return new star(col, x, y, dir, dx, dy);
  }
  
  public void show() {
    stroke(255);
    noFill();
    ellipse(x,y,5,5);
  }
  
  public void bounce() {
    if (x<0) {
      x=0;
      dx*=-1;
    }
    if (x>width) {
      x=width;
      dx*=-1;
    }
    if (y<0) {
      y=0;
      dy*=-1;
    }
    if (y>height) {
      y=height;
      dy*=-1;
    }
  }
}
