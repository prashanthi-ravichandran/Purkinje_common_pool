function[IKr, dC1Herg, dC2Herg, dC3Herg, dOHerg] = calc_HERG(V,EK, C1Herg, C2Herg, C3Herg,OHerg,IHerg)

% HERG(+MiRP1) current parameters for IKr

T_Const_HERG=5.320000001;   %Temp constant from 23 to 37C,with
A0_HERG=0.017147641733086;  
B0_HERG=0.03304608038835;  
A1_HERG=0.03969328381141;  
B1_HERG=-0.04306054163980; 
A2_HERG=0.02057448605977;
B2_HERG=0.02617412715118;
A3_HERG=0.00134366604423;
B3_HERG=-0.02691385498399;
A4_HERG=0.10666316491288;
B4_HERG=0.00568908859717;
A5_HERG=0.00646393910049;
B5_HERG=-0.04536642959543;
A6_HERG=0.00008039374403;
B6_HERG=0.00000069808924;
C2H_to_C3H=T_Const_HERG*0.02608362043337;
C3H_to_C2H=T_Const_HERG*0.14832978132145;
 
GKr=0.029; % by Reza
Ko=    4.0;   % extracellular K+   concentration (mM)

fKo = power(Ko/4.0,0.5);
IKr = GKr*fKo*OHerg*(V-EK);

C1H_to_C2H = T_Const_HERG*A0_HERG*exp(B0_HERG*V);
C2H_to_C1H = T_Const_HERG*A1_HERG*exp(B1_HERG*V);
C3H_to_OH =  T_Const_HERG*A2_HERG*exp(B2_HERG*V);
OH_to_C3H =  T_Const_HERG*A3_HERG*exp(B3_HERG*V);
OH_to_IH =   T_Const_HERG*A4_HERG*exp(B4_HERG*V);
IH_to_OH =   T_Const_HERG*A5_HERG*exp(B5_HERG*V);
C3H_to_IH =  T_Const_HERG*A6_HERG*exp(B6_HERG*V);
IH_to_C3H =  (OH_to_C3H*IH_to_OH*C3H_to_IH)/(C3H_to_OH*OH_to_IH);

dC1Herg = C2H_to_C1H * C2Herg - C1H_to_C2H * C1Herg;
a1 = C1H_to_C2H * C1Herg + C3H_to_C2H * C3Herg;
a2 = (C2H_to_C1H + C2H_to_C3H) * C2Herg;
dC2Herg = a1-a2;
a1 = C2H_to_C3H*C2Herg + OH_to_C3H*OHerg + IH_to_C3H*IHerg;
a2 = (C3H_to_IH + C3H_to_OH + C3H_to_C2H) * C3Herg; 
dC3Herg = a1-a2;			
a1 = C3H_to_OH * C3Herg + IH_to_OH * IHerg;
a2 = (OH_to_C3H + OH_to_IH) * OHerg;
dOHerg = a1-a2;	

   
end

