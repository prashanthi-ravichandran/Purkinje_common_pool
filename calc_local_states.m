function [CaSS1, CaSS2, CaSS3, CaSS4] = calc_local_states(V,Cai,CaJSR, LCC1,LCC2, LCC3,LCC4,Y1, Y2, Y3, Y4,RyR11, RyR12, RyR13, RyR14, RyR15,...
                                                         RyR21, RyR22, RyR23, RyR24, RyR25, RyR31, RyR32, RyR33, RyR34, RyR35, RyR41, RyR42, RyR43, RyR44, RyR45)


O1_RyR   = 3;
O2_RyR   = 4;
O3_RyR   = 7;
O1_LType = 6;
O2_LType = 12;
Oy_LType = 2;
    
Cao = 2.0;
Faraday=  96.5;     % Faraday's constant (C/mmol)
Temp=    310.0;     % absolute temperature (K)
Rgas=      8.314;   % ideal gas constant (J/(mol*K))
RT_over_F= (Rgas*Temp/Faraday); %  Rgas*Temp/Faraday (mV)


VSS= (0.5*0.2*2.03e-12); % subspace volume (uL)
  
PCa= 2*(1.5/2.8*0.2*0.9*0.9468e-11); %(cm/s) *uF  
JDHconstant=1.0/(2.0*VSS*Faraday*1000.0);
% JSR to subspace through a single RyR (1/ms)
JRyRmax= (0.6*1.5*1.1*3.96);
% NSR to JSR (1/ms)
tautr= 3.0;
% subspace to cytosol (1/ms)
tauxfer= 0.005;
% intersubspace transfer rate (1/ms)
tauss2ss= (10.0*0.005);
NRyR_open1 = 0;
NRyR_open2 = 0;
NRyR_open3 = 0;
NRyR_open4 = 0;
% CaRU 1
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
%CaRU 2
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

% CaRU 3
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

% CaRU 4
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


VF_over_RT=V/RT_over_F;
VFsq_over_RT=(1000.0*Faraday)*VF_over_RT;
exp_VFRT = exp(2.0*VF_over_RT);

LType_open1 = 0;
LType_open2 = 0;
LType_open3 = 0;
LType_open4 = 0;

if((LCC1 == O1_LType ||LCC1== O2_LType) && (Y1 == Oy_LType))        
    LType_open1 = 1;
end

if((LCC2 == O1_LType ||LCC2== O2_LType) && (Y2 == Oy_LType))        
    LType_open2 = 1;
end

if((LCC3 == O1_LType ||LCC3== O2_LType) && (Y3 == Oy_LType))        
    LType_open3 = 1;
end

if((LCC4 == O1_LType ||LCC4== O2_LType) && (Y4 == Oy_LType))        
    LType_open4 = 1;
end


if (abs(V)<1.e-6) 
    
  Q1 = (1/tauxfer) + (PCa*2.0*1000.0*Faraday*LType_open1*JDHconstant)+ (JRyRmax*NRyR_open1) + (2/tauss2ss);
  Q2 = (1/tauxfer) + (PCa*2.0*1000.0*Faraday*LType_open2*JDHconstant)+ (JRyRmax*NRyR_open2) + (2/tauss2ss);
  Q3 = (1/tauxfer) + (PCa*2.0*1000.0*Faraday*LType_open3*JDHconstant)+ (JRyRmax*NRyR_open3) + (2/tauss2ss);
  Q4 = (1/tauxfer) + (PCa*2.0*1000.0*Faraday*LType_open4*JDHconstant)+ (JRyRmax*NRyR_open4) + (2/tauss2ss);
  R = 1/tauss2ss;
  S1 = (PCa*2.0*1000.0*Faraday*Cao*0.341*LType_open1*JDHconstant) + (JRyRmax*NRyR_open1*CaJSR) + (Cai/tauxfer);
  S2 = (PCa*2.0*1000.0*Faraday*Cao*0.341*LType_open2*JDHconstant) + (JRyRmax*NRyR_open2*CaJSR) + (Cai/tauxfer);  
  S3 = (PCa*2.0*1000.0*Faraday*Cao*0.341*LType_open3*JDHconstant) + (JRyRmax*NRyR_open3*CaJSR) + (Cai/tauxfer); 
  S4 = (PCa*2.0*1000.0*Faraday*Cao*0.341*LType_open4*JDHconstant) + (JRyRmax*NRyR_open4*CaJSR) + (Cai/tauxfer); 
  
else 
  a2 = PCa*4.0*VFsq_over_RT/(exp_VFRT-1.0)*JDHconstant;

  Q1 = (1/tauxfer) + (a2*LType_open1*exp_VFRT)+ (JRyRmax*NRyR_open1) + (2/tauss2ss);
  Q2 = (1/tauxfer) + (a2*LType_open2*exp_VFRT)+ (JRyRmax*NRyR_open2) + (2/tauss2ss);
  Q3 = (1/tauxfer) + (a2*LType_open3*exp_VFRT)+ (JRyRmax*NRyR_open3) + (2/tauss2ss);
  Q4 = (1/tauxfer) + (a2*LType_open4*exp_VFRT)+ (JRyRmax*NRyR_open4) + (2/tauss2ss);
  R = 1/tauss2ss;
  S1 = (a2*Cao*0.341*LType_open1) + (JRyRmax*NRyR_open1*CaJSR) + (Cai/tauxfer);
  S2 = (a2*Cao*0.341*LType_open2) + (JRyRmax*NRyR_open2*CaJSR) + (Cai/tauxfer);  
  S3 = (a2*Cao*0.341*LType_open3) + (JRyRmax*NRyR_open3*CaJSR) + (Cai/tauxfer); 
  S4 = (a2*Cao*0.341*LType_open4) + (JRyRmax*NRyR_open4*CaJSR) + (Cai/tauxfer); 
  
end

   det = -R^2*(Q1*Q2 + Q2*Q3 + Q1*Q4 + Q3*Q4) + Q1*Q2*Q3*Q4;
   
   CaSS1 = (1/det)*((S4*Q2*Q3*R) + (S2*Q4*Q3*R) + S1*((-Q2*R^2) - (Q4*R^2) + (Q2*Q3*Q4)) + S3*(Q2*R^2 + Q4*R^2));
   CaSS2 = (1/det)*((S3*Q1*Q4*R) + (S1*Q4*Q3*R) + S2*((-Q1*R^2) - (Q3*R^2) + (Q1*Q3*Q4)) + S4*(Q1*R^2 + Q3*R^2));
   CaSS3 = (1/det)*((S4*Q1*Q2*R) + (S2*Q4*Q1*R) + S3*((-Q2*R^2) - (Q4*R^2) + (Q1*Q2*Q4)) + S1*(Q2*R^2 + Q4*R^2));
   CaSS4 = (1/det)*((S3*Q2*Q1*R) + (S1*Q2*Q3*R) + S4*((-Q1*R^2) - (Q3*R^2) + (Q2*Q3*Q1)) + S2*(Q1*R^2 + Q3*R^2));
   
end

