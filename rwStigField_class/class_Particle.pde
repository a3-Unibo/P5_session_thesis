class Particle {

  // fields
  Vec3D loc, vel, acc, world;
  float maxSpeed, maxForce;
  float th = 100;
  float phero = 0.2; // this is the strength of the pheromonic trace

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


  // behaviors (uncheck the ones you wish to use)
  void run() {
    /*
    // ................................. mouse influence
     Vec3D s = new Vec3D();
     if (mousePressed && mouseButton == LEFT) {
     s = seek(new Vec3D(mouseX, mouseY, 0));
     }
     s.scaleSelf(10);
     addForce(s);
     */

    
    // ................................. noise field influence
     Vec3D f = followField(noiseField);
     f.scaleSelf(1);
     addForce(f);
     

    // ................................. stigmergic field influence

    //           field, futLoc distance, radius, samples, use steer behavior
    //              |          |      _____|  ______|      ____|
    //              \____      |     /    ___/  __________/
    //                   |     |    |    |     |
    Vec3D st = stigVec(stig, 10, 10*.8, 200, false);
    st.scaleSelf(2); // weight stigmergy
    vel.normalizeTo(maxSpeed*.5); // the trick that does the unstoppable motion
    addForce(st);

    /*
    // ................................. wander behavior
     Vec3D w = wander(.2, QUARTER_PI);
     w.scaleSelf(.1);
     addForce(w);
     */

    // ................................. update acc and move
    update();
    move();

    // ................................. border behavior (choose one)
    //bounce();
    wrap();

    // ................................. update stig field
    writeField(stig);

    // ................................. display
    // display();
    // display moved to the main sketch to toggle agent display in a cleaner way
  }


  void addForce(Vec3D force) {
    acc.addSelf(force);
  }

  Vec3D followField(Field field) {
    Vec3D f = field.eval(loc);
    f.subSelf(vel);
    f.limit(maxForce);
    return f;
  }

  void update() {
    vel.addSelf(acc);
    vel.limit(maxSpeed);
    acc = new Vec3D();
  }

  void move() {
    loc.addSelf(vel); // a+b a+=b
  }

  void writeField(StigField stig) {
    stig.write(loc, phero);
  }


  Vec3D stigVec(StigField stig, float fut, float rad, int ns, boolean steer) {
    Vec3D s = new Vec3D();
    float st=0, sampleSt;
    Vec3D sample;

    // calculate future location
    Vec3D futLoc = new Vec3D(vel).normalizeTo(fut).addSelf(loc);

    // shoot samples
    for (int i=0; i< ns; i++) {
      sample = new Vec3D(random(-rad, rad), random(-rad, rad), 0);
      // reads field
      sampleSt = stig.read(futLoc.add(sample));
      if (sampleSt > st) {
        st = sampleSt;
        s = sample;
      }
    } // end sampling

    if (steer) {
      s.normalizeTo(maxSpeed); //  <- desired
      s.subSelf(vel);
      s.normalizeTo(maxForce);
    } else {
      s.normalizeTo(maxSpeed*.1); // 0.3 as default value
    }
    return s;
  }

  Vec3D wander(float amount, float ang) {
    Vec3D wand = new Vec3D(vel);
    wand.normalizeTo(amount);
    wand.rotateZ(random(-ang, ang));
    return wand;
  }

  Vec3D seek(Vec3D target) {
    Vec3D steer = new Vec3D();
    // trovo desired e lo ri-scalo a maxSpeed
    Vec3D desired = target.sub(loc);
    float thres = pow(th, 2);
    float d = desired.magSquared();
    if (d < thres) {
      d = map(d, 0, thres, 0, maxSpeed); // rimappa la distanza
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
    if (loc.x < 0) loc.x = world.x;
    if (loc.x > world.x) loc.x=0;
    if (loc.y < 0) loc.y = world.y;
    if (loc.y > world.y) loc.y=0;
    // if (loc.z < 0) loc.z = world.z;
    // if (loc.z > world.z) loc.z=0;
  }

  void bounce() {
    if (loc.x < 0 || loc.x > world.x) vel.x *=-1;
    if (loc.y < 0 || loc.y > world.y) vel.y *=-1;
    // if (loc.z < 0 || loc.z > world.z) vel.z *=-1;
  }

  Vec3D wrapBounds(Vec3D loc) {
    Vec3D newLoc = new Vec3D(loc);
    if (loc.x < 0) newLoc.x = world.x;
    if (loc.x > world.x) newLoc.x=0;
    if (loc.y < 0) newLoc.y = world.y;
    if (loc.y > world.y) newLoc.y=0;
    // if (loc.z < 0) newLoc.z = world.z;
    // if (loc.z > world.z) newLoc.z=0;
    return newLoc;
  }

  boolean checkBounds(Vec3D loc) {
    boolean check = true;
    if (loc.x < 0 || loc.x > world.x) check = false;
    if (loc.y < 0 || loc.y > world.y) check = false;
    // if (loc.z < 0 || loc.z > world.z) check = false;
    return check;
  }

  void display() {
    stroke(200, 0, 0, 180);
    strokeWeight(2);
    point(loc.x, loc.y, loc.z);
  }
}
