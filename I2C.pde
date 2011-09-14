/* ******************************************************* */
/* I2C code for ADXL345 accelerometer                      */
/* and HMC5843 magnetometer                                */
/* ******************************************************* */

#include <LSM303DLH.h>
#include <L3G4200D.h>

LSM303DLH compass;
L3G4200D gyro;

void I2C_Init()
{
  Wire.begin();
}

void Accel_Init()
{
  compass.writeAccReg(LSM303DLH_CTRL_REG1_A, 0x27); // normal power mode, all axes enabled, 50 Hz
  compass.writeAccReg(LSM303DLH_CTRL_REG4_A, 0x30); // 8 g full scale
}

// Reads x,y and z accelerometer registers
void Read_Accel()
{
  compass.readAcc();
  
  ACC[0] = compass.a.x;
  ACC[1] = compass.a.y;
  ACC[2] = compass.a.z;
  AN[3] = ACC[0];
  AN[4] = ACC[1];
  AN[5] = ACC[2];
  accel_x = SENSOR_SIGN[3] * (ACC[0] - AN_OFFSET[3]);
  accel_y = SENSOR_SIGN[4] * (ACC[1] - AN_OFFSET[4]);
  accel_z = SENSOR_SIGN[5] * (ACC[2] - AN_OFFSET[5]);
}

void Compass_Init()
{
  compass.writeMagReg(LSM303DLH_MR_REG_M, 0x00); // continuous conversion mode
  // 15 Hz default
}

void Read_Compass()
{
  compass.readMag();
  
  magnetom_x = SENSOR_SIGN[6] * compass.m.x;
  magnetom_y = SENSOR_SIGN[7] * compass.m.y;
  magnetom_z = SENSOR_SIGN[8] * compass.m.z;
}

void Gyro_Init()
{
  gyro.writeReg(L3G4200D_CTRL_REG1, 0x0F); // normal power mode, all axes enabled, 100 Hz
  gyro.writeReg(L3G4200D_CTRL_REG4, 0x20); // 2000 dps full scale
}

void Read_Gyro()
{
  gyro.read();
  
  AN[0] = gyro.g.x;    // X axis
  AN[1] = gyro.g.y;    // Y axis 
  AN[2] = gyro.g.z;    // Z axis
}

