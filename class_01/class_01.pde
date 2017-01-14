// primitive
float a, v, p; // numeri a virgola mobile
float radius;
boolean check; /* commento  */
float sum;
PVector loc, vel, acc;
color col;
String s = "hello world"; 
int nBalls = 300;

Ball b; // dichiarare un oggetto b della classe Ball
Ball[] bArr = new Ball[nBalls]; // dichiarazione + instanziazione array

/*

 */

void setup() {
  // size(100,100);
  size(800, 800); // width, height
  p=300;
  v=1;
  a=0.1;

  for (int i=0; i<nBalls; i++) { // i++ i+=1 i=i+1
    //            i<bArr.lenght
    radius = random(5, 50);
    loc = new PVector(width*.5, height*.5); // 
    vel = new PVector(random(-2, 2), random(-2, 2));
    acc = new PVector(-0.1, 0);
    col = color(0, 200, random(50,255));
    // instanziazione di b
    bArr[i] = new Ball(loc, vel, acc, radius, col, 300);
  }
} // end setup


void draw() {
  //background(221,0,0);
  for (int i=0; i< bArr.length; i++) {
    //b.move();
    //b.randoMove();
    //bArr[i].semiDrunk();
    bArr[i].update();
    bArr[i].display();
    //println(bArr[i].loc);
  }
} // end draw