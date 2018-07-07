function [dCaCSR, Jtr_local, JRyRtot, NRyR_open1, NRyR_open2, NRyR_open3, NRyR_open4 ] = calc_dCaCSR(Cai, CaNSR, CaCSR, RyR11, RyR12, RyR13, RyR14, RyR15,...
                                     RyR21, RyR22, RyR23, RyR24, RyR25, RyR31, RyR32, RyR33, RyR34, RyR35, RyR41, RyR42,...
                                     RyR43, RyR44, RyR45)

CSQNtot= 13.5; 
KmCSQN=   0.63; 
JRyRmax= (0.6*1.5*1.1*3.96);
tautr= 3.0;
 
O1_RyR   = 2;
O2_RyR   = 4;
% O3_RyR   = 7;

% VCSR= 0.552252718592916e-9; % network SR volume (uL)

beta_CSR  = 1./( 1 + (CSQNtot.*KmCSQN)./(KmCSQN + CaCSR).^2);

NRyR_open1 = 0;
NRyR_open2 = 0;
NRyR_open3 = 0;
NRyR_open4 = 0;

 if(RyR11 == O1_RyR || RyR11 == O2_RyR) % || RyR11 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR12 == O1_RyR || RyR12 == O2_RyR) %|| RyR12 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR13 == O1_RyR || RyR13 == O2_RyR) %|| RyR13 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR14 == O1_RyR || RyR14 == O2_RyR) %|| RyR14 == O3_RyR) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 if(RyR15 == O1_RyR || RyR15 == O2_RyR) %|| RyR15 == O3_RyR ) 
   NRyR_open1 = NRyR_open1 + 1;
 end
 
  if(RyR21 == O1_RyR || RyR21 == O2_RyR) %|| RyR21 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR22 == O1_RyR || RyR22 == O2_RyR) %|| RyR22 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR23 == O1_RyR || RyR23 == O2_RyR) %|| RyR23 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR24 == O1_RyR || RyR24 == O2_RyR) %|| RyR24 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 if(RyR25 == O1_RyR || RyR25 == O2_RyR) %|| RyR25 == O3_RyR) 
   NRyR_open2 = NRyR_open2 + 1;
 end
 
  if(RyR31 == O1_RyR || RyR31 == O2_RyR) %|| RyR31 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR32 == O1_RyR || RyR32 == O2_RyR) %|| RyR32 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR33 == O1_RyR || RyR33 == O2_RyR) %|| RyR33 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR34 == O1_RyR || RyR34 == O2_RyR) %|| RyR34 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 if(RyR35 == O1_RyR || RyR35 == O2_RyR) %|| RyR35 == O3_RyR) 
   NRyR_open3 = NRyR_open3 + 1;
 end
 
  if(RyR41 == O1_RyR || RyR41 == O2_RyR) %|| RyR41 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR42 == O1_RyR || RyR42 == O2_RyR) %|| RyR42 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR43 == O1_RyR || RyR43 == O2_RyR) %|| RyR43 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR44 == O1_RyR || RyR44 == O2_RyR) %|| RyR44 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 if(RyR45 == O1_RyR || RyR45 == O2_RyR) %|| RyR45 == O3_RyR) 
   NRyR_open4 = NRyR_open4 + 1;
 end
 
 
Jtr_local = (CaNSR - CaCSR)./tautr;

JRyR_1 = JRyRmax*NRyR_open1.*(CaCSR-Cai);
JRyR_2 = JRyRmax*NRyR_open2.*(CaCSR-Cai);
JRyR_3 = JRyRmax*NRyR_open3.*(CaCSR-Cai);
JRyR_4 = JRyRmax*NRyR_open4.*(CaCSR-Cai);
JRyRtot = JRyR_1+JRyR_2+JRyR_3+JRyR_4; 

dCaCSR = beta_CSR.*(Jtr_local - JRyRtot); 
end

