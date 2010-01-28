
//  Functions to get accelerometer and magnetometer data via I2C

void Read_accel_magnetom(void)
{
accel_x = SENSOR_SIGN[3]*AN[3];
accel_y = SENSOR_SIGN[4]*AN[4];
accel_z = SENSOR_SIGN[5]*AN[5];
magnetom_x = SENSOR_SIGN[6]*AN[6];
magnetom_y = SENSOR_SIGN[7]*AN[7];
magnetom_z = SENSOR_SIGN[8]*AN[8];
}


void Read_accel_raw(void)
{  /*   Just psuedo-code
	//0xA6 for a write
	//0xA7 for a read
	
	uint8_t dummy, datah, datal;
	
	
	//   This section to read x axis accelerometer	

	//0x32 data registers
	AN[3] = (float)(datal|(datah << 8));
	
	//  Now we read the y axis

	//0x34 data registers
	AN[4] = (float)(datal|(datah << 8));
	
	//   Now we read the z axis
	
	//0x36 data registers
	AN[5] = (float)(datal|(datah << 8));	
	*/
}

void Read_magnetom_raw(void)
{  /*   just psuedo-code
	
	//	The magnetometer values must be read consecutively
	//	in order to move the magnetometer pointer. 
	
	
	uint8_t datah, datal;
	
	Send (0x3C);    //write to HMC
	Send (0x02);    //mode register
	Send (0x00);    //continuous measurement mode
	
	//must read all six registers plus one to move the pointer back to 0x03
	
	Send(0x3D);          //read from HMC
	
	datah = Received Byte;	//x high byte
	datal = Received Byte;	//x low byte
	AN[6] = (float)(datal|(datah << 8));		// The value will have a range of -2048 to 2047
	
	datah = Received Byte;	//y high byte
	datal = Received Byte;	//y low byte
	AN[7] = (float)(datal|(datah << 8));		// The value will have a range of -2048 to 2047
	
	datah = Received Byte;	//z high byte
	datal = Received Byte;	//z low byte
	AN[7] = (float)(datal|(datah << 8));		// The value will have a range of -2048 to 2047
	
	Send (0x3D);         //must reach 0x09 to go back to 0x03
	*/
}
