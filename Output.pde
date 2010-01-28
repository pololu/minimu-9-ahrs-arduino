
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
      Serial.print (",");
      #endif      
      #if PRINT_ANALOGS==1
      Serial.print("AN:");
      Serial.print(read_adc(0));
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
      /*
      Serial.print(",AN6:");
      Serial.print(magnetom_x);
      Serial.print (",AN7:");
      Serial.print(magnetom_y);
      Serial.print (",AN8:");
      Serial.print(magnetom_z);
      Serial.print (",");*/
      #endif
      #if PRINT_DCM == 1
      Serial.print ("EX0:");
      Serial.print(convert_to_dec(DCM_Matrix[0][0]));
      Serial.print (",EX1:");
      Serial.print(convert_to_dec(DCM_Matrix[0][1]));
      Serial.print (",EX2:");
      Serial.print(convert_to_dec(DCM_Matrix[0][2]));
      Serial.print (",EX3:");
      Serial.print(convert_to_dec(DCM_Matrix[1][0]));
      Serial.print (",EX4:");
      Serial.print(convert_to_dec(DCM_Matrix[1][1]));
      Serial.print (",EX5:");
      Serial.print(convert_to_dec(DCM_Matrix[1][2]));
      Serial.print (",EX6:");
      Serial.print(convert_to_dec(DCM_Matrix[2][0]));
      Serial.print (",EX7:");
      Serial.print(convert_to_dec(DCM_Matrix[2][1]));
      Serial.print (",EX8:");
      Serial.print(convert_to_dec(DCM_Matrix[2][2]));
      Serial.print (",");
      #endif
      
      Serial.println();    
}

long convert_to_dec(float x)
{
  return x*10000000;
}

