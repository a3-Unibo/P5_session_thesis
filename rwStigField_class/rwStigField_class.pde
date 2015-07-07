import toxi.geom.*;

Vec3D world; // world size
ArrayList <Particle> parts; // our particle arrayList
Particle p; // a single particle
Field noiseField; // noise Field
StigField stig; // stigmergy field
boolean agDisp = true; // controls agents display
boolean noiseUp = true; // controls noise field update
boolean noiseDisp = false; // controls noise field display
boolean stigDisp = true; // controls stigmergy field display

float sDec = .99; // stigmergy decay factor

int nParts = 5000; // our particles/agents

void setup() {
  if (sketchFullScreen()) { // using sketchFullScreen to decide between 2 options
    // when fullScreen, use all of the display real estate
    size(displayWidth, displayHeight, P3D);
    smooth();
  } else {
    // else, use a smaller window
    size(displayWidth-20, displayHeight-50, P3D);
    //size(800,600,P3D); // smaller display
    smooth(8);
  }

  // initialize world and particles
  world = new Vec3D(width, height, 0);
  parts = new ArrayList<Particle>();

  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
    new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }

  // initialize fields
  
  noiseField = new Field(5, 5, 0.02);
  stig = new StigField(this);
}


void draw() {
  background(221);

  // stigmergic field first
  if (stigDisp) {
    stig.display();
    image(stig.pg, 0, 0);
  }

  // noise field then
  if (noiseUp) noiseField.updateField(frameCount*0.005);
  if (noiseDisp) noiseField.displayColor(30);

  // particle display
  for (Particle p : parts) {
    p.run();
    if (agDisp) p.display(); // display is subject to toggle
  }

  // stigmergic decay as last thing
  stig.decay(.99);
}


boolean sketchFullScreen() {
  return true;
}

void keyPressed() {
  if (key=='a') agDisp = ! agDisp;
  if (key=='s') stigDisp = !stigDisp;
  if (key=='u') noiseUp = !noiseUp;
  if (key=='n') noiseDisp = ! noiseDisp;
  if (key=='i') {
    String fileName = "img/stigmergy_ph_"+parts.get(0).phero+"_dec_"+sDec +"_"+ nf(frameCount, 4)+".png";
    // saves a transparent background png from stigmergic field PGraphics
    stig.pg.save(sketchPath(fileName));
  }
}
