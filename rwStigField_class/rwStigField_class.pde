import toxi.geom.*;

Vec3D world;
ArrayList <Particle> parts;
Particle p;
Field field;
StigField stig;

int nParts = 10000;

void setup() {
  //size(displayWidth-20, displayHeight-50, P3D);
  size(800,600,P3D);
  world = new Vec3D(width, height, 0);
  parts = new ArrayList<Particle>();

  stig = new StigField(this);

  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
    new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }

  field = new Field(5, 5, 0.02);
}


void draw() {
  //background(221);
  stig.display();
  for (Particle p : parts) {
    p.run();
  }

  field.updateField(frameCount*0.005);
  //field.displayColor(30);
  stig.evaporate(.99);

  // DRY - Do not Repeat Yourself
}


boolean sketchFullScreen() {
  return false;
}
