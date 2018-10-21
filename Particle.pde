// Adapted from:
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Updated version of flight404 Particle Emitter release 1
// This works with Processing 2.0

public class Particle {
  boolean isBouncing;
  boolean isReboundingLeft;
  boolean isReboundingRight;
  boolean isBouncingOffRoof;
  boolean isDead;
  boolean isSplit;
  color tint;
  float age;
  float agePer;
  float ageTime;
  float bounceAge;
  float bounceVel;
  float radius;
  float velocity;
  float offsetRadius;
  float floorLevel;
  float leftWallLevel;
  float roofLevel;
  float rightWallLevel;
  int alphaMul;
  int gen;
  int len;
  int lifeSpan;
  int[] colours;
  Vec3D gravity;
  Vec3D startLoc;
  Vec3D vel;
  Vec3D[] loc;

  Particle( int gen, Vec3D loc, Vec3D vel, int[] colours, Vec3D gravity, float velocity, float floorLevel, float offsetRadius ) {
    this.gen = gen;
    this.radius = random( 6 - gen, 45 - ( gen-1 ) * 10 );
    this.len = (int)( this.radius );
    this.loc = new Vec3D[ this.len ];
    this.offsetRadius = offsetRadius;
    this.isReboundingLeft = false;
    this.isReboundingRight = false;
    this.isBouncingOffRoof = false;
    this.isBouncing = false;
    this.alphaMul = 4;

    float startAngle = random( 1.0 ) * TWO_PI;
    float startX = this.offsetRadius * cos( startAngle );
    float startY = this.offsetRadius * sin( startAngle );
    float startZ = -random( 0, floorLevel );

    if (loc == null) {
      this.startLoc = new Vec3D(
          startX,
          startY,
          startZ
        );
    } else {
      this.startLoc = new Vec3D( loc.add( new Vec3D().randomVector().scaleSelf( random( 1.0 ) ) ) );
    }

    for( int i = 0; i < len; i++ ) {
      this.loc[i] = new Vec3D( this.startLoc );
    }

    this.vel = new Vec3D( vel );

    if ( this.gen > 1 ) {
      this.vel.addSelf( new Vec3D().fromXYTheta( startAngle ).scaleSelf( random( 1.0, velocity / 2 ) ) );
    } else {
      this.vel.addSelf( new Vec3D().fromXYTheta( startAngle ).scaleSelf( random( 1.0, velocity ) ) );
    }

    this.ageTime = 0.0895;
    this.gravity = gravity;
    this.age = 0;
    this.bounceAge = 2;
    this.lifeSpan = (int)( radius );
    this.colours = colours;
    this.tint = this.colours[ (int)random(this.colours.length) ];
    this.floorLevel = floorLevel;
    this.leftWallLevel = -width/2;
    this.rightWallLevel = width/2;
    this.roofLevel = -height/2;
  }

  void exist(){
    this.findVelocity();
    this.setPosition();
    this.render();
    this.setAge();
  }

  void findVelocity() {
    this.vel.addSelf( this.gravity );
    this.isBouncing = ( this.loc[0].y + this.vel.y > this.floorLevel );
    this.isBouncingOffRoof = ( this.loc[0].y + this.vel.y < this.roofLevel );
    this.isReboundingRight = ( this.loc[0].x + this.vel.x > this.rightWallLevel );
    this.isReboundingLeft = ( this.loc[0].x + this.vel.x < this.leftWallLevel );

    if ( this.isReboundingLeft || this.isReboundingRight ) {
      this.vel.x *= -( ( this.radius/40.0 ) * .5 );
    }

    if ( this.isBouncing || this.isBouncingOffRoof ) {
      this.vel.y *= -( ( this.radius/40.0 ) * .5 );
    }

    if ( this.isReboundingRight || this.isReboundingLeft || this.isBouncing || this.isBouncingOffRoof ) {
      this.vel.scaleSelf( .75 );
      this.bounceVel = this.vel.magnitude();
      this.isSplit = ( this.bounceVel > 5.0 && this.gen < 4 );
    } else {
      this.isSplit = false;
    }
  }

  void setPosition() {
    for ( int i = len-1 ; i > 0 ; i-- ){
      this.loc[ i ].set( loc[ i-1 ] );
    }

    this.loc[ 0 ].addSelf( vel );
  }

  void render() {
    renderImage( images.particle, this.loc[0], this.radius * this.agePer, this.tint, 1.0 );
    renderImage( images.particle, this.loc[0], this.radius * this.agePer * .5, this.tint, agePer );
  }

  void renderReflection() {
    // Floor
    float distance = this.floorLevel - this.loc[0].y;
    float reflectMaxDistance = 50.0;
    float yPer = ( 1.0 - ( distance/reflectMaxDistance ) ) * .5;

    if ( yPer > .05 ) {
      renderImageOnFloor( images.reflection, new Vec3D( this.loc[0].x, this.floorLevel, this.loc[0].z ), this.radius * this.agePer * this.alphaMul * yPer, color( this.agePer, this.agePer*.25, 0 ), yPer + random( .2 ) );
    }

    // Left wall
    distance = abs(this.leftWallLevel - this.loc[0].x);
    yPer = ( 1.0 - ( distance/reflectMaxDistance ) ) * .5;

    if ( yPer > .05 ) {
      renderImageOnWall( images.reflection, new Vec3D( this.leftWallLevel, this.loc[0].y, this.loc[0].z ), this.radius * this.agePer * this.alphaMul * yPer, color( this.agePer, this.agePer*.25, 0 ), yPer + random( .2 ) );
    }

    // Right wall
    distance = this.rightWallLevel - this.loc[0].x;
    yPer = ( 1.0 - ( distance/reflectMaxDistance ) ) * .5;

    if ( yPer > .05 ) {
      renderImageOnWall( images.reflection, new Vec3D( this.rightWallLevel, this.loc[0].y, this.loc[0].z ), this.radius * this.agePer * this.alphaMul * yPer, color( this.agePer, this.agePer*.25, 0 ), yPer + random( .2 ) );
    }

    // Roof
    distance = abs(this.roofLevel - this.loc[0].y);
    yPer = ( 1.0 - ( distance/reflectMaxDistance ) ) * .5;

    if ( yPer > .05 ) {
      renderImageOnRoof( images.reflection, new Vec3D( this.loc[0].x, this.roofLevel, this.loc[0].z ), this.radius * this.agePer * this.alphaMul * yPer, color( this.agePer, this.agePer*.25, 0 ), yPer + random( .2 ) );
    }
  }

  void setAge() {
    if ( this.isBouncing ) {
      this.age += this.bounceAge;
      this.bounceAge ++;
    }
    else {
      this.age += .25;
    }

    if ( this.age > this.lifeSpan ) {
      this.isDead = true;
    } else {
      this.agePer = 1.0 - this.age / (float)this.lifeSpan;
    }
  }
}
