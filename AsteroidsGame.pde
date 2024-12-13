import java.util.*;
//6
boolean[] keys = new boolean[91];

int mode = 0;

float _random(float a, float b) {
  return (float)(Math.random()*(b-a)+a);
}

float _dist(float[] a, float[] b) {
  return dist(a[0],a[1],b[0],b[1]);
}

int count=0;
int count2=0;
int shots=0;
int frameNum=0;
int totalAsteroids = 620;
boolean bullets=false;
boolean breakAsteroids=true;
boolean controls=true; //new=true
boolean laser=false;
ship s;
ArrayList <rock> rocks = new ArrayList <rock>();
ArrayList <particle> particles = new ArrayList <particle>();
ArrayList <input> allInputs = new ArrayList <input>();
ArrayList <input> currentInputs = new ArrayList <input>();
ArrayList <input> bestInputs = new ArrayList <input>();
int best=0;
int tempScore=0;
int iterations=0;
input currentInput;
star[] stars = new star[20];
savestate state1;
savestate bestState;
savestate startState;
int replayFrame=0;

void setup() {
  size(1500,800);
  s = new ship(width/2,height/2);
  for (int i=0;i<20;i++) { //20
    rocks.add(new rock(50,new float[]{_random(0,width),_random(0,height)}));
  }
  for (int i=0;i<stars.length;i++) {
    stars[i] = new star();
  }
}

void draw() {
  background(0);
  if (mode==0) currentInput = new input(false,false,Math.random()>0.5,Math.random()>0.5,Math.random()>0.5,Math.random()>0.5);
  if (mode==1) {
    if (replayFrame<allInputs.size()) {
      currentInput = allInputs.get(replayFrame);
    } else {
      currentInput = new input(false,false,false,false,false,false);
    }
    replayFrame++;
  }
  frame();
  if (frameCount==1) {
    state1 = saveState();
    startState = saveState();
  }
  if (mode==0) {
    currentInputs.add(currentInput);
    frameNum++;
    if (frameNum>=60) {
      frameNum=0;
      tempScore=count+count2; //weight small asteroids more
      if (tempScore>=best) {
        best=tempScore;
        bestInputs = copyInputs(currentInputs);
        bestState = saveState();
      }
      iterations++;
      if (iterations>10) {
        for (int i=0;i<bestInputs.size();i++) {
          allInputs.add(bestInputs.get(i));
        }
        bestInputs.clear();
        loadState(bestState);
        state1 = saveState();
        iterations=0;
      }
      loadState(state1);
      currentInputs.clear();
    }
  }
}

void frame() {
  for (int i=0;i<stars.length;i++) {
    star a = stars[i];
    a.move();
    a.show();
  }
  s.moveStepEachFrame();
  s.show();
  for (int i=0;i<rocks.size();i++) {
    rock a = (rock)rocks.get(i);
    a.move();
    a.show();
    for (int j=0;j<particles.size();j++) {
      //particle b = particles.get(j);
      if (_dist(a.getPos(),particles.get(j).getPos())<a.getSize()/2) {
        float _size=a.getSize();
        float[] _pos=a.getPos();
        rocks.remove(i);
        count++;
        if (_size>10&&breakAsteroids) {
          rocks.add(i,new rock(_size/1.5,_pos));
          rocks.add(i,new rock(_size/1.5,_pos));
          i++;
        } else {
          i--;
          smallAsteroidBroken();
        }
        particles.remove(j);
        break;
      }
    }
    if (_dist(a.getPos(),s.getPos())<a.getSize()/2) {
      if (bullets) {
        end();
      } else {
        float _size=a.getSize();
        float[] _pos=a.getPos();
        rocks.remove(i);
        count++;
        if (breakAsteroids&&_size>10) {
          rocks.add(i,new rock(_size/1.5,_pos));
          rocks.add(i,new rock(_size/1.5,_pos));
          i++;
        } else {
          i--;
          smallAsteroidBroken();
        }
      } //true, bat, ant, bat, [dog, cat]
    }
  }
  for (int i=0;i<particles.size();i++) {
    particle a = (particle)particles.get(i);
    a.move();
    a.show();
    
    if (a.check()) {
      particles.remove(i);
      i--;
    }
  }
  /*fill(255);
  stroke(128);
  rect(25,75,300,300);
  fill(0);
  noStroke();
  textAlign(CENTER,CENTER);
  text("Asteroids hit: "+Integer.toString(count)+"\n"+Integer.toString(count2)+" small asteroids broken\n"+(bullets?"Shots used: "+Integer.toString(shots)+"\n"+Integer.toString(shots-count)+"bullets currently on screen\nShots":"Hits")+" required to break all asteroids: "+Integer.toString(totalAsteroids),150,200);
  text(count2,50,150);*/
}

