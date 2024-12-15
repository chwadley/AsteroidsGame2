class rock extends Floater {
  private float size;
  private float rotVel;
  public rock(float _size, float[] _pos) {
    col = 255;
    x = _pos[0];
    y = _pos[1];
    dir = _random(0,2*PI);
    dx = (float)Math.cos(dir)*3;
    dy = (float)Math.sin(dir)*3;
    size = _size;
    corners = 6;
    cx = new int[corners];
    cy = new int[corners];
    rotVel = radians(_random(-5,5));
    for (int i=0;i<corners;i++) {
      float _d = _random(size/2,size);
      cx[i] = (int)(Math.cos(i*2*PI/corners)*_d/2);
      cy[i] = (int)(Math.sin(i*2*PI/corners)*_d/2);
    }
  }
  
  public rock(int _col, float _x, float _y, float _dir, float _dx, float _dy, float _size, int _corners, int[] _cx, int[] _cy, float _rotVel) {
    col = _col;
    x = _x;
    y = _y;
    dir = _dir;
    dx = _dx;
    dy = _dy;
    size = _size;
    corners = _corners;
    cx = copyArray(_cx);
    cy = copyArray(_cy);
    rotVel = _rotVel;
  }
  
  public rock copy() {
    return new rock(col, x, y, dir, dx, dy, size, corners, cx, cy, rotVel);
  }
  
  public void move() {
    turn(rotVel);
    super.move();
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
  
  public float[] getPos() {
    return new float[]{(float)x,(float)y};
  }
  
  public float getSize() {
    return size;
  }
}
