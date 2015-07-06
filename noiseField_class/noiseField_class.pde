import toxi.geom.*;

Vec3D world;
ArrayList <Particle> parts;
Particle p;
Field field;

int nParts = 10000;

void setup() {
  size(displayWidth-20, displayHeight-50, P3D);
  world = new Vec3D(width, height, 0);
  parts = new ArrayList<Particle>();
  
  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
    new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }
  
  field = new Field(50,50,0.02);
  
}


void draw() {
  background(221);
  for (Particle p : parts) {
   p.run();
  }
  field.updateField(frameCount*0.005);
  field.displayColor(30);
  
  /*
  p = parts.get(0);
  noStroke();
  fill(0,50);
  ellipse(mouseX, mouseY, p.th*2,p.th*2);
  */
  // DRY - Do not Repeat Yourself
}

boolean sketchFullScreen(){
return true;
}
