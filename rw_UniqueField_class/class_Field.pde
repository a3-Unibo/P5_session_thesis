class Field {
  float[][] values;
  Vec3D[][] gradient, vectors;
  int cols, rows;
  float xRes, yRes;
  PGraphics pg;

  Field(int cols, int rows, float xRes, float yRes) {
    this.cols = cols;
    this.rows = rows;
    this.xRes = xRes;
    this.yRes = yRes;
    values = new float[cols][rows];
    gradient = new Vec3D[cols][rows];
    initField();
    initGradient(false);
    pg = createGraphics(cols, rows, JAVA2D);
  }

  Field(PApplet p5) {
    this(p5.width, p5.height, 1, 1);
  }

  Field(PApplet p5, int cols, int rows) {
    this(cols, rows, p5.width/(float)cols, p5.height/(float)rows);
  }

  // ....................... initializers

    void initField() {
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        values[i][j]=0;
      }
    }
  }

  void initFieldValues(float[][] _values) {
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        values[i][j]=_values[i][j];
      }
    }
  }

  void initFieldNoise(float noiseScale) {
    float xOff, yOff;
    xOff=0;
    for (int i=0; i< cols; i++) {
      yOff=0;
      for (int j=0; j< rows; j++) {
        values[i][j] = noise (xOff, yOff);
        yOff+= noiseScale;
      }
      xOff+= noiseScale;
    }
  }

  void initVectors() {
    float theta;
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        theta = map(values[i][j], 0, 1, 0, TWO_PI);
        vectors[i][j] = new Vec3D(cos(theta), sin(theta), 0);
      }
    }
  }

  void initGradient(boolean norm) {
    float dX, dY;
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        dX = values[cx(i-1)][j]-values[cx(i+1)][j];
        dY = values[i][ry(j-1)]-values[i][ry(j+1)];
        gradient[i][j] = new Vec3D(dX, dY, 0);
      }
    }
  }

  // ....................... getters/setters

  float getClosestValue(Vec3D loc) {
    loc = checkBounds(loc);
    int col = int(constrain(loc.x/xRes, 0, cols-1));
    int row = int(constrain(loc.y/yRes, 0, rows-1));
    return values[col][row];
  }

  void setClosestValue(Vec3D loc, float v) {
    int col = int(constrain(loc.x/xRes, 0, cols-1));
    int row = int(constrain(loc.y/yRes, 0, rows-1));
    values[col][row]= constrain(values[col][row]+v, 0, 1);
  }

  float getValue(int c, int r) {
    return values[cx(c)][ry(r)];
  }

  void decay(float t) {
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        values[i][j]*=t;
      }
    }
  }

  // ....................... value functions

  void diffusion(int nD, float diff) {
    float[][] lap;
    for (int n = 0; n<nD; n++) {
      lap = laplacian(values);
      for (int i=0; i< cols; i++) {
        for (int j=0; j< rows; j++) {
          values[i][j]+= diff*lap[i][j];
        }
      }
    }
  }

  float[][] laplacian(float[][] values) {
    float dX, dY, val;
    float [][] lap = new float[cols][rows];
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        val = values[i][j];
        dX = values[cx(i-1)][j]+values[cx(i+1)][j];
        dY = values[i][ry(j-1)]+values[i][ry(j+1)];
        lap[i][j] = (dX+dY)-4*val;
      }
    }

    return lap;
  }

  // ....................... boundary functions

  // constrain indexes
  // columns index (x)
  int cx(int c) {
    return (c+cols)%cols;
  }
  // rows index (y)
  int ry(int r) {
    return (r+rows)%rows;
  }

  Vec3D checkBounds (Vec3D loc) {
    Vec3D nLoc= new Vec3D(loc);
    int w = int(cols*xRes);
    int h = int(rows*yRes);
    nLoc.x = (nLoc.x+w)%w;
    nLoc.y = (nLoc.y+h)%h;
    return nLoc;
  }

  // ....................... display functions

  void display() {
    int ind;
    pg.clear();
    pg.beginDraw();
    pg.loadPixels();
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        ind = j*cols+i;
        pg.pixels[ind]=color(0, values[i][j]*255); // if you want to invert it it's (1-stig[i][j])*255
      }
    }
    pg.updatePixels();
    pg.endDraw();
    pg.resize(width, height);
  }
}
