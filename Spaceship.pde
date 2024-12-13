class ship extends Floater {
  private boolean dashing;
  private int dashTimer;
  private float maxSpeed;
  public static final float power = 1;
  
  public ship(float _x, float _y) {
    col=255;
    x=_x;
    y=_y;
    dx=0;
    dy=0;
    dir=0;
    dashing=false;
    corners=32;
    cx = new int[]{-4,-5,-5,-4,-3,-1, 0, 2, 3, 7, 8, 6, 2, -6,-6,-7,-7,-6,-6,2,6,8,7,3,2,0,-1,-3,-4,-5,-5,-4,-6,-6};
    cy = new int[]{-7,-8,-9,-8,-9,-7,-8,-6,-7,-3,-4,-6,-8,-10,-2,-2, 2, 2,10,8,6,4,3,7,6,8, 7, 9, 8, 9, 8, 7, 1,-1};
  }
  
  public ship(int _col, float _x, float _y, float _dx, float _dy, float _dir, boolean _dashing, int _dashTimer, float _maxSpeed, int _corners) {
    col = _col;
    x = _x;
    y = _y;
    dx = _dx;
    dy = _dy;
    dir = _dir;
    dashing = _dashing;
    dashTimer = _dashTimer;
    maxSpeed = _maxSpeed;
    corners = _corners;
    cx = new int[]{-4,-5,-5,-4,-3,-1, 0, 2, 3, 7, 8, 6, 2, -6,-6,-7,-7,-6,-6,2,6,8,7,3,2,0,-1,-3,-4,-5,-5,-4,-6,-6};
    cy = new int[]{-7,-8,-9,-8,-9,-7,-8,-6,-7,-3,-4,-6,-8,-10,-2,-2, 2, 2,10,8,6,4,3,7,6,8, 7, 9, 8, 9, 8, 7, 1,-1};
  }
  
  public ship copy() {
    return new ship(col, x, y, dx, dy, dir, dashing, dashTimer, maxSpeed, corners);
  }
  
  public void moveStepEachFrame() {
    if (controls) {
      if (currentInput.up) {
        dy-=power;
      }
      if (currentInput.down) {
        dy+=power;
      }
      if (currentInput.right) {
        dx-=power;
      }
      if (currentInput.left) {
        dx+=power;
      }
      if (dx!=0) {
        dir = atan((float)(dy/dx));
      } else if (dy>0) {
        dir = PI/2;
      } else if (dy<0) {
        dir = 3*PI/2;
      }
      if (dx<0) {
        dir += PI;
      }
    } else {
      if (keys[87]) {
        accelerate(0.5);
      }
      if (keys[83]) {
        accelerate(-0.5);
      }
      if (keys[65]) {
        turn(-5);
      }
      if (keys[68]) {
        turn(5);
      }
    }
    dashTimer-=dashing?1:0;
    dashing=dashing&&dashTimer>0;
    fill(255);
    float sp=dist(dx,dy,0,0);
    text(sp,50,50);
    float friction = 1;
    dx*=dashing?0.98:friction;
    dx*=dashing?0.98:friction;
    maxSpeed = 6.666;
    dx=sp>maxSpeed&&!dashing?dx*maxSpeed/sp:dx; //these two lines are to make sure that the spaceship cannot gain too much speed.
    dy=sp>maxSpeed&&!dashing?dy*maxSpeed/sp:dy; //this caps the player's speed at maxSpeed.
    move();
  }
  
  public float[] getPos() {
    return new float[]{x,y};
  }
  
  public float getD() {
    return dir;
  }
  
  public float[] getVelocity() {
    return new float[]{dx,dy};
  }
  
  public void dash() {
    dashing=true;
    dashTimer=10;
    dx=cos(dir)*10;
    dy=sin(dir)*10;
  }
  
  public void warp() {
    dx=_random(0,width);
    dy=_random(0,height);
    dx=0;
    dy=0;
    dir=_random(0,2*PI);
  }
}
