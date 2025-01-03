boolean[] keys = new boolean[223];
boolean[] keyPresses = new boolean[223];

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
int totalAsteroids=0;
boolean bullets=false;
boolean breakAsteroids=true;
boolean controls=true; //new=true
boolean laser=false;
ship s;
ArrayList <rock> rocks = new ArrayList <rock>();
ArrayList <particle> particles = new ArrayList <particle>();
star[] stars = new star[20];
boolean dead = false;
boolean complete = false;
boolean paused = false;
savestate state1;
input currentInput;
boolean tas = false;
float currentDir,targetDir;
float time;

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
  if (mode<4) {
    stroke(255);
    fill(0);
    rect(width/2-200,height/2-50,400,100);
    textAlign(CENTER,CENTER);
    fill(255);
    noStroke();
  }
  if (mode==0) {
    text("Run into asteroids to break them (indestructible ship)",width/2,height/2-25);
    text("Bullets break asteroids (destructible ship)",width/2,height/2+25);
    stroke(255);
    fill(0);
    rect(width/2-200,height/2+75,400,50);
    fill(255);
    noStroke();
    text("Or, see an optimal speedrun of this game",width/2,height/2+100);
  }
  if (mode==1) {
    text("Asteroids break into smaller ones",width/2,height/2-25);
    text("Asteroids immediately disappear when broken",width/2,height/2+25);
  }
  if (mode==2) {
    text("Ship moves in the direction you input with WASD",width/2,height/2-25);
    text("A/D turns the ship",width/2,height/2+25);
  }
  if (mode==3) {
    text("Shoots one bullet at a time",width/2,height/2-25);
    text("Shoots a continuous laser beam",width/2,height/2+25);
  }
  if (mode==4) {
    //find the closest asteroid
    if (totalAsteroids==0) {
      totalAsteroids = breakAsteroids?rocks.size()*31:rocks.size();
    }
    if (rocks.size()>0) {
      float best=10000;
      rock bestRock = rocks.get(0);
      float[] targetPos = new float[]{1113910203,1923094859};
      float[] pos = s.getPos();
      for (int i=0;i<rocks.size();i++) {
        rock a = rocks.get(i);
        float _d = _dist(pos,a.getPos());
        if (_d<=best) {
          best=_d;
          targetPos=a.getPos();
          bestRock=a;
        }
      }
      //accelerate in the direction of the asteroid
      float xAcc = pos[0]-targetPos[0];
      float yAcc = pos[1]-targetPos[1];
      float[] vel = s.getVelocity();
      currentDir = s.getD();
      targetDir = atan(yAcc/xAcc);
      targetDir += xAcc>0?PI:0;
      currentInput = new input(tas?false:keys[76],tas?false&&(best>100&&bestRock.getSize()<40):keys[44],tas?yAcc+vel[1]>0:keys[87],tas?yAcc+vel[1]<0:keys[83],tas?xAcc+vel[0]<0:keys[65],tas?xAcc+vel[0]>0:keys[68]);
    }
    if (!(dead||complete||paused)) physics(currentInput);
    display();
    if (false&&tas) {
      stroke(255);
      strokeWeight(3);
      line(500,500,500+cos(currentDir)*50,500+sin(currentDir)*50);
      line(500,500,500+cos(targetDir)*50,500+sin(targetDir)*50);
      strokeWeight(1);
    }
    if (dead) end();
    if (complete) goodEnd();
    if (paused) pauseMenu();
  }
}

void physics(input _input) {
  if (_input.dash) s.dash();
  for (int i=0;i<stars.length;i++) {
    stars[i].move();
  }
  s.moveStepEachFrame();
  if (_input.shoot&&bullets&&laser) {
    particles.add(new particle(s.getPos(),s.getD(),s.getVelocity()));
    shots++;
  }
  for (int i=0;i<rocks.size();i++) {
    rock a = (rock)rocks.get(i);
    a.move();
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
        dead=true;
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
    if (a.check()) {
      particles.remove(i);
      i--;
    }
  }
}

