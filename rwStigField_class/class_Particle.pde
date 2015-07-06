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
    Vec3D s = new Vec3D();
    if (mousePressed && mouseButton == LEFT) {
      s = seek(new Vec3D(mouseX, mouseY, 0));
    }
    s.scaleSelf(10);
    addForce(s);
    // noise field influence
    Vec3D f = followField(field);
    f.scaleSelf(0);
    addForce(f);

    // stigmergic field influence
    Vec3D st = stigVec(stig, 10, 8, 50);
    st.scaleSelf(.4);
    addForce(st);

    update();
    move();
    //bounce();
    wrap();
    writeField(stig);
    display();
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
    stig.write(loc, 0.08);
  }

  Vec3D stigVecAvg(StigField stig, float fut, float rad, int ns) {
    Vec3D s = new Vec3D();
    Vec3D sample;
    int count=0;
    float st;
    // calculate future location
    Vec3D futLoc = new Vec3D(vel).normalizeTo(fut).addSelf(loc);
    //futLoc = wrapBounds(futLoc);
    // if futLoc is in bounds....
    if (checkBounds(futLoc)) {
      // shoot samples
      for (int i=0; i< ns; i++) {
        sample = new Vec3D(random(-rad, rad), random(-rad, rad), 0);
        // if sample is in bounds....
        if (checkBounds(futLoc.add(sample))) {
          // found one!!!
          count++;
          // reads field
          st = stig.read(futLoc.add(sample));
          // weighs vector according to field value
          sample.normalizeTo(st);
          // adds to the global vector
          s.addSelf(sample);
        }
        //sample = wrapBounds(sample);
      } // end sampling
      if (count > 0) {
        s.scaleSelf(1/(float)count); // desired direction
        s.normalizeTo(maxSpeed); // desired
        s.subSelf(vel);
        s.limit(maxForce);
      }
    }
    return s;
  }

  Vec3D stigVec(StigField stig, float fut, float rad, int ns) {
    Vec3D s = new Vec3D();
    Vec3D sample;
    int count=0;
    float st;
    // calculate future location
    Vec3D futLoc = new Vec3D(vel).normalizeTo(fut).addSelf(loc);

    // shoot samples
    for (int i=0; i< ns; i++) {
      sample = new Vec3D(random(-rad, rad), random(-rad, rad), 0);

      // found one!!!
      count++;
      // reads field
      st = stig.read(futLoc.add(sample));
      // weighs vector according to field value
      sample.normalizeTo(st);
      // adds to the global vector
      s.addSelf(sample);

      //sample = wrapBounds(sample);
    } // end sampling
    if (count > 0) {
      s.scaleSelf(1/(float)count); // desired direction
      s.normalizeTo(maxSpeed); // desired
      s.subSelf(vel);
      s.limit(maxForce);
    }

    return s;
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
    stroke(200, 180);
    strokeWeight(2);
    point(loc.x, loc.y, loc.z);
  }
}
