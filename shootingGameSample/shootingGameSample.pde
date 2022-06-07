// background attributes
float bgOffsetX = 0;
float bgOffsetY = 0;
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
final float particleSize = 5;
float[] particleX = new float[maxParticles];
float[] particleY = new float[maxParticles];
float[] particleVx = new float[maxParticles];
float[] particleVy = new float[maxParticles];
color[] particleColor = new color[maxParticles];
boolean[] particleExist = new boolean[maxParticles];

// ball attributes
final int maxBalls = 30;
final float ballSize = 30;
float[] ballX = new float[maxBalls];
float[] ballY = new float[maxBalls];
float[] ballVy = new float[maxBalls];
color[] ballColor = new color[maxBalls];
boolean[] ballExist = new boolean[maxBalls];

// bullet attributes
final int maxBullets = 20;
final float bulletSize = 5;
float[] bulletX = new float[maxBullets];
float[] bulletY = new float[maxBullets];
final color bulletColor = color(128, 0, 0);
final float bulletVy = -bulletSize;
boolean[] bulletExist = new boolean[maxBullets];

// my ship
final float myShipWidth = 40;
final float myShipHeight = 20;
final color myShipColor = color(0, 0, 200);
float myShipX, myShipY;

// shadow
final float shadowOffsetX = 10;
final float shadowOffsetY = 10;
final color shadowColor = color(100, 100, 100, 30);

// gameover check
boolean gameOver = false;

// score
int score = 0;
final int shootScore = 1;
final int collisionPenalty = -5;


// time
int gameStartTime;
int ballAddTime;
final int ballAddInterval = int(0.1 * 1000); // add ball in every 0.1 secs
final int gamePeriod = 20 * 1000; // can play game 20 sec

// show score etc.
final color scoreColor = color(200, 0, 255, 80);

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
  myShipX = width / 2;
  myShipY = height - 50;
  // reset score
  score = 0;
  // record start time
  ballAddTime = millis();
}

void draw() {
  boolean timeInPlay = false;
  int playTimeMillis = millis() - gameStartTime;
  if ( playTimeMillis < gamePeriod ) {
    timeInPlay = true;
  }
 
  if ( timeInPlay ) {
    drawBackground(bgRectNormalColor1, bgRectNormalColor2, 0, bgNormalSpeed);
    drawBullets();    
    checkHit();
    drawBullets();    
    checkHit();
    drawBalls();
    checkCollision();
    drawParticles();
    drawMyShip();
    drawScore(playTimeMillis);
    moveMyShip();    
    checkShoot();
    checkBallAddInterval();
  } else {
    drawBackground(bgRectGameOverColor1, bgRectGameOverColor2, 0, bgGameOverSpeed);
    drawBalls();
    drawParticles();
    drawGameOver();
    checkBallAddInterval();
  }
}

void checkShoot() {
  if( keyPressed && key == ' ' ) {
    addBullet(myShipX, myShipY);
  }
}

void checkBallAddInterval() {
  if ( ballAddInterval < millis() - ballAddTime ) {
    addBall(random(ballSize, width - ballSize), -30);
    ballAddTime = millis();
  }
}

void checkHit() {
  for( int i = 0 ; i < maxBullets ; i++ ) {
    if( bulletExist[i] ) {
      for( int j = 0 ; j < maxBalls ; j++ ) {
        if( ballExist[j] ) {
          if( ballX[j] - ballSize/2 < bulletX[i] && bulletX[i] < ballX[j] + ballSize/2
           && ballY[j] - ballSize/2 < bulletY[i] && bulletY[i] < ballY[j] + ballSize/2 ) {
            bulletExist[i] = false;
            ballExist[j] = false;
            addParticles(50, ballX[j], ballY[j]);
            score += shootScore;
          }
        }
      }
    }
  }
}

void checkCollision() {
  for( int i = 0 ; i < maxBalls ; i++ ) {
    if( ballExist[i] ) {
      float myShipLeft   = myShipX - myShipWidth / 2;
      float myShipRight  = myShipX + myShipWidth / 2;
      float myShipTop    = myShipY;
      float myShipBottom = myShipY + myShipHeight;
      float ballLeft   = ballX[i] - ballSize / 2;
      float ballRight  = ballX[i] + ballSize / 2;
      float ballTop    = ballY[i] - ballSize / 2;
      float ballBottom = ballY[i] + ballSize / 2;
      if ( myShipLeft < ballRight  && ballLeft < myShipRight
        && myShipTop  < ballBottom && ballTop  < myShipBottom ) {
        ballExist[i] = false;
        score += collisionPenalty;
        addParticles(50, ballX[i], ballY[i]);
      }
    }
  }
}

