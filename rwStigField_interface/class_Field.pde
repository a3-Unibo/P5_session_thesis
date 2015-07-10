class Field {
  Vec3D[][] field;
  int cols, rows;
  float xRes, yRes, noiseScale;
  PGraphics pg;

  Field(float xRes, float yRes, float noiseScale) {
    this.xRes = xRes;
    this.yRes = yRes;
    this.noiseScale = noiseScale;

    cols = round(width/xRes);
    rows = round(height/yRes);

    field = new Vec3D[cols][rows];
    initField();
    pg = createGraphics(width, height, JAVA2D);
    displayColor(30);
  }


  void initField() {
    float theta;
    float xOff, yOff;
    xOff=0;
    for (int i=0; i< cols; i++) {
      yOff=0;
      for (int j=0; j< rows; j++) {
        theta = map(noise (xOff, yOff), 0, 1, 0, TWO_PI);
        field[i][j] = new Vec3D(cos(theta), sin(theta), 0);
        yOff+= noiseScale;
      }
      xOff+= noiseScale;
    }
  }
  
    void updateField(float t) {
    float theta;
    float xOff, yOff;
    xOff=0;
    for (int i=0; i< cols; i++) {
      yOff=0;
      for (int j=0; j< rows; j++) {
        theta = map(noise (xOff, yOff, t), 0, 1, 0, TWO_PI);
        field[i][j] = new Vec3D(cos(theta), sin(theta), 0);
        yOff+= noiseScale;
      }
      xOff+= noiseScale;
    }
  }
  

  Vec3D eval(Vec3D loc) {
    int col = int(constrain(loc.x/xRes, 0, cols-1));
    int row = int(constrain(loc.y/yRes, 0, rows-1));
    return new Vec3D(field[col][row]);
  }

  void display(float len) {
    pushStyle();
    stroke(0,80);
    strokeWeight(1);
    for (int i=0; i< cols; i++) {
      for (int j=0; j<rows; j++) {
        pushMatrix();
        translate(xRes*(i+.5), yRes*(j+.5));
        line(0, 0, field[i][j].x*len, field[i][j].y*len);
        popMatrix();
      }
    }
    popStyle();
  }
  
  void displayColor(float len) {
    pg.clear();
    pg.beginDraw();
    pg.pushStyle();
    pg.stroke(0,80);
    pg.strokeWeight(1);
    float ang;
    for (int i=0; i< cols; i++) {
      for (int j=0; j<rows; j++) {
        pg.pushMatrix();
        pg.translate(xRes*(i+.5), yRes*(j+.5));
        ang = map(atan2(field[i][j].y, field[i][j].x), 0, TWO_PI,0.0,1.0);
        pg.stroke(lerpColor(color(#E81A1A,80),color(#0D670C,80), ang));
        pg.line(0, 0, field[i][j].x*len, field[i][j].y*len);
        pg.popMatrix();
      }
    }
    pg.popStyle();
    pg.endDraw();
  }
}
