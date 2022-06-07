// background attributes
float bgOffsetX = 0;
final int bgRectW = 40;
final int bgRectH = 40;
final color bgRectNormalColor1 = color(255, 255, 255, 50); // white
final color bgRectNormalColor2 = color(200, 200, 255, 50); // pale blue
final float bgNormalSpeed = 0.5;
final color bgRectGameOverColor1 = color(  0, 0, 0); // black
final color bgRectGameOverColor2 = color(255, 0, 0); // red
final float bgGameOverSpeed = -2.0;

// particle attributes
final int maxParticles = 500;
final float particleSize = 10;
float[] particleX = new float[maxParticles];
float[] particleY = new float[maxParticles];
float[] particleVx = new float[maxParticles];
float[] particleVy = new float[maxParticles];
boolean[] particleExist = new boolean[maxParticles];
final float particleGravity = 0.5; // gravity

// ball attributes
final int maxBalls = 10;
final float ballSize = 20;
float[] ballX = new float[maxBalls];
float[] ballY = new float[maxBalls];
float[] ballVx = new float[maxBalls];
float[] ballVy = new float[maxBalls];
color[] ballColor = new color[maxBalls];
boolean[] ballExist = new boolean[maxBalls];

// paddle
final float paddleWidth = 100;
final float paddleHeight = 20;
final color paddleColor = color(0, 0, 200);
final float paddleVx = 10;
float paddleX, paddleY;

// shadow
final float shadowOffsetX = 10;
final float shadowOffsetY = 10;
final color shadowColor = color(100, 100, 100, 30);

// score
int score = 0;

// time
int gameStartTime;
int ballAddTime;
final int ballAddInterval = 3 * 1000; // add ball in every 3 secs
final int gamePeriod = 60 * 1000; // can play game 60 sec

// show progress 
final color progressColor = color(200, 0, 255, 80);

// show game result
final color resultColor = color(255, 255, 0);

void setup() {
  size(480, 480);
  bgOffsetX = 0;
  // disable all particles at the beginning
  for ( int i = 0; i < maxParticles; i++ ) {
    particleExist[i] = false;
  }
  // disable all balls at the beginning
  for ( int i = 0; i < maxBalls; i++ ) {
    ballExist[i] = false;
  }
  // initialize paddle position
  colorMode(HSB, 360, 100, 100, 100);
  paddleX = width / 2;
  paddleY = height - 50;
  // reset score
  score = 0;
  // record start time
  gameStartTime = millis();
  ballAddTime = millis();
}

void draw() {
  boolean timeInPlay = false;
  int playTimeMillis = millis() - gameStartTime;
  if ( playTimeMillis < gamePeriod ) {
    timeInPlay = true;
  }

  if ( timeInPlay ) {
    drawBackground(bgRectNormalColor1, bgRectNormalColor2, bgNormalSpeed);
    drawBalls(timeInPlay);
    drawParticles();
    drawPaddle();
    drawGameProgress(playTimeMillis);
    movePaddle();
    checkBallAddInterval();
  } else {
    drawBackground(bgRectGameOverColor1, bgRectGameOverColor2, bgGameOverSpeed);
    drawBalls(timeInPlay);
    drawParticles();
    drawGameOver();
  }
}

void checkBallAddInterval() {
  if ( ballAddInterval < millis() - ballAddTime ) {
    addBall(random(0, width-ballSize) + ballSize / 2, 30);
    ballAddTime = millis();
  }
}

void movePaddle() {
  if ( keyPressed && key == CODED ) {
    if ( keyCode == LEFT ) {
      paddleX -= paddleVx;
    } else if ( keyCode == RIGHT ) {
      paddleX += paddleVx;
    }
  }
  paddleX = min(max(paddleX, -paddleWidth/2), width - paddleWidth/2);
}

void drawGameProgress(int playTimeMillis) {
  int playTimeSec = (gamePeriod - playTimeMillis) / 1000;
  String timeStr = "Remaining Time: " + playTimeSec + "s";
  String scoreStr = "Score: " + score;
  textAlign(RIGHT);
  textSize(24);
  fill(progressColor);
  text(timeStr, width-30, 24);
  text(scoreStr, width-30, 48);
}

void drawGameOver() {
  String s1 = "TIME UP";
  String s2 = "SCORE: " + score;
  textAlign(CENTER);
  textSize(48);
  fill(resultColor);
  text(s1, width/2, height/2     );
  text(s2, width/2, height/2 + 48);
}


void drawPaddle() {
  noStroke();
  fill(shadowColor);
  rect(paddleX + shadowOffsetX, paddleY + shadowOffsetY, paddleWidth, paddleHeight);
  fill(paddleColor);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
}

