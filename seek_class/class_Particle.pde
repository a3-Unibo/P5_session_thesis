class Particle {

  // fields
  Vec3D loc, vel, acc, world;
  float maxSpeed, maxForce;
  float th = 100;

  // constructor(s)
  Particle(Vec3D loc, Vec3D vel, Vec3D world) {
    // this si riferisce alla classe > this.loc 
    // è il parametro più generale
    this.loc = loc; // p.loc
    this.vel = vel;
    this.world = world;
    maxSpeed = 3;
    maxForce = 0.1;
    acc = new Vec3D();
  }


  // behaviors
  void run() {
    update();
    move();
    bounce();
    display();
  }

  void update() {
    Vec3D s = new Vec3D();
    if (mousePressed && mouseButton == LEFT) {
      s = seek(new Vec3D(mouseX, mouseY, 0));
    }
    acc.addSelf(s);
    vel.addSelf(acc);
    vel.limit(maxSpeed);
    acc = new Vec3D();
  }

  void move() {
    loc.addSelf(vel); // a+b a+=b
  }

  Vec3D seek(Vec3D target) {
    Vec3D steer = new Vec3D();
    // trovo desired e lo ri-scalo a maxSpeed
    Vec3D desired = target.sub(loc);
    float thres = pow(th,2);
    float d = desired.magSquared();
    if (d < thres) {
      d = map(d,0,thres,0,maxSpeed); // rimappa la distanza
      desired.normalizeTo(d);
    } else {
      desired.normalizeTo(maxSpeed);
    }
    //desired.limit(maxSpeed);
    // trovo steer e lo limito a maxForce
    steer = desired.sub(vel);
    steer.limit(maxForce);
    // restituisco steer
    return steer;
  }

  // boundary behaviors

  void wrap() {
  }

  void bounce() {
    if (loc.x < 0 || loc.x > world.x) vel.x *=-1;
    if (loc.y < 0 || loc.y > world.y) vel.y *=-1;
    // if (loc.z < 0 || loc.z > world.z) vel.z *=-1;
  }

  void display() {
    stroke(0);
    strokeWeight(3);
    point(loc.x, loc.y, loc.z);
  }
}
