class input {
  boolean shoot;
  boolean dash;
  boolean up;
  boolean down;
  boolean right;
  boolean left;
  public input(boolean _shoot, boolean _dash, boolean _up, boolean _down, boolean _right, boolean _left) {
    shoot = _shoot;
    dash = _dash;
    up = _up;
    down = _down;
    right = _right;
    left = _left;
  }
  
  public input copy() {
    return new input(shoot, dash, up, down, right, left);
  }
}
