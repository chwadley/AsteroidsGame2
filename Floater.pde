class Floater {//Do NOT modify the Floater class! Make changes in the Spaceship class 
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] cx; //x coordinates of the corners  
  protected int[] cy; //y coordinates of the corners
  protected int col; //fill color of the floater  
  protected float x, y; //center coordinates. It is better to make this a float since Processing's drawing functions do not accept doubles. Declaring these variables as floats will reduce required casting.
  protected float dx, dy; //x and y velocities
  protected float dir; //direction the ship is pointing in radians    

  //accelerates the floater in the direction it is pointing (dir)   
  public void accelerate(float dAmount) {          
    //change the x and y speed based on the facing angle
    dx += dAmount * Math.cos(dir);    
    dy += dAmount * Math.sin(dir);       
  }
  
  public void turn(double angle) { //rotates the floater by a given number of degrees
    dir+=angle;
  }
  
  public void move() { //move the floater in the current direction of travel    
    //change the x and y coordinates by dx and dy       
    x += dx;
    y += dy;
    //wrap around screen on the sides
    if (x > width) {     
      x = 0;    
    } else if (x<0) {     
      x = width;    
    }
    //wrap around screen on the top and bottom
    if (y > height) {    
      y = 0;    
    } else if (y < 0) {     
      y = height;    
    }
  }
  
  public void show() { //draws the floater at the current position          
    fill(col);
    
    push();
    //translate the (x,y) center of the ship to the correct position
    translate(x,y);
    
    //rotate so that the polygon will be drawn in the correct direction
    rotate(dir);
    
    //draw the ship
    beginShape();
    for (int i = 0; i < corners; i++) {
      vertex(cx[i], cy[i]);
    }
    endShape(CLOSE);

    //instead of "unrotating" and "untranslating," we can just use Processing's push() and pop() functions which automates this.
    pop();
  }   
}