void drawBackground(color c1, color c2, float speed) {
  int toggleX = 0, toggleY = 0;
  for ( int x = -2 * bgRectW; x < width + 2 * bgRectW; x += bgRectW ) {
    toggleX = toggleY;
    for ( int y = -2 * bgRectH; y < height + 2 * bgRectH; y += bgRectH ) {
      if ( toggleX == 0 ) {
        fill(c1);
      } else {
        fill(c2);
      }
      noStroke();
      rect(x + bgOffsetX, y, bgRectW, bgRectH);
      toggleX = 1 - toggleX;
    }
    toggleY = 1 - toggleY;
  }
  bgOffsetX += speed;
  if ( bgOffsetX <= -2 * bgRectW || 2 * bgRectW <= bgOffsetX) {
    bgOffsetX = 0;
  }
}

void drawBalls(boolean timeInPlay) {
  for ( int i = 0; i < maxBalls; i++ ) {
    if ( ballExist[i] ) {
      // draw ball
      noStroke();
      fill(shadowColor);
      ellipse(ballX[i] + shadowOffsetX, ballY[i] + shadowOffsetY, ballSize, ballSize);
      fill(ballColor[i]);
      ellipse(ballX[i], ballY[i], ballSize, ballSize);

      // move ball
      ballX[i] += ballVx[i];
      ballY[i] += ballVy[i];

      // refrect
      boolean hitToWall = false;
      boolean hitToPaddle = false;
      if ( ballX[i] - ballSize/2 < 0 || width < ballX[i] + ballSize/2 ) {
        ballVx[i] = -ballVx[i];
        ballX[i] = min(max(ballX[i], ballSize/2), width - ballSize/2);
        hitToWall = true;
      }
      if ( ballY[i] - ballSize/2 < 0 ) {
        ballVy[i] = -ballVy[i];
        ballY[i] = max(ballY[i], ballSize/2);
        hitToWall = true;
      }
      if ( timeInPlay ) {
        if ( paddleX < ballX[i] && ballX[i] < paddleX + paddleWidth
          && paddleY < ballY[i] && ballY[i] < paddleY + paddleHeight/2 ) {
          ballVy[i] = -ballVy[i];
          ballY[i] = paddleY - ballSize/2;
          hitToPaddle = true;
        }
        if ( height + ballSize/2 < ballY[i] ) {
          ballExist[i] = false;
          score--;
        }
      } else {
        if ( height < ballY[i] + ballSize/2 ) {
          ballVy[i] = -ballVy[i];
          ballY[i] = min(ballY[i], height - ballSize/2);
          hitToWall = true;
        }
      }
      if ( hitToPaddle ) {
        score++;
        addParticles(50, ballX[i], ballY[i]);
      }
      if ( !timeInPlay && hitToWall ) {
        addParticles(50, ballX[i], ballY[i]);
      }
    }
  }
}

void drawParticles() {
  for ( int i = 0; i < maxParticles; i++ ) {
    if ( particleExist[i] ) {
      color particleColor = color(random(0, 360), 50, 100);
      noStroke();
      fill(particleColor);
      ellipse(particleX[i], particleY[i], particleSize, particleSize);
      particleX[i] += particleVx[i];
      particleY[i] += particleVy[i];
      particleVy[i] += particleGravity;
      if ( particleX[i] < 0 || width < particleX[i] || height < particleY[i] ) {
        particleExist[i] = false;
      }
    }
  }
}

void addBall(float x, float y) {
  for ( int i = 0; i < maxBalls; i++ ) {
    if ( !ballExist[i] ) {
      ballX[i] = x;
      ballY[i] = y;
      ballVx[i] = random(1, 6) * (random(0, 2) < 1.0 ? -1.0 : 1.0);
      ballVy[i] = random(1, 6) * (random(0, 2) < 1.0 ? -1.0 : 1.0);
      ballColor[i] = color(random(0, 360), 100, 100);
      ballExist[i] = true;
      break;
    }
  }
}

void addParticles(int num, float x, float y) {
  for ( int i = 0; i < maxParticles; i++ ) {
    if ( !particleExist[i] && addParticle(i, x, y) ) {
      num--;
      if ( num == 0 ) {
        break;
      }
    }
  }
}

boolean addParticle(int idx, float x, float y) {
  boolean success = false;
  if ( particleExist[idx] == false ) {
    particleX[idx] = x;
    particleY[idx] = y;
    particleVx[idx] = random(-10, 10);
    particleVy[idx] = random(-15, -5);
    particleExist[idx] = true;
    success = true;
  }
  return success;
}
