// Adapted from:
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Updated version of flight404 Particle Emitter release 1
// This works with Processing 2.0
class Emitter {
  ArrayList<Particle> particles;
  float offsetRadius;
  float velocity;
  int floorLevel;
  int[] colours;
  Vec3D gravity;
  Vec3D loc;
  Vec3D vec;
  Vec3D vel;

  Emitter ( Vec3D gravity, int[] colours, float velocity, int floorLevel, float offsetRadius) {
    this.loc = new Vec3D();
    this.vel = new Vec3D();
    this.gravity = gravity;
    this.colours = colours;
    this.velocity = velocity;
    this.floorLevel = floorLevel;
    this.offsetRadius = offsetRadius;
    this.particles = new ArrayList<Particle>();
  }

  void exist () {
    this.setPosition();
    this.iterateListExist();

    pgl.disable (PGL.TEXTURE_2D);
  }

  void setPosition () {
    this.loc.addSelf( new Vec3D().randomVector().scaleSelf( random( 1.0 ) ) );
  }

 void iterateListExist () {
    pgl.enable (PGL.TEXTURE_2D);

    int size = this.particles.size ();
    for ( int i = size - 1; i >= 0; i-- ) {
      Particle p = (Particle)this.particles.get(i);

      if ( !p.isDead ) {
        p.exist ();
      } else {
        this.particles.set( i, this.particles.get (this.particles.size () - 1) );
        this.particles.remove( this.particles.size () - 1 );
      }

      if ( p.isSplit ) {
        this.addParticles( p );
      }
    }

    for ( Iterator it = this.particles.iterator(); it.hasNext(); ) {
      Particle p = (Particle) it.next();
      p.renderReflection();
    }
  }

  void addParticles( int num ) {
    for (int i = 0; i < num; i ++) {
      this.particles.add( new Particle( 1, null, this.vel, this.colours, this.gravity, this.velocity, this.floorLevel, this.offsetRadius ) );
    }
  }

  void addParticles( Particle p ) {
    // play with amt if you want to control how many this.particles spawn when splitting
    int amt = (int)( p.radius * .2 );
    for ( int i = 0; i < amt; i++ ) {
      this.particles.add( new Particle( p.gen + 1, p.loc[0], p.vel, this.colours, this.gravity, this.velocity, this.floorLevel,this.offsetRadius ) );
    }
  }

  void killEmAll() {
    for ( int i = this.particles.size()-1; i >= 0; i-- ) {
      Particle p = (Particle)this.particles.get(i);
      this.particles.remove( this.particles.size() - 1 );
    }
  }
}
