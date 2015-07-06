class Ball {

  // fields
  float rad;
  PVector vel, acc;
  PVector loc;
  color col;
  float life, lifeRate;

  // constructor(s)

  Ball (PVector _loc, PVector _vel, PVector _acc, 
  float _rad, color _col, float nFrames) {
    loc = _loc;
    vel = _vel;
    acc = _acc;
    rad = _rad;
    col = _col;
    life =1;
    lifeRate = 1/nFrames;
  }

  // methods or behaviors

    void update() {
    if (life >0) { 
      life -= lifeRate;
      semiDrunk();
    } else {
      life=1;
      loc = new PVector(width*.5, height*.5);
    }
  }

  void respawn() {
    if (loc.x+rad<0 || loc.x-rad > width || 
      loc.y+rad<0 || loc.y-rad > height) {
      loc = new PVector(width*.5, height*.5);
      // col = color(random(255), random(255), random(255));
    }
  }

  void semiDrunk() {
    // == uguale a  != diverso da < > && || !
    if (frameCount % 1 == 0) {
      randoMove();
    } else {
      move();
    }
    respawn();
  }

  void move() {
    loc.add(vel);
  }

  void moveAcc() {
    vel.add(acc);  
    loc.add(vel);
  }

  void randoMove() {
    vel.rotate(random(-QUARTER_PI, QUARTER_PI));
    loc.add(vel);
  }

  // display behaviors
  void display() {
    float r = lerp(2, rad, life);
    color c = lerpColor(color(0), col, life);
    // stroke(color); strokeWeight(float); fill(color);
    // noStroke();
    stroke(255, 120);
    strokeWeight(1);
    fill(c);
    ellipse(loc.x, loc.y, r*2, r*2);
  }
}
