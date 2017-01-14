import toxi.geom.*;


Vec3D world;
ArrayList <Particle> parts;
Particle p;

boolean slow = true;
boolean dispTail = false;

int nParts = 5000;

void setup() {
  size(800,600, P3D);
  surface.setSize(displayWidth-20, displayHeight-50);
  world = new Vec3D(width, height, 0);
  parts = new ArrayList<Particle>();
  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
    new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }
}


void draw() {
  background(221);
  for (Particle p : parts) {
    p.run();
  }

  p = parts.get(0);
  noStroke();
  fill(0, 30);
  ellipse(mouseX, mouseY, p.sd*2, p.sd*2);
  if (slow) ellipse(mouseX, mouseY, p.th*2, p.th*2);
  // DRY - Do not Repeat Yourself
}

void keyPressed() {
  if (key=='s') slow = !slow;
  if (key=='t') dispTail = !dispTail;
}