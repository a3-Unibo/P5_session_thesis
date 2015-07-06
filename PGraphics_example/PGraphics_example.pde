PGraphics pg;

void setup() {
  size(800, 600);

  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
  //pg.background(0);
  pg.stroke(255);
  pg.noFill();
  pg.strokeWeight(3);
  pg.ellipse(width*.5, height*.5, 100, 100);
  pg.endDraw();
}

void draw() {
  background(0,20,200);
  image(pg, 0, 0);
  pg.beginDraw();
  pg.set(mouseX, mouseY, color(255));
  pg.endDraw();
  stroke(255, 0, 0);
  line(width*.5, height*.5, mouseX, mouseY);
}
