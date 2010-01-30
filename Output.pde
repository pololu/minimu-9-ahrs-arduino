
void printdata(void)
{    
      Serial.print("!");

      #if PRINT_EULER == 1
      Serial.print("ANG:");
      Serial.print(ToDeg(roll));
      Serial.print(",");
      Serial.print(ToDeg(pitch));
      Serial.print(",");
      Serial.print(ToDeg(yaw));
      //Serial.print(",");
      //Serial.print(ToDeg(MAG_Heading));
      #endif      
      #if PRINT_ANALOGS==1
      Serial.print(",AN:");
      /*Serial.print(read_adc(0));
      Serial.print(",");
      Serial.print(read_adc(1));
      Serial.print(",");
      Serial.print(read_adc(2));  
      Serial.print(",");
      Serial.print(accel_x);
      Serial.print (",");
      Serial.print(accel_y);
      Serial.print (",");
      Serial.print(accel_z);
      Serial.print(",");*/
      Serial.print((int)magnetom_x);
      Serial.print (",");
      Serial.print((int)magnetom_y);
      Serial.print (",");
      Serial.print((int)magnetom_z);      
      #endif
      #if PRINT_DCM == 1
      Serial.print (",DCM:");
      Serial.print(convert_to_dec(DCM_Matrix[0][0]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[0][1]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[0][2]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[1][0]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[1][1]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[1][2]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[2][0]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[2][1]));
      Serial.print (",");
      Serial.print(convert_to_dec(DCM_Matrix[2][2]));
      #endif
      Serial.println();    
}

long convert_to_dec(float x)
{
  return x*10000000;
}

