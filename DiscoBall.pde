class DiscoBall extends BaseShape {
  boolean isDocked;
  int[] colours;
  float velocity;
  int floorLevel;
  int facets;
  float level;
  float x;
  float y;
  float threshold;
  float multiplier;
  float radius;
  float offset;
  float rateOfChange;
  float difficulty;
  float gravity;
  float glowSize;
  float targetThickness;
  Vec3D gravityVector;
  Emitter emitter;

  HE_Mesh mesh;
  HEC_Geodesic geodesic;

  ColourTransition ct1;
  ColourTransition ct2;

  DiscoBall(PApplet applet) {
    super(applet);

    this.radius = applet.height * .15;
    this.velocity = 17.0;
    this.floorLevel = int(applet.height / 2);
    this.level = 0;
    this.threshold = 0.0020;
    this.offset = applet.height - this.radius;
    this.y = this.offset;
    this.x = applet.width / 2;
    this.facets = 3;
    this.rateOfChange = 0.992;
    this.gravity = 0.07;
    this.difficulty = 1.2;
    this.isDocked = false;
    this.colours = new int[] {
      0xff588ffc,
      0xff382054,
      0xffa04cff,
      0xff522651,
      0xffd545e6,
      0xff7458fc,
      0xffbb45e6,
      0xffcda1ff
    };

    this.gravityVector = new Vec3D( 0, this.gravity, 0 );
    this.emitter = new Emitter( this.gravityVector, this.colours, this.velocity, this.floorLevel, this.radius );
    this.ct1 = new ColourTransition( 0xfff03793, 0xff0fc0fc );
    this.ct2 = new ColourTransition( 0xffFFF51D, 0xff8c0a7e );
    this.glowSize = applet.height * .8;
    this.targetThickness = 5.5;

    images = new Images();
  }

  void lights() {
    directionalLight( 15, 192, 252, 1, .75, -1 ); // Top Left
    directionalLight( 140, 10, 126, 0, 0, -1 );   // Centre
    directionalLight( 228, 0, 124, -1, 1, -1 );   // Top Right
    directionalLight( 228, 148, 5, 0, -1, -1 );   // Bottom Centre
    spotLight( 255, 242, 45, width/2, height/2, height/2, 0, 0, -1, PI, 20 );
  }

  void setup() {
    pgl = ((PGraphicsOpenGL) g).pgl;
    this.geodesic = new HEC_Geodesic();
    this.geodesic.setRadius( this.radius );
    this.geodesic.setB( this.facets );
    this.geodesic.setC( this.facets );
  }

  void draw() {
    background( 0xff000206 );

    pushMatrix();
    translate( applet.width/2, applet.height/2, 0 );
    noFill();
    stroke( 0xfff03793 );
    strokeWeight( this.targetThickness / 2 );
    ellipseMode( CENTER );
    ellipse( 0, 0, (this.radius*2) - this.targetThickness, (this.radius*2) - this.targetThickness );

    popMatrix();

    translate( this.x, this.y, 0 );

    if (this.isDocked) {
      if (!this.ct1.isStarted()) {
        this.ct1.start( 1000 );
      }

      if (!this.ct2.isStarted()) {
        this.ct2.start( 975 );
      }

      renderImage( images.glow, new Vec3D( 0, 0, 0 ), this.glowSize, this.ct1.getColour(), 125.0 );
      renderImage( images.glowInner, new Vec3D( 0, 0, 0 ), this.glowSize, this.ct2.getColour(), 150.0 );
    }

    noStroke();
    fill( 0xff727272 );
    pushMatrix();
    rotateY( delta );
    this.mesh = new HE_Mesh( geodesic );
    this.renderer.drawFaces( mesh );
    popMatrix();

    hint(DISABLE_DEPTH_SORT);
    hint(DISABLE_DEPTH_TEST);

    this.isDocked = (int(this.y) <= int(applet.height/2));

    if (this.isDocked) {
      colorMode( RGB, 1.0 );

      pgl.depthMask( false );
    	pgl.enable( PGL.BLEND );
    	pgl.blendFunc( PGL.SRC_ALPHA, PGL.ONE );
      this.emitter.addParticles( 9 );
      this.emitter.exist();
      counter++;
      delta += (theta * 20);
    } else {
      this.level = (in.left.level() + in.right.level());

      if (this.level > this.threshold) {
        // Ball go up
        this.y *= this.rateOfChange;
      } else {
        // Ball go down
        this.y /= this.rateOfChange;
      }

      if (this.y > this.offset) {
        this.y = this.offset;
      }
    }
    colorMode( RGB, 255 );
    hint(ENABLE_DEPTH_SORT);
    hint(ENABLE_DEPTH_TEST);
  }

  void keyPressed() {
    if (key == CODED) {
      switch (keyCode) {
        // Increase difficulty
        case UP:
          this.threshold *= this.difficulty;
          break;
        // Decrease difficulty
        case DOWN:
          this.threshold *= this.difficulty;
      }
    } else if (key == ' ') {
      // Reset
      this.y = this.offset;
      this.isDocked = false;
      this.emitter.killEmAll();
    }
  }

  void rotate() {
    super.rotate();
  }
}
