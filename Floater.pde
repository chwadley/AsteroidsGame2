class Floater {
  protected int corners,col;
  protected int[] cx,cy;
  protected float x,y,dx,dy,dir,size;
   
  public void accelerate(float n) {
    dx += n * Math.cos(dir);    
    dy += n * Math.sin(dir);       
  }
  
  public void turn(double a) {
    dir+=a;
  }
  
  public void move() {       
    x += dx;
    y += dy;
    x=x>width?0:x<0?width:x;
    y=y>height?0:y<0?height:y;
  }
  
  public void show() {
    fill(col);
    translate(x,y);
    rotate(dir);
    beginShape();
    for (int i = 0; i < corners; i++) vertex(cx[i], cy[i]);
    endShape(CLOSE);
    rotate(-dir);
    translate(-x,-y);
  }
  
  public float[] getPos() {
    return new float[]{x,y};
  }
  
  public float getSize() {
    return size;
  }
  
  public float[] getVelocity() {
    return new float[]{dx,dy};
  }
}
