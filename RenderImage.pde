void renderImage(PImage img, Vec3D _loc, float _diam, color _col, float _alpha ) {
  pushMatrix();
  //pov.glReverseCamera();
  translate( _loc.x, _loc.y, _loc.z );
  tint(red(_col), green(_col), blue(_col), _alpha);
  imageMode(CENTER);
  image(img,0,0,_diam,_diam);
  popMatrix();
}

void renderImageOnFloor(PImage img,  Vec3D _loc, float _diam, color _col, float _aa ) {
  pushMatrix();
  translate( _loc.x, _loc.y, _loc.z );
  rotateX(radians(80));
  tint(red(_col), green(_col), blue(_col), _aa);
  imageMode(CENTER);
  image(img,0,0,_diam,_diam);
  popMatrix();
}

void renderImageOnWall(PImage img,  Vec3D _loc, float _diam, color _col, float _aa ) {
  pushMatrix();
  translate( _loc.x, _loc.y, _loc.z );
  if (_loc.x < 0) {
    rotateY(radians(45));
  } else {
    rotateY(radians(-45));
  }
  tint(red(_col), green(_col), blue(_col), _aa);
  imageMode(CENTER);
  image(img,0,0,_diam,_diam);
  popMatrix();
}

void renderImageOnRoof(PImage img,  Vec3D _loc, float _diam, color _col, float _aa ) {
  pushMatrix();
  translate( _loc.x, _loc.y, _loc.z );
  rotateY(radians(-80));
  tint(red(_col), green(_col), blue(_col), _aa);
  imageMode(CENTER);
  image(img,0,0,_diam,_diam);
  popMatrix();
}
