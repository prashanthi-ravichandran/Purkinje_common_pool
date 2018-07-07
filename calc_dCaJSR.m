function [dCaJSR, Jtr_local, ICa_local, Ito2_local,Jxfer_local, JRyRtot] = calc_dCaJSR(V,Cai, CaNSR, CaJSR, CaSS1,CaSS2, CaSS3, CaSS4, RyR11, RyR12, RyR13, RyR14, RyR15,...
                                     RyR21, RyR22, RyR23, RyR24, RyR25, RyR31, RyR32, RyR33, RyR34, RyR35, RyR41, RyR42,...
                                     RyR43, RyR44, RyR45, LCC1, LCC2,LCC3, LCC4, Y1, Y2, Y3, Y4, Ito2_1, Ito2_2, Ito2_3, Ito2_4)
Nclefts_FRU = 4;
CSQNtot= 13.5; 
KmCSQN=   0.63; 
JRyRmax= (0.6*1.5*1.1*3.96);
tautr= 3.0;
 
Faraday=  96.5;     % Faraday's constant (C/mmol)
Temp=    310.0;     % absolute temperature (K)
Rgas=      8.314;   % ideal gas constant (J/[mol*K])
RT_over_F= (Rgas*Temp/Faraday); %  Rgas*Temp/Faraday (mV)

% subspace to cytosol (1/ms)
tauxfer= 0.005;


VF_over_RT=V/RT_over_F;
VFsq_over_RT=(1000.0*Faraday)*VF_over_RT;
exp_VFRT = exp(VF_over_RT);
exp_2VFRT = exp(2.0*VF_over_RT);
 
Cao=   2.0;   % extracellular Ca++ concentration (mM)
Clo= 150.0;   % extracellular Cl-  concentration (mM)
Cli=  20.0;   % intracellular Cl-  concentration (mM)
 
O1_LType = 6;
O2_LType = 12;
Oy_LType = 2;
O1_RyR   = 3;
O2_RyR   = 4;
O3_RyR   = 7;
O_Ito2   = 2;

Acap= 1.995700000000000e-04; % capacitive membrane area (cm^2)
VJSR= 5.522527185929159e-10; % network SR volume (uL)
VSS= 4.958282694018225e-12; % subspace volume (uL)

PCa= 2*(1.5/2.8*0.2*0.9*0.9468e-11)*(12500/475); %(cm/s) *uF  

PCl= 2.65e-15*(12500/475); %(cm/s) *uF 

beta_JSR  = 1./( 1 + (CSQNtot.*KmCSQN)./(KmCSQN + CaJSR).^2);

Jtr_local = (CaNSR - CaJSR)./tautr;

