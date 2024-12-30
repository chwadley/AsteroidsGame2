class particle extends Floater {
  public particle(float[] pos,float d,float[] momentum) {
    col = 255;
    x = pos[0];
    y = pos[1];
    dir = d;
    size=5;
    dx = (float)Math.cos(dir)*10+momentum[0];
    dy = (float)Math.sin(dir)*10+momentum[1];
  }
  
  public particle(int _col, float _x, float _y, float _dir, float _dx, float _dy) {
    col = _col;
    x = _x;
    y = _y;
    dir = _dir;
    size = 5;
    dx = _dx;
    dy = _dy;
  }
  
  public particle copy() {
    return new particle(col, x, y, dir, dx, dy);
  }
  
  public void show() {
    noStroke();
    fill(255);
    ellipse(x,y,size,size);
  }
  
  public boolean check() {
    return x<0||x>width||y<0||y>height;
  }
}
