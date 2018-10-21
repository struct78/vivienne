class Grid extends BaseShape {
  HE_Mesh mesh;

  int width;
  int height;
  int facets;
  int gap;
  float[][] values;
  int type;
  float multiplier;
  float noise;
  float max;
  boolean strokeLines;

  List<WB_Point> points;

  Grid(PApplet applet) {
    super(applet);
    this.width = 900;
    this.height = 900;
    this.facets = 64;
    this.multiplier = 40.0;
    this.noise = 0.135;
    this.values = new float[this.facets][this.facets];
    this.type = SpectrumType.Band;
    this.max = 700;
    this.strokeLines = false;
  }

  int mapint( float m, int a, float b, int min, int max ) {
    return int( map(m, a, b, min, max ) );
  }

  void draw() {
    background( 0xff14011E );

    if ( this.strokeLines ) {
      stroke( 0xffffffff, 10 );
    } else {
      noStroke();
    }

    int distance = int( ( ( float )sq( this.facets ) ) / ( float ) fft.specSize() );
    float freq;
    int z = 0;
    int x = 0;
    int y = 0;
    int d = 0;
    int c = 0;
    int s = 1;

    x = ( (int) floor( this.facets/2.0) ) - 1;
    y = ( (int) floor( this.facets/2.0) ) - 1;

    for ( int k = 1; k <= ( this.facets-1 ) ; k++ ) {
      for ( int j = 0; j< ( k < ( this.facets-1 ) ? 2 : 3 ) ; j++ ) {
        for ( int i = 0; i<s; i++ ) {
          switch ( d ) {
              case 0:
                y = y + 1;
                break;
              case 1:
                x = x + 1;
                break;
              case 2:
                y = y - 1;
                break;
              case 3:
                x = x - 1;
                break;
          }

          switch(this.type) {
            case SpectrumType.Band:
              freq = fft.getBand( this.mapint( z, 0, sq(this.facets), 0, fft.specSize() ) );
              break;
            case SpectrumType.Average:
              freq = fft.getAvg( this.mapint( z, 0, sq(this.facets), 0, fft.avgSize() ) );
              break;
            case SpectrumType.WaveForm:
              freq = in.right.get( this.mapint( z, 0, sq(this.facets), 0, in.bufferSize() ) ) + in.left.get( this.mapint( z, 0, sq(this.facets), 0, fft.avgSize() ) );
              break;
            default:
              freq = 0;
              break;
          }

          freq *= this.multiplier;
          freq *= noise( this.noise * x, this.noise * y );
          freq = constrain(freq, 0, this.max);

          if (freq < this.values[x][y]) {
            this.values[x][y] = this.values[x][y] * 0.975;
          } else {
            this.values[x][y] = freq;
          }

          z++;
        }

        d = (d+1)%4;
      }

      s = s + 1;
    }

    this.mesh = new HE_Mesh(
      new HEC_Grid()
        .setU( this.facets-1 )
        .setUSize( this.width )
        .setV( this.facets-1 )
        .setVSize( this.height )
        .setWValues( this.values )
    );

    HE_VertexIterator vitr = this.mesh.vItr();
    while (vitr.hasNext()) {
      HE_Vertex next = vitr.next();
      double zd = Math.abs(next.zd());
      next.setColor( lerpColor( 0xff3D2F61, 0xffBCFFAD, (float)zd/(this.max/2) ) );
    }

    this.renderer.drawFacesVC( mesh );
  }

  void rotate() {
    super.rotate();

    translate( applet.width / 2, ( applet.height / 2 ), 0 );
    rotateX( radians(70) );
    rotateZ( delta );
  }
}