void moveMyShip() {
  myShipX = min(max(mouseX, -myShipWidth/2), width - myShipWidth/2);
}

void drawScore(int playTimeMillis) {
  int playTimeSec = (gamePeriod - playTimeMillis) / 1000;
  String timeStr = "Remaining Time: " + playTimeSec + "s";
  String scoreStr = "Score: " + score;
  textAlign(RIGHT);
  textSize(24);
  fill(scoreColor);
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

void drawMyShip() {
  float shadowX = myShipX + shadowOffsetX;
  float shadowY = myShipY + shadowOffsetY;
  noStroke();
  fill(shadowColor);
  triangle(shadowX,                 shadowY,
           shadowX - myShipWidth/2, shadowY + myShipHeight,
           shadowX + myShipWidth/2, shadowY + myShipHeight);
  fill(myShipColor);
  triangle(myShipX,                 myShipY,
           myShipX - myShipWidth/2, myShipY + myShipHeight,
           myShipX + myShipWidth/2, myShipY + myShipHeight);
}

void drawBackground(color c1, color c2, float speedX, float speedY) {
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
      rect(x + bgOffsetX, y + bgOffsetY, bgRectW, bgRectH);
      toggleX = 1 - toggleX;
    }
    toggleY = 1 - toggleY;
  }
  bgOffsetX += speedX; 
  bgOffsetY += speedY;
  if ( bgOffsetX <= -2 * bgRectW || 2 * bgRectW <= bgOffsetX) {
    bgOffsetX = 0;
  }
  if ( bgOffsetY <= -2 * bgRectH || 2 * bgRectH <= bgOffsetY) {
    bgOffsetY = 0;
  }
}

void drawBullets() {
  for( int i = 0 ; i < maxBullets ; i++ ) {
    if( bulletExist[i] ) {
      // draw bullet
      noStroke();
      fill(shadowColor);
      ellipse(bulletX[i] + shadowOffsetX, bulletY[i] + shadowOffsetY, bulletSize, bulletSize);
      fill(bulletColor);
      ellipse(bulletX[i], bulletY[i], bulletSize, bulletSize);
      
      // move bullet
      bulletY[i] += bulletVy;
      
      // out of screen check
      if( bulletY[i] < 0 ) {
        bulletExist[i] = false;
      }
    }
  }
}

void drawBalls() {
  for ( int i = 0; i < maxBalls; i++ ) {
    if ( ballExist[i] ) {
      // draw ball
      noStroke();
      fill(shadowColor);
      ellipse(ballX[i] + shadowOffsetX, ballY[i] + shadowOffsetY, ballSize, ballSize);
      fill(ballColor[i]);
      ellipse(ballX[i], ballY[i], ballSize, ballSize);

      // move ball
      ballY[i] += ballVy[i];

      // out of screen check
      if ( height + ballSize/2 < ballY[i] ) {
        ballExist[i] = false;
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
      if ( particleX[i] < 0 || width < particleX[i]
        || particleY[i] < 0 || height < particleY[i] ) {
        particleExist[i] = false;
      }
    }
  }
}

void addBullet(float x, float y) {
  for( int i = 0 ; i < maxBullets ; i++ ) {
    if( !bulletExist[i] ) {
      bulletX[i] = x;
      bulletY[i] = y;
      bulletExist[i] = true;
      break;
    }
  }
}

void addBall(float x, float y) {
  for ( int i = 0; i < maxBalls; i++ ) {
    if ( !ballExist[i] ) {
      ballX[i] = x;
      ballY[i] = y;
      ballVy[i] = random(5, 15);
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
    particleVx[idx] = random(2, 10) * (random(0, 2) < 1.0 ? -1.0 : 1.0);
    particleVy[idx] = random(2, 10) * (random(0, 2) < 1.0 ? -1.0 : 1.0);
    particleExist[idx] = true;
    success = true;
  }
  return success;
}
