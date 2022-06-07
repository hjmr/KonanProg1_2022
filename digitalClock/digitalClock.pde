int NUM_WIDTH  = 240; // width of number
int NUM_HEIGHT = 400; // height of number
int NUM_SEP    =  60; // dist between hour, minutes, and seconds 

// position of each numeric
int POS_BASE_X    =  80;
int POS_HOUR_10_X = POS_BASE_X;
int POS_HOUR_01_X = POS_HOUR_10_X + NUM_WIDTH;
int POS_MIN_10_X  = POS_HOUR_01_X + NUM_WIDTH + NUM_SEP;
int POS_MIN_01_X  = POS_MIN_10_X  + NUM_WIDTH;
int POS_SEC_10_X  = POS_MIN_01_X  + NUM_WIDTH + NUM_SEP;
int POS_SEC_01_X  = POS_SEC_10_X  + NUM_WIDTH;

int POS_Y = 100;

// colors
color onSegmentColor  = color(255, 255, 255);
color offSegmentColor = color( 30,  30,  30);

void setup() {
  size(1700, 600);
}

void draw() {
  background(0);
  int h = hour();
  int m = minute();
  int s = second();
  drawTimeText(h, m, s);
  drawTwoDigits(h, POS_HOUR_10_X, POS_HOUR_01_X, POS_Y);
  drawTwoDigits(m, POS_MIN_10_X , POS_MIN_01_X , POS_Y);
  drawTwoDigits(s, POS_SEC_10_X , POS_SEC_01_X , POS_Y);
  drawDots();
}

void drawTimeText(int h, int m, int s) {
  String timeStr = nf(h,2) + ":" + nf(m,2) + ":" + nf(s,2);
  noStroke();
  fill(onSegmentColor);
  textAlign(LEFT);
  textSize(24);
  text(timeStr, 10, 24); 
}

void drawTwoDigits(int num, int posHiX, int posLoX, int posY) {
  int hi = int(num / 10);
  int lo = int(num % 10);
  drawNum(hi, posHiX, posY);
  drawNum(lo, posLoX, posY);
}

void drawNum(int num, int posX, int posY) {
  if( num == 0 ) draw0(posX, posY);
  else if( num == 1 ) draw1(posX, posY);
  else if( num == 2 ) draw2(posX, posY);
  else if( num == 3 ) draw3(posX, posY);
  else if( num == 4 ) draw4(posX, posY);
  else if( num == 5 ) draw5(posX, posY);
  else if( num == 6 ) draw6(posX, posY);
  else if( num == 7 ) draw7(posX, posY);
  else if( num == 8 ) draw8(posX, posY);
  else if( num == 9 ) draw9(posX, posY); 
}

void drawDots() {
  float posX1 = POS_MIN_10_X - NUM_SEP / 2;
  float posX2 = POS_SEC_10_X - NUM_SEP / 2;
  float posY1 = POS_Y              + 1 * NUM_HEIGHT / 4;
  float posY2 = POS_Y + NUM_HEIGHT - 1 * NUM_HEIGHT / 4;
  noStroke();
  fill(onSegmentColor);
  rectMode(CENTER);  
  rect(posX1, posY1, 40, 40);
  rect(posX1, posY2, 40, 40);
  rect(posX2, posY1, 40, 40);
  rect(posX2, posY2, 40, 40);
}

void draw0(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170, offSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205,  onSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw1(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0, offSegmentColor);
  drawSegmentH(posX +  40, posY + 170, offSegmentColor);
  drawSegmentH(posX +  40, posY + 340, offSegmentColor);
  drawSegmentV(posX +   5, posY +  35, offSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw2(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35, offSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205,  onSegmentColor);
  drawSegmentV(posX + 175, posY + 205, offSegmentColor);
}

void draw3(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35, offSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw4(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0, offSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340, offSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw5(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35, offSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw6(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35, offSegmentColor);
  drawSegmentV(posX +   5, posY + 205,  onSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw7(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170, offSegmentColor);
  drawSegmentH(posX +  40, posY + 340, offSegmentColor);
  drawSegmentV(posX +   5, posY +  35, offSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void draw8(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205,  onSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}
  
void draw9(int posX, int posY) {
  drawSegmentH(posX +  40, posY +   0,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 170,  onSegmentColor);
  drawSegmentH(posX +  40, posY + 340,  onSegmentColor);
  drawSegmentV(posX +   5, posY +  35,  onSegmentColor);
  drawSegmentV(posX + 175, posY +  35,  onSegmentColor);
  drawSegmentV(posX +   5, posY + 205, offSegmentColor);
  drawSegmentV(posX + 175, posY + 205,  onSegmentColor);
}

void drawSegmentH(int x, int y, color c) {
  noStroke();
  fill(c);
  beginShape();
  vertex(x +   0, y + 30);
  vertex(x +  30, y +  0);
  vertex(x + 130, y +  0);
  vertex(x + 160, y + 30);
  vertex(x + 130, y + 60);
  vertex(x +  30, y + 60);
  endShape(CLOSE);
}

void drawSegmentV(int x, int y, color c) {
  noStroke();
  fill(c);
  beginShape();
  vertex(x + 30, y +   0);
  vertex(x + 60, y +  30);
  vertex(x + 60, y + 130);
  vertex(x + 30, y + 160);
  vertex(x +  0, y + 130);
  vertex(x +  0, y +  30);
  endShape(CLOSE);
}
