class SpikeyBall extends BaseShape {
  int radius;
  int facets;
  float scale;
  float multiplier;

  HE_Mesh mesh;
  HEC_Geodesic geodesic;
  HEM_Extrude extrude;

  SpikeyBall( PApplet applet ) {
    super( applet );
    this.radius = 300;
    this.facets = 4;
    this.multiplier = 400;
  }

  void lights() {
    directionalLight( 228, 148, 5, 1, .75, -1 ); // Top Left
    directionalLight( 15, 192, 252, 0, 0, -1 );  // Centre
    directionalLight( 140, 10, 126, -1, 1, -1 ); // Top Right
    directionalLight( 228, 0, 124, 0, -1, -1 );  // Bottom Centre
  }

  void setup() {
    this.geodesic = new HEC_Geodesic();
    this.geodesic.setRadius( this.radius );
    this.geodesic.setB( this.facets );
    this.geodesic.setC( this.facets );
    this.extrude = new HEM_Extrude();
  }

  void draw() {
    background( 0xff000206 );
    fill( 0xff727272 );
    noStroke();

    float volume = in.right.level() + in.left.level() / 2 * multiplier;

    this.mesh = new HE_Mesh( geodesic );
    this.extrude.setDistance( volume ).setChamfer( 1.0 ).setHardEdgeChamfer( 1.0 );
    this.mesh.modify( extrude );
    this.renderer.drawFaces( mesh );
  }

  void rotate() {
    super.rotate();

    translate( width / 2, ( height / 2 ), 0 );
    rotateX( delta/PI );
    rotateY( delta );
  }
}
