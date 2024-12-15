class savestate {
  int count;
  int count2;
  int shots;
  int totalAsteroids;
  boolean bullets;
  boolean breakAsteroids;
  boolean controls;
  boolean laser;
  ship s;
  ArrayList <rock> rocks = new ArrayList <rock>();
  ArrayList <particle> particles = new ArrayList <particle>();
  star[] stars = new star[20];
  boolean dead;
  boolean complete;
  boolean paused;
  public savestate(int _count, int _count2, int _shots, int _totalAsteroids, boolean _bullets, boolean _breakAsteroids, boolean _controls, boolean _laser, ship _s, ArrayList <rock> _rocks, ArrayList <particle> _particles, star[] _stars, boolean _dead, boolean _complete, boolean _paused) {
    count = _count;
    count2 = _count2;
    shots = _shots;
    totalAsteroids = _totalAsteroids;
    bullets = _bullets;
    breakAsteroids = _breakAsteroids;
    controls = _controls;
    laser = _laser;
    s = _s.copy();
    rocks = copyRocks(_rocks);
    particles = copyParticles(_particles);
    stars = Arrays.copyOf(_stars,_stars.length);
    dead = _dead;
    complete = _complete;
    paused = _paused;
  }
}
