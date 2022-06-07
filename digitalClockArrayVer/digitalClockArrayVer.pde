// basic dimension
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

// digits
final int SEG_H = 0;
final int SEG_V = 1;
int[][] segmentPos = {
  {SEG_H,  40,   0}, 
  {SEG_H,  40, 170},
  {SEG_H,  40, 340},
  {SEG_V,   5,  35},
  {SEG_V, 175,  35},
  {SEG_V,   5, 205},
  {SEG_V, 175, 205}
};

// colors
color onColor  = color(255, 255, 255);
color offColor = color( 30,  30,  30);
color[][] segmentColor = {
  { onColor, offColor,  onColor,  onColor,  onColor,  onColor,  onColor}, // 0
  {offColor, offColor, offColor, offColor,  onColor, offColor,  onColor}, // 1
  { onColor,  onColor,  onColor, offColor,  onColor,  onColor, offColor}, // 2
  { onColor,  onColor,  onColor, offColor,  onColor, offColor,  onColor}, // 3
  {offColor,  onColor, offColor,  onColor,  onColor, offColor,  onColor}, // 4
  { onColor,  onColor,  onColor,  onColor, offColor, offColor,  onColor}, // 5
  { onColor,  onColor,  onColor,  onColor, offColor,  onColor,  onColor}, // 6
  { onColor, offColor, offColor, offColor,  onColor, offColor,  onColor}, // 7
  { onColor,  onColor,  onColor,  onColor,  onColor,  onColor,  onColor}, // 8
  { onColor,  onColor,  onColor,  onColor,  onColor, offColor,  onColor}  // 9
};

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
  fill(onColor);
  textAlign(LEFT);
  textSize(24);
  text(timeStr, 10, 24); 
}

void drawTwoDigits(int num, int posHiX, int posLoX, int posY) {
  int hi = int(num / 10);
  int lo = int(num % 10);
  drawDigit(hi, posHiX, posY);
  drawDigit(lo, posLoX, posY);
}

void drawDots() {
  float posX1 = POS_MIN_10_X - NUM_SEP / 2;
  float posX2 = POS_SEC_10_X - NUM_SEP / 2;
  float posY1 = POS_Y              + 1 * NUM_HEIGHT / 4;
  float posY2 = POS_Y + NUM_HEIGHT - 1 * NUM_HEIGHT / 4;
  noStroke();
  fill(onColor);
  rectMode(CENTER);  
  rect(posX1, posY1, 40, 40);
  rect(posX1, posY2, 40, 40);
  rect(posX2, posY1, 40, 40);
  rect(posX2, posY2, 40, 40);
}

void drawDigit(int num, int posX, int posY) {
  for( int i = 0 ; i < segmentPos.length ; i++ ) {
    noStroke();
    fill(segmentColor[num][i]);
    if( segmentPos[i][0] == SEG_H ) {
      drawSegmentH(posX + segmentPos[i][1], posY + segmentPos[i][2]);
    } else {
      drawSegmentV(posX + segmentPos[i][1], posY + segmentPos[i][2]);
    }
  }
}

void drawSegmentH(int x, int y) {
  beginShape();
  vertex(x +   0, y + 30);
  vertex(x +  30, y +  0);
  vertex(x + 130, y +  0);
  vertex(x + 160, y + 30);
  vertex(x + 130, y + 60);
  vertex(x +  30, y + 60);
  endShape(CLOSE);
}

void drawSegmentV(int x, int y) {
  beginShape();
  vertex(x + 30, y +   0);
  vertex(x + 60, y +  30);
  vertex(x + 60, y + 130);
  vertex(x + 30, y + 160);
  vertex(x +  0, y + 130);
  vertex(x +  0, y +  30);
  endShape(CLOSE);
}
