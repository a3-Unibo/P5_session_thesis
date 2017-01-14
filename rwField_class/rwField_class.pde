import toxi.geom.*;

Vec3D world;
ArrayList <Particle> parts;
Particle p;
Field field;
PGraphics pg;

int nParts = 10000;

void setup() {
  size(800,600, P3D);
  surface.setSize(displayWidth-20, displayHeight-50);
  //fullScreen(P3D);
  world = new Vec3D(width, height, 0);
  parts = new ArrayList<Particle>();

  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();

  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
    new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }

  field = new Field(5, 5, 0.02);
}


void draw() {
  background(221);
  image(pg,0,0);
  pg.beginDraw();
  for (Particle p : parts) {
    p.run();
  }
  pg.endDraw();
  field.updateField(frameCount*0.005);
  //field.displayColor(30);

  /*
  p = parts.get(0);
   noStroke();
   fill(0,50);
   ellipse(mouseX, mouseY, p.th*2,p.th*2);
   */
  // DRY - Do not Repeat Yourself
  
  if (frameCount%5==0) evaporate(pg);
}

void evaporate(PGraphics pg) {
  pg.loadPixels();
  for (int i=0; i< pg.pixels.length; i++) {
    pg.pixels[i] = color(constrain((brightness(pg.pixels[i])*.99), 0, 255));
  }
  pg.updatePixels();
}