void smallAsteroidBroken() {
  count2++;
  if (count==totalAsteroids) {
    goodEnd();
  }
}

void keyPressed() {
  if (keyCode<keys.length) keys[keyCode]=true;
  if (key=='s') {
    mode=1;
    loadState(startState);
  }
}

void keyReleased() {
  if (keyCode<keys.length) {
    keys[keyCode]=false;  
  }
}

void reset() {
  count=0;
  count2=0;
  shots=0;
  particles.clear();
  rocks.clear();
  setup();
  loop();
}

void end() {
  fill(0,128);
  noStroke();
  rect(0,0,width,height);
  fill(255);
  stroke(128);
  rect(mouseX-100,mouseY-50,200,100);
  noStroke();
  fill(0);
  textAlign(CENTER,CENTER);
  text("Asteroids hit:"+Integer.toString(count),mouseX,mouseY-25);
  text(Integer.toString(count2)+" of those were the smallest size",mouseX,mouseY);
  text("You used "+Integer.toString(shots)+" bullets",mouseX,mouseY+25);
  noLoop();
}

void goodEnd() {
  fill(0,128);
  noStroke();
  rect(0,0,width,height);
  fill(255);
  stroke(128);
  rect(mouseX-200,mouseY-50,400,100);
  noStroke();
  fill(0);
  textAlign(CENTER,CENTER);
  text("You got all "+Integer.toString(count)+" asteroids,\n\nincluding "+Integer.toString(count2)+" asteroids of the smallest size.\n\nYou used "+Integer.toString(shots)+" bullets",mouseX,mouseY);
  noLoop();
}

ArrayList <rock> copyRocks(ArrayList <rock> _rocks) {
  ArrayList <rock> newRocks = new ArrayList <rock>();
  for (int i=0;i<_rocks.size();i++) {
    newRocks.add(_rocks.get(i).copy());
  }
  return newRocks;
}

ArrayList <particle> copyParticles(ArrayList <particle> _particles) {
  ArrayList <particle> newParticles = new ArrayList <particle>();
  for (int i=0;i<_particles.size();i++) {
    newParticles.add(_particles.get(i).copy());
  }
  return newParticles;
}

ArrayList <input> copyInputs(ArrayList <input> _inputs) {
  ArrayList <input> newInputs = new ArrayList <input>();
  for (int i=0;i<_inputs.size();i++) {
    newInputs.add(_inputs.get(i).copy());
  }
  return newInputs;
}

savestate saveState() {
  return new savestate(count, count2, shots, totalAsteroids, bullets, breakAsteroids, controls, laser, s, rocks, particles, stars);
}

void loadState(savestate state) {
  count = state.count;
  count2 = state.count2;
  shots = state.shots;
  totalAsteroids = state.totalAsteroids;
  bullets = state.bullets;
  breakAsteroids = state.breakAsteroids;
  controls = state.controls;
  laser = state.laser;
  s = state.s.copy();
  rocks = copyRocks(state.rocks);
  particles = copyParticles(state.particles);
  stars = Arrays.copyOf(state.stars,state.stars.length);
}
