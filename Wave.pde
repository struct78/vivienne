class Wave extends BaseShape {
  PShader blur;
  PGraphics pg;
  int waves;
  int steps;
  int theta;

  Wave( PApplet applet ) {
    super( applet );
  }

  void setup() {
    this.blur = loadShader("blur.glsl");
    this.pg = createGraphics(width, height, P3D);
    this.waves = fft.specSize();
    this.steps = 10;
    this.theta = 0;
  }

  void draw() {
    this.pg.beginDraw();
    this.pg.background(0);
    this.pg.strokeWeight(1);
    this.pg.noFill();
    this.pg.translate(0, height/2);

    for ( int j = 0; j < fft.specSize(); j++ ) {
      this.pg.stroke( 255*noise(j/1.0), 255-255*noise(j/1.0), 255, 75 );
      this.pg.beginShape();

      float freq = fft.getBand( j );

      for ( int i=0; i < width+(j+5); i+=(j+1)) {
        pg.curveVertex( (float)(i * 1.0*i/width), freq * sin(i - this.theta) );
      }

      this.pg.endShape();
    }

    this.theta += 0.001;

    //this.pg.filter(this.blur);
    this.pg.endDraw();

    image(this.pg, 0, 0);
  }
}