NRyR_open1 = 0;
NRyR_open2 = 0;
NRyR_open3 = 0;
NRyR_open4 = 0;

 if(RyR11 == O1_RyR || RyR11 == O2_RyR || RyR11 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR12 == O1_RyR || RyR12 == O2_RyR || RyR12 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR13 == O1_RyR || RyR13 == O2_RyR || RyR13 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR14 == O1_RyR || RyR14 == O2_RyR || RyR14 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR15 == O1_RyR || RyR15 == O2_RyR || RyR15 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 
  if(RyR21 == O1_RyR || RyR21 == O2_RyR || RyR21 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR22 == O1_RyR || RyR22 == O2_RyR || RyR22 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR23 == O1_RyR || RyR23 == O2_RyR || RyR23 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR24 == O1_RyR || RyR24 == O2_RyR || RyR24 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR25 == O1_RyR || RyR25 == O2_RyR || RyR25 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 
  if(RyR31 == O1_RyR || RyR31 == O2_RyR || RyR31 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR32 == O1_RyR || RyR32 == O2_RyR || RyR32 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR33 == O1_RyR || RyR33 == O2_RyR || RyR33 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR34 == O1_RyR || RyR34 == O2_RyR || RyR34 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR35 == O1_RyR || RyR35 == O2_RyR || RyR35 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 
  if(RyR41 == O1_RyR || RyR41 == O2_RyR || RyR41 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR42 == O1_RyR || RyR42 == O2_RyR || RyR42 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR43 == O1_RyR || RyR43 == O2_RyR || RyR43 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR44 == O1_RyR || RyR44 == O2_RyR || RyR44 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR45 == O1_RyR || RyR45 == O2_RyR || RyR45 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 
 
JRyR_1 = JRyRmax*NRyR_open1.*(CaJSR-CaSS1);
JRyR_2 = JRyRmax*NRyR_open2.*(CaJSR-CaSS2);
JRyR_3 = JRyRmax*NRyR_open3.*(CaJSR-CaSS3);
JRyR_4 = JRyRmax*NRyR_open4.*(CaJSR-CaSS4);
JRyRtot = JRyR_1+JRyR_2+JRyR_3+JRyR_4; 

Jxfer_1 = (CaSS1-Cai)/tauxfer;
Jxfer_2 = (CaSS2-Cai)/tauxfer;
Jxfer_3 = (CaSS3-Cai)/tauxfer;
Jxfer_4 = (CaSS4-Cai)/tauxfer;
Jxfer_local = Jxfer_1 + Jxfer_2+ Jxfer_3 + Jxfer_4;

dCaJSR = beta_JSR.*(Jtr_local - (VSS/VJSR).*JRyRtot); 

ICa_local = 0.0;
Ito2_local = 0.0;

ICa_numerator = 0.0;
OCa_numerator = 0;
NIto2_Open = 0;

if((LCC1 == O1_LType ||LCC1== O2_LType) && (Y1 == Oy_LType))        
    ICa_numerator = ICa_numerator + CaSS1;
    OCa_numerator = OCa_numerator + 1;
end

if((LCC2 == O1_LType ||LCC2== O2_LType) && (Y2 == Oy_LType))        
    ICa_numerator = ICa_numerator + CaSS2;
    OCa_numerator = OCa_numerator + 1;
end

if((LCC3 == O1_LType ||LCC3== O2_LType) && (Y3 == Oy_LType))        
    ICa_numerator = ICa_numerator + CaSS3;
    OCa_numerator = OCa_numerator + 1;
end

if((LCC4 == O1_LType ||LCC4== O2_LType) && (Y4 == Oy_LType))        
    ICa_numerator = ICa_numerator + CaSS4;
    OCa_numerator = OCa_numerator + 1;
end

if(Ito2_1 ==O_Ito2)
   NIto2_Open = NIto2_Open + 1;
end

if(Ito2_2 ==O_Ito2)
   NIto2_Open = NIto2_Open + 1;
end

if(Ito2_3 ==O_Ito2)
   NIto2_Open = NIto2_Open + 1;
end

if(Ito2_4 ==O_Ito2)
   NIto2_Open = NIto2_Open + 1;
end

if (abs(V)<1.e-6)  % First order Taylor expansion
    ICa_fac    = ICa_numerator- OCa_numerator*Cao*0.341; 
    ICa_local  = PCa*2.0*1000.0*Faraday*ICa_fac;
    ICa_local = ICa_local/Acap;		% divide by uF(Acap) to get current normalized to surface area
    Ito2_local = NIto2_Open*PCl*1000.0*Faraday*(Clo-Cli);
    Ito2_local = Ito2_local/Acap;	% divide by uF(Acap) to get current normalized to surface area
else 
    ICa_fac   =ICa_numerator*exp_2VFRT- OCa_numerator*Cao*0.341; 
    ICa_local = PCa*4.0*VFsq_over_RT*ICa_fac/(exp_2VFRT-1.0); 
    ICa_local = ICa_local/Acap;		% divide by uF(Acap) to get current normalized to surface area
    Ito2_local = NIto2_Open*PCl*VFsq_over_RT*(Cli-Clo*exp_VFRT)/(1.0 - exp_VFRT);
    Ito2_local = Ito2_local/Acap;	% divide by uF(Acap) to get current normalized to surface area
end

end

