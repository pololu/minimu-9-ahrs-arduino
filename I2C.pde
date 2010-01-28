/* ******************************************************* */
/* I2C code for ADXL345 accelerometer                      */
/* and HMC5843 magnetometer                                */
/* ******************************************************* */

int AccelAddress = 0x53;

void I2C_Init()
{
  Wire.begin();
}

void Accel_Init()
{
  Wire.beginTransmission(AccelAddress);
  Wire.send(0x2D);  // power register
  Wire.send(0x08);  // measurement mode
  Wire.endTransmission();
  delay(20);
  Wire.beginTransmission(AccelAddress);
  Wire.send(0x31);  // Data format register
  Wire.send(0x08);  // set to full resolution
  Wire.endTransmission();
  delay(20);	
  // Because our main loop runs at 50Hz we adjust the output data rate to 50Hz (25Hz bandwith)
  //Wire.beginTransmission(AccelAddress);
  //Wire.send(0x2C);  // Rate
  //Wire.send(0x09);  // set to 50Hz, normal operation
  //Wire.endTransmission();
}

// Reads x,y and z accelerometer registers
void Read_Accel()
{
  int i = 0;
  byte buff[6];
  
  Wire.beginTransmission(AccelAddress); 
  Wire.send(0x32);        //sends address to read from
  Wire.endTransmission(); //end transmission
  
  Wire.beginTransmission(AccelAddress); //start transmission to device
  Wire.requestFrom(AccelAddress, 6);    // request 6 bytes from device
  
  while(Wire.available())   // ((Wire.available())&&(i<6))
  { 
    buff[i] = Wire.receive();  // receive one byte
    i++;
  }
  Wire.endTransmission(); //end transmission
  
  if (i==6)  // All bytes received?
    {
    AN[4] = (((int)buff[1]) << 8) | buff[0];    // Y axis
    AN[3] = (((int)buff[3]) << 8) | buff[2];    // X axis
    AN[5] = (((int)buff[5]) << 8) | buff[4];    // Z axis
    accel_x = SENSOR_SIGN[3]*(AN[3]-AN_OFFSET[3]);
    accel_y = SENSOR_SIGN[4]*(AN[4]-AN_OFFSET[4]);
    accel_z = SENSOR_SIGN[5]*(AN[5]-AN_OFFSET[5]);
    }
  else
    Serial.println("!ERR: Error reading accelerometer info!");
}

