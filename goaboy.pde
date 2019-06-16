import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;

PGraphics g;
PImage gi;
PImage logo, year;
boolean start=false;
int countdown=120;

void setup() {
  //size(1120, 1008);
  size(800, 720);
  //size(320, 288);
  noSmooth();
  
  
  logo = loadImage("eelfrothLogo.png");
  year = loadImage("eelfroth2016.png");
  
  g = createGraphics(160, 144);
  g.noSmooth();
  g.beginDraw();
  g.background(255);
  g.endDraw();
  
  minim = new Minim(this);
  
  
  jingle = minim.loadFile("goaboy.mp3", 1024);
  
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
}

void draw() {
  
  gi = g.get();
  g.beginDraw();
    
    
    
    //g.background(255);
    //g.tint(247);
    g.pushMatrix();
    g.translate(g.width/2, g.height/2);
    //g.rotate(frameCount*0.00001);
    g.rotate(0.015);
    //g.rotate(jingle.mix.level()*0.1);
    g.imageMode(CENTER);
    g.image(gi, 0, 0, g.width+4, g.height+4);
    //g.image(gi, 0, 0, g.width+16*jingle.left.level(), g.height+16*jingle.right.level());
    g.popMatrix();
    //g.fill(255);
    g.noFill();
    g.noStroke();
    g.strokeWeight(0.001);
    
    if(!start) {
      if(countdown>0) {
        countdown -= 1;
        
        g.fill(255);
        g.rect(0, 0, g.width, g.height);
        g.imageMode(CORNER);
        g.tint(128);
        g.image(logo, 0, 0);
        g.noTint();
        g.imageMode(CENTER);
      }
      else {
        start = true;
        g.fill(255);
        g.rect(0, 0, g.width, g.height);
        jingle.play();
      }
    }
  
  if(jingle.isPlaying()) {
    
    fft.forward(jingle.mix);
      
    int div = 16;
    for(int i = (fft.specSize()/div); i >0; i--)
    {
      // convert the magnitude to a DB value. 
      // this means values will range roughly from 0 for the loudest
      // bands to some negative value.
      float bandDB = 20 * log( 2 * fft.getBand(fft.specSize()-i*div) / fft.timeSize() *((i*div*100)+1));
      //println(bandDB);
      // so then we want to map our DB value to the height of the window
      // given some reasonable range
      float bandHeight = max(128, map( round(bandDB), 130, 130-3, 96,255));
      g.stroke(bandHeight);
      g.rectMode(CENTER);
      g.pushMatrix();
      g.translate(g.width/2, g.height/2);
      //g.rotate(frameCount*0.00001);
      //g.rotate(-0.66 -frameCount * 0.0002);
      //g.rotate(jingle.mix.level()*2);
      g.ellipse(0,0, (fft.specSize()/div)-i - 167*jingle.left.level(),  (fft.specSize()/div)-i - 167*jingle.right.level());
      g.popMatrix();
    }
    
    for(int i = (fft.specSize()/div); i >(fft.specSize()/div)*0.7; i--)
    {
      // convert the magnitude to a DB value. 
      // this means values will range roughly from 0 for the loudest
      // bands to some negative value.
      float bandDB = 20 * log( 2 * fft.getBand(fft.specSize()-i*div) / fft.timeSize() *((i*div*100)+1));
      //println(bandDB);
      // so then we want to map our DB value to the height of the window
      // given some reasonable range
      float bandHeight = max(128, map( round(bandDB), 120,120-3, 96,255));
      g.stroke(bandHeight);
      g.rectMode(CENTER);
      g.pushMatrix();
      g.translate(g.width/2, g.height/2);
      //g.rotate(frameCount*0.00001);
      //g.rotate(-0.66 -frameCount * 0.0002);
      //g.rotate(jingle.mix.level()*2);
      g.ellipse(0,0, (fft.specSize()/div)-i - 127*jingle.left.level(),  (fft.specSize()/div)-i - 127*jingle.right.level());
      g.popMatrix();
    }
  }
  
  int toEnd = jingle.length() - jingle.position() - 392;
    if( toEnd <= 4000 ) {
      g.fill(255);
      g.ellipse(g.width/2, g.height/2, 50-toEnd*0.025, 50-toEnd*0.025);
      g.imageMode(CORNER);
      g.tint(255);
      g.image(year, 0, -toEnd*0.05 +1);
      g.tint(255);
      g.image(year, 1, -toEnd*0.05);
      g.tint(255);
      g.image(year, -1, -toEnd*0.05);
      g.tint(255);
      g.image(year, 0, -toEnd*0.05);
      g.tint(255);
      g.image(year, 1, -toEnd*0.05 +1);
      g.tint(255);
      g.image(year, -1, -toEnd*0.05+1);
      g.tint(255);
      g.image(year, -1, -toEnd*0.05 -1);
      g.tint(255);
      g.image(year, 1, -toEnd*0.05 -1);
      g.tint(128);
      g.image(year, 0, -toEnd*0.05);
      g.noTint();g.
      
      tint(255);
      g.image(logo, 0, -toEnd*0.05 +1);
      g.tint(255);
      g.image(logo, 1, -toEnd*0.05);
      g.tint(255);
      g.image(logo, -1, -toEnd*0.05);
      g.tint(255);
      g.image(logo, 0, -toEnd*0.05 -1);
      g.tint(128);
      g.image(logo, 0, -toEnd*0.05);
      g.noTint();
      
      println(toEnd);
    }
  
  g.endDraw();
  
  colorMode(HSB, 255);
  tint(64, 100, 255);
  image(g, 0, 0, width, height);
}
