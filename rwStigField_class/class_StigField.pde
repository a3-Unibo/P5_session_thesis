class StigField {
  float[][] stig;
  int cols, rows;
  float xRes, yRes;
  PGraphics pg;

  StigField(int cols, int rows, float xRes, float yRes) {
    this.cols = cols;
    this.rows = rows;
    this.xRes = xRes;
    this.yRes = yRes;
    stig = new float[cols][rows];
    initField();
    pg = createGraphics(cols, rows, JAVA2D);
  }

  StigField(PApplet p5) {
    this(p5.width, p5.height, 1, 1);
  }

  StigField(PApplet p5, int cols, int rows) {
    this(cols, rows, p5.width/(float)cols, p5.height/(float)rows);
  }

  void initField() {
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        stig[i][j]=0;
      }
    }
  }

  void decay(float t) {
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        stig[i][j]*=t;
      }
    }
  }

  float read(Vec3D loc) {
    loc = checkBounds(loc);
    int col = int(constrain(loc.x/xRes, 0, cols-1));
    int row = int(constrain(loc.y/yRes, 0, rows-1));
    return stig[col][row];
  }

  void write(Vec3D loc, float s) {
    int col = int(constrain(loc.x/xRes, 0, cols-1));
    int row = int(constrain(loc.y/yRes, 0, rows-1));
    stig[col][row]= constrain(stig[col][row]+s, 0, 1);
  }

  
   Vec3D checkBounds (Vec3D loc) {
    Vec3D nLoc= new Vec3D(loc);
    int w = int(cols*xRes);
    int h = int(rows*yRes);
    nLoc.x = (nLoc.x+w)%w;
    nLoc.y = (nLoc.y+h)%h;
    return nLoc;
  }

  void display() {
    int ind;
    //pg = createGraphics(cols, rows, JAVA2D);
     pg.clear();
    pg.beginDraw();
    pg.loadPixels();
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        ind = j*cols+i;
        pg.pixels[ind]=color(0,stig[i][j]*255); // if you want to invert it it's (1-stig[i][j])*255
      }
    }
    pg.updatePixels();
    pg.endDraw();
    pg.resize(width, height);
    //image(pg, 0, 0);
  }
}
