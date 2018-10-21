import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.util.*;
import toxi.geom.*;
import damkjer.ocd.*;

List<BaseShape> shapes;
int index = 0;

Grid grid;
SpikeyBall spikeyBall;
Wave wave;
DiscoBall discoBall;


// Audio
Minim minim;
AudioInput in;
FFT fft;

float theta = 0.004;
float delta = 0;
float volume = 0.0;
float scale = 1.0;
Ani animation;


// Disco Ball
Vec3D gravity;
Images images;
Emitter emitter;
int floorLevel;
ArrayList<Emitter> emitters;
PGL pgl;
int counter = 0;

void settings() {
  fullScreen(P3D);
  pixelDensity(2);
}

void setup() {
  noCursor();
  frameRate(60);
  setupAudio();
  setupShapes();
}

void setupShapes() {
  shapes = new ArrayList<BaseShape>();
  grid = new Grid(this);
  grid.setup();

  spikeyBall = new SpikeyBall(this);
  spikeyBall.setup();

  discoBall = new DiscoBall(this);
  discoBall.setup();

  wave = new Wave(this);
  wave.setup();

  shapes.add(wave);
  shapes.add(discoBall);
  shapes.add(grid);
  shapes.add(spikeyBall);
}

void setupAudio() {
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  fft.linAverages( 256 );
}

void draw() {
  fft.forward( in.mix );

  BaseShape currentShape = shapes.get(index);
  currentShape.lights();
  currentShape.rotate();
  currentShape.draw();
}

void keyPressed() {
  BaseShape currentShape = shapes.get(index);
  currentShape.keyPressed();

  if (key == CODED) {
    if (keyCode == LEFT) {
      index--;

      if (index < 0) {
        index = shapes.size()-1;
      }
    }

    if (keyCode == RIGHT) {
      index++;

      if (index >= shapes.size()) {
        index = 0;
      }
    }
  }
}
