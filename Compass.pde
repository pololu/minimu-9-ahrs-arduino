// Local magnetic declination
// I use this web : http://www.ngdc.noaa.gov/geomagmodels/Declination.jsp
//#define MAGNETIC_DECLINATION -6.0    // not used now -> magnetic bearing

#define M_X_MIN -796
#define M_Y_MIN -457
#define M_Z_MIN -424
#define M_X_MAX 197
#define M_Y_MAX 535
#define M_Z_MAX 397

void Compass_Heading()
{
  float MAG_X;
  float MAG_Y;
  float cos_roll;
  float sin_roll;
  float cos_pitch;
  float sin_pitch;
  
  cos_roll = cos(roll);
  sin_roll = sin(roll);
  cos_pitch = cos(pitch);
  sin_pitch = sin(pitch);
  
  c_magnetom_x = (float)(magnetom_x - SENSOR_SIGN[6]*M_X_MIN) / (SENSOR_SIGN[6]*M_X_MAX - SENSOR_SIGN[6]*M_X_MIN) - 0.5;
  c_magnetom_y = (float)(magnetom_y - SENSOR_SIGN[7]*M_Y_MIN) / (SENSOR_SIGN[7]*M_Y_MAX - SENSOR_SIGN[7]*M_Y_MIN) - 0.5;
  c_magnetom_z = (float)(magnetom_z - SENSOR_SIGN[8]*M_Z_MIN) / (SENSOR_SIGN[8]*M_Z_MAX - SENSOR_SIGN[8]*M_Z_MIN) - 0.5;
  
  // Tilt compensated Magnetic filed X:
  MAG_X = c_magnetom_x*cos_pitch+c_magnetom_y*sin_roll*sin_pitch+c_magnetom_z*cos_roll*sin_pitch;
  //MAG_X = c_magnetom_x*cos_pitch + c_magnetom_z*sin_pitch;
  // Tilt compensated Magnetic filed Y:
  MAG_Y = c_magnetom_y*cos_roll-c_magnetom_z*sin_roll;
  //MAG_Y = c_magnetom_x*sin_roll*sin_pitch + c_magnetom_y*cos_roll - c_magnetom_z*sin_roll*cos_pitch;
  // Magnetic Heading
  MAG_Heading = atan2(-MAG_Y,MAG_X);
}

void Compass_Calibrate()
{
  static int min[3] = {0x7FFF, 0x7FFF, 0x7FFF};
  static int max[3] = {-0x8000, -0x8000, -0x8000};
 
  max[0] = max(max[0], magnetom_x);
  max[1] = max(max[1], magnetom_y);
  max[2] = max(max[2], magnetom_z);
  
  min[0] = min(min[0], magnetom_x);
  min[1] = min(min[1], magnetom_y);
  min[2] = min(min[2], magnetom_z);

  Serial.print("Max:");
  Serial.print(max[0]);
  Serial.print(",");
  Serial.print(max[1]);
  Serial.print(",");
  Serial.print(max[2]);
  Serial.print(",Min:");
  Serial.print(min[0]);
  Serial.print(",");
  Serial.print(min[1]);
  Serial.print(",");
  Serial.println(min[2]);
}
