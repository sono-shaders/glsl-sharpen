
float threshold(in float thr1, in float thr2 , in float val) {
  if (val < thr1) {return 0.0;}
  if (val > thr2) {return 1.0;}
  return val;
}

// averaged pixel intensity from 3 color channels
float average(in vec4 pix) {
  return (pix.r + pix.g + pix.b) / 3.0;
}

vec4 getPixelOffset(in sampler2D tex, in vec2 coords, in float dx, in float dy) {
  return texture2D(tex,coords + vec2(dx, dy));
}

// returns pixel color
float edge(in sampler2D tex, in vec2 coords, in vec2 renderSize){
  float dx = 1.0 / renderSize.x;
  float dy = 1.0 / renderSize.y;
  float pix[9];
  
  pix[0] = average(getPixelOffset(tex, coords, -1.0 * dx, -1.0 * dy));
  pix[1] = average(getPixelOffset(tex, coords, -1.0 * dx , 0.0 * dy));
  pix[2] = average(getPixelOffset(tex, coords, -1.0 * dx , 1.0 * dy));
  pix[3] = average(getPixelOffset(tex, coords, 0.0 * dx , -1.0 * dy));
  pix[4] = average(getPixelOffset(tex, coords, 0.0 * dx , 0.0 * dy));
  pix[5] = average(getPixelOffset(tex, coords, 0.0 * dx , 1.0 * dy));
  pix[6] = average(getPixelOffset(tex, coords, 1.0 * dx , -1.0 * dy));
  pix[7] = average(getPixelOffset(tex, coords, 1.0 * dx , 0.0 * dy));
  pix[8] = average(getPixelOffset(tex, coords, 1.0 * dx , 1.0 * dy));

  // average color differences around neighboring pixels
  float delta = (abs(pix[1]-pix[7])+
          abs(pix[5]-pix[3]) +
          abs(pix[0]-pix[8])+
          abs(pix[2]-pix[6])
           )/4.;

  return threshold(0.25,0.4,clamp(3.0*delta,0.0,1.0));
}
#pragma glslify: export(edge)
