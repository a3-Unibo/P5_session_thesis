/*
remember: pg.clear() should be called in between pg.beginDraw() and pg.endDraw()
 */


import toxi.geom.*;
import controlP5.*;

Vec3D world; // world size
ArrayList <Particle> parts; // our particle arrayList
Particle p; // a single particle
Field noiseField; // noise Field
StigField stig; // stigmergy field
ControlP5 c5; // interface
boolean agDisp = true; // controls agents display
boolean noiseUp = true; // controls noise field update
boolean noiseDisp = false; // controls noise field display
boolean stigDisp = true; // controls stigmergy field display
boolean steer = true; // steer behavior for stigmergic particles
boolean go = true; // stop/go simulation

float sDec = .99; // stigmergy decay factor

int nParts = 1000; // number of our particles/agents

float updateFreq = 3; // display update frequency

void setup() {
  
  // the following line is not allowed anymore in Processing 3
  // since variables are not allowed in the size() function
  // size (displayWidth-10,displayHeight-10, P3D);
  
  // this is how you do it instead:
  //size(1200, 600, P2D); // smaller display (any value here)  
  //surface.setSize(displayWidth-20,displayHeight-80); // resize after
  
  fullScreen(P2D); // fullscreen on second screen - comment the previous 2 lines if you use this
  
  //surface.setResizable(true); // if you want the sketch window to be resizable

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

  // initialize interface
  c5 = new ControlP5(this);
  initGUI(c5);
}


void draw() {
  background(221);

  // ................................... update elements
  if (go) {

    // noise field update
    if (noiseUp) noiseField.updateField(frameCount*0.005);

    // particle update
    for (Particle p : parts) {
      p.run(steer);
    }

    // stigmergic decay update
    stig.decay(sDec);
  }

  // ................................... display elements

  // stigmergic field first
  if (stigDisp) {
    if (frameCount%updateFreq==0) stig.display();
    image(stig.pg, 0, 0);
  }

  // noise field display
  if (noiseDisp) {
    if (noiseUp && frameCount%updateFreq==0) noiseField.displayColor(30); // updates display only if it updates data
    image(noiseField.pg, 0, 0);
  }

  // particle display
  if (agDisp) {
    for (Particle p : parts) {
      p.display();
    }
  }

  // draw interface
  c5.draw();
}

void keyPressed() {
  if (key==' ') go = !go;
  if (key=='a') agDisp = ! agDisp; // toggels agents/particles display
  if (key=='s') stigDisp = !stigDisp; // toggles stigmergy display
  if (key=='u') noiseUp = !noiseUp; // toggles noise update
  if (key=='n') noiseDisp = ! noiseDisp; // toggles noise display
  if (key=='i') saveImage();
  if (key=='r') reset();
}

void saveImage() {
  // create a PGraphics to save a transparent background
  //  png from stigmergic and/or noise field 
  PGraphics img = createGraphics(width, height, P2D); // for whatever reason JAVA2D does not save the noise field
  img.beginDraw();
  if (stigDisp) img.image(stig.pg, 0, 0);
  if (noiseDisp) img.image(noiseField.pg, 0, 0);
  img.endDraw();
  // build file name string from sketch parameters
  // so it is unique for every saved file
  String fileName = "img/stigmergy3_ph_"+parts.get(0).phero+"_dec_"+sDec +"_"+ nf(frameCount, 4)+".png";
  img.save(sketchPath(fileName));
}


void reset() {
  parts.clear();

  for (int i=0; i< nParts; i++) {
    Particle p = new Particle( new Vec3D(random(width), random(height), 0), 
      new Vec3D(random(-2, 2), random(-2, 2), 0), world);
    parts.add(p);
  }

  // initialize fields
  noiseField = new Field(5, 5, 0.02);
  stig = new StigField(this);
}