void display() {
  for (int i=0;i<stars.length;i++) {
    stars[i].show();
  }
  s.show();
  for (int i=0;i<rocks.size();i++) {
    rocks.get(i).show();
  }
  for (int i=0;i<particles.size();i++) {
    particles.get(i).show();
  }
  fill(255);
  stroke(128);
  rect(5,5,300,100);
  fill(0);
  noStroke();
  textAlign(CENTER,CENTER);
  text("Asteroids hit: "+count+"\n"+count2+" small asteroids broken\n"+(bullets?"Shots used: "+shots+"\n"+(shots-count)+" bullets currently on screen\nShots":"Hits")+" required to break all asteroids: "+totalAsteroids,
  155,55);
  if (count>=totalAsteroids) {
    goodEnd();
  }
  //text(count2,50,150);
  
  /*fill(255);
  stroke(128);
  int h=100;
  int h2=70;
  rect(5,height-(h+5),300,h);
  fill(255,0,0);
  rect(10,height-h2,290,h2-10);
  float[] temp_percents = new float[5]; //50, 33, 22, 14, 9
  for (int i=0;i<rocks.size();i++) {
    temp_percents[rocks.get(i).getSizeIndex()]++;
  }
  float[] percents = new float[temp_percents.length];
  for (int i=0;i<percents.length;i++) {
    percents[i] = sumPartialArray(temp_percents,i+1);
  }
  text(Arrays.toString(percents),500,500);
  //float[] percents = new float[]{0.3,0.5,0.7,0.8,1};
  for (int i=percents.length-1;i>=0;i--) {
    fill(255*i/(percents.length-1));
    //percents[i] /= rocks.size();
    rect(10,height-h2,percents[i]*290/rocks.size(),h2-10);
  }*/
  fill(currentInput.right?255:128);
  stroke(255);
  rect(5,405,40,40);
  fill(currentInput.down?255:128);
  rect(45,405,40,40);
  fill(currentInput.left?255:128);
  rect(85,405,40,40);
  fill(currentInput.up?255:128);
  rect(45,365,40,40);
}

float sumPartialArray(float[] arr,int l) {
  float sum=0;
  for (int i=0;i<l;i++) sum+=arr[i];
  return sum;
}

void pauseMenu() {
  noStroke();
  fill(0,128);
  rect(0,0,width,height);
  fill(255);
  textAlign(CENTER,CENTER);
  text("Space to unpause",width/2,height/2);
}

void smallAsteroidBroken() {
  count2++;
  if (count==totalAsteroids) {
    complete = true;
    time = frameCount;
    goodEnd();
  }
}

void keyPressed() {
  //System.out.println(keyCode);
  if (tas?false:(keyCode==76&&!keys[76]&&!laser&&bullets)) {
    particles.add(new particle(s.getPos(),s.getD(),s.getVelocity()));
    shots++;
  }
  if (tas?false:(keyCode==32&&!keys[32])) {
    paused = !paused;
  }
  if (tas?false:key==',') s.dash();
  if (tas?false:(key=='r'&&!keys[82])) reset();
  if (tas?false:(keyCode==10&&!keys[10])) s.warp();
  if (tas?false:key==';'&&!keys[59]) {
    noLoop();
    loadState(state1);
    loop();
  }
  if (tas?false:key=='\''&&!keys[222]) state1=saveState();
  if (keyCode<keys.length) keys[keyCode]=true;
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
  dead = false;
  complete = false;
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
  text("Asteroids hit: "+count,mouseX,mouseY-25);
  text(count2+" of those were the smallest size",mouseX,mouseY);
  text("You used "+shots+" bullets",mouseX,mouseY+25);
  dead=true;
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
  text("You got all "+count+" asteroids,\n\nincluding "+count2+" asteroids of the smallest size."+(bullets?"\n\nYou used "+shots+" bullets":"")+"\n\nTime: "+round(time/6)/10f+" seconds",mouseX,mouseY);
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

int[] copyArray(int[] _array) {
  int[] newArray = new int[_array.length];
  for (int i=0;i<_array.length;i++) {
    newArray[i] = _array[i];
  }
  return newArray;
}

star[] copyStars(star[] _array) {
  star[] newArray = new star[_array.length];
  for (int i=0;i<_array.length;i++) {
    newArray[i] = _array[i];
  }
  return newArray;
}

savestate saveState() {
  return new savestate(count, count2, shots, totalAsteroids, bullets, breakAsteroids, controls, laser, s, rocks, particles, stars, dead, complete, paused);
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
  stars = copyStars(state.stars);
  dead = state.dead;
  complete = state.complete;
  paused = state.paused;
}

void mousePressed() {
  if (mouseX>=width/2-200&&mouseX<=width/2+200&&mouseY>=height/2-50&&mouseY<=height/2+50) {
    if (mouseY>height/2) {
      if (mode==0) {
        bullets = true;
      } else if (mode==1) {
        breakAsteroids = false;
      } else if (mode==2) {
        controls = false;
      } else if (mode==3) {
        laser = true;
      }
    }
    if (mode==3) {
      totalAsteroids = breakAsteroids?rocks.size()*31:rocks.size();
      state1 = saveState();
    }
    if (mode<4) mode++;
    if (mode==3&&!bullets) mode++;
  }
  if (mouseX>=width/2-200&&mouseX<=width/2+200&&mouseY>=height/2+75&&mouseY<=height/2+125) {
    if (mode==0) {
      mode=4;
      tas=true;
      totalAsteroids=rocks.size()*31;
      //noLoop();
    }
  }
  //redraw();
}
