class Images {
  PImage particle;
  PImage corona;
  PImage reflection;
  PImage emitter;
  PImage glow;
  PImage glowInner;

  Images() {
    this.glow = loadImage( "circle_100px_blur.png" );
    this.glowInner = loadImage( "circle_50px_blur.png" );
    this.particle = loadImage( "particle.png" );
    this.corona = loadImage( "corona.png" );
    this.emitter = loadImage( "emitter.png" );
    this.reflection = loadImage( "reflection.png" );
  }
}
