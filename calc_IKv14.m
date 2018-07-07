function [IKv14,IKv14_Na, IKv14_K,dC0Kv14,dC1Kv14,dC2Kv14,dC3Kv14,dOKv14,dCI0Kv14,dCI1Kv14,dCI2Kv14,dCI3Kv14,dOIKv14] = calc_IKv14(V,Nai,Ki,C0Kv14,C1Kv14,C2Kv14,C3Kv14,...
                                                                                                                        OKv14,CI0Kv14,CI1Kv14,CI2Kv14,CI3Kv14,OIKv14)
Ko=    4.0;   % extracellular K+   concentration (mM)
Nao= 138.0;   % extracellular Na+  concentration (mM)

Faraday=  96.5;     % Faraday's constant (C/mmol)
Temp=    310.0;     % absolute temperature (K)
Rgas=      8.314;   % ideal gas constant (J/(mol*K))
RT_over_F= (Rgas*Temp/Faraday); %  Rgas*Temp/Faraday (mV)

KvScale=1.13*1.03*1.55; % Scale factor for Kv4.3 and Kv1.4 currents
Kv14Frac=0.77; % Fraction of Ito1 which is Kv4.3 current
PKv14=(1.0-Kv14Frac)*KvScale*4.792933e-7; % Permeability of Kv1.4 channel (cm/s)

%Kv14 transition rates and parameters
alphaa0Kv14		= 1.84002414554;
aaKv14			= 0.00768548031;
betaa0Kv14		= 0.01081748340;
baKv14			= 0.07793378174;
alphai0Kv14		= 0.00305767916;
betai0Kv14		= 0.00000244936;
f1Kv14			= 0.52465073996;
f2Kv14			= 17.51885408639;
f3Kv14			= 938.58764534556;
f4Kv14			= 54749.19473332601;
b1Kv14			= 1.00947847105;
b2Kv14			= 1.17100540567;
b3Kv14			= 0.63902768758;
b4Kv14			= 2.12035379095;


VF_over_RT=V/RT_over_F;
VFsq_over_RT=(1000.0*Faraday)*VF_over_RT;
exp_VFRT=exp(VF_over_RT);

a1 =  Ki*exp_VFRT-Ko;
a2 = exp_VFRT-1.0;

if (abs(V)<1.e-6) 
    IKv14_K = PKv14*OKv14*1000.0*Faraday*(Ki-Ko);
else 
    IKv14_K = PKv14*OKv14*VFsq_over_RT*(a1/a2);
end

a1 =  Nai*exp_VFRT-Nao;

if (abs(V)<1.e-6) 
    IKv14_Na = 0.02*PKv14*OKv14*1000.0*Faraday*(Nai-Nao);
else 
    IKv14_Na = 0.02*PKv14*OKv14*VFsq_over_RT*(a1/a2);
end 

IKv14 = IKv14_K + IKv14_Na;
    
%Kv1.4 channel transitions
alpha_act14			= alphaa0Kv14*exp(aaKv14*V);
beta_act14			= betaa0Kv14*exp(-baKv14*V);
alpha_inact14		= alphai0Kv14;
beta_inact14			= betai0Kv14;

C0Kv14_to_C1Kv14		= 4.0*alpha_act14;
C1Kv14_to_C2Kv14		= 3.0*alpha_act14;
C2Kv14_to_C3Kv14		= 2.0*alpha_act14;
C3Kv14_to_OKv14		= alpha_act14;

CI0Kv14_to_CI1Kv14	= 4.0*b1Kv14*alpha_act14;
CI1Kv14_to_CI2Kv14	= 3.0*b2Kv14*alpha_act14/b1Kv14;
CI2Kv14_to_CI3Kv14	= 2.0*b3Kv14*alpha_act14/b2Kv14;
CI3Kv14_to_OIKv14	= b4Kv14*alpha_act14/b3Kv14;

C1Kv14_to_C0Kv14		= beta_act14;
C2Kv14_to_C1Kv14		= 2.0*beta_act14;
C3Kv14_to_C2Kv14		= 3.0*beta_act14;
OKv14_to_C3Kv14		= 4.0*beta_act14;

CI1Kv14_to_CI0Kv14	= beta_act14/f1Kv14;
CI2Kv14_to_CI1Kv14	= 2.0*f1Kv14*beta_act14/f2Kv14;
CI3Kv14_to_CI2Kv14	= 3.0*f2Kv14*beta_act14/f3Kv14;
OIKv14_to_CI3Kv14	= 4.0*f3Kv14*beta_act14/f4Kv14;

C0Kv14_to_CI0Kv14	= beta_inact14;
C1Kv14_to_CI1Kv14	= f1Kv14*beta_inact14;
C2Kv14_to_CI2Kv14	= f2Kv14*beta_inact14;
C3Kv14_to_CI3Kv14	= f3Kv14*beta_inact14;
OKv14_to_OIKv14		= f4Kv14*beta_inact14;

CI0Kv14_to_C0Kv14	= alpha_inact14;
CI1Kv14_to_C1Kv14	= alpha_inact14/b1Kv14;
CI2Kv14_to_C2Kv14	= alpha_inact14/b2Kv14;
CI3Kv14_to_C3Kv14	= alpha_inact14/b3Kv14;
OIKv14_to_OKv14		= alpha_inact14/b4Kv14;

a1					= (C0Kv14_to_C1Kv14+C0Kv14_to_CI0Kv14)*C0Kv14;
a2					= C1Kv14_to_C0Kv14*C1Kv14 + CI0Kv14_to_C0Kv14*CI0Kv14;
dC0Kv14				= a2 - a1;
a1					= (C1Kv14_to_C2Kv14+C1Kv14_to_C0Kv14+C1Kv14_to_CI1Kv14)*C1Kv14;
a2					= C2Kv14_to_C1Kv14*C2Kv14 + CI1Kv14_to_C1Kv14*CI1Kv14 + C0Kv14_to_C1Kv14*C0Kv14;
dC1Kv14				= a2 - a1;
a1					= (C2Kv14_to_C3Kv14+C2Kv14_to_C1Kv14+C2Kv14_to_CI2Kv14)*C2Kv14;
a2					= C3Kv14_to_C2Kv14*C3Kv14 + CI2Kv14_to_C2Kv14*CI2Kv14 + C1Kv14_to_C2Kv14*C1Kv14;
dC2Kv14				= a2 - a1;
a1					= (C3Kv14_to_OKv14+C3Kv14_to_C2Kv14+C3Kv14_to_CI3Kv14)*C3Kv14;
a2					= OKv14_to_C3Kv14*OKv14 + CI3Kv14_to_C3Kv14*CI3Kv14 + C2Kv14_to_C3Kv14*C2Kv14;
dC3Kv14				= a2 - a1;
a1					= (OKv14_to_C3Kv14+OKv14_to_OIKv14)*OKv14;
a2					= C3Kv14_to_OKv14*C3Kv14 + OIKv14_to_OKv14*OIKv14;
dOKv14				= a2 - a1;
a1					= (CI0Kv14_to_C0Kv14+CI0Kv14_to_CI1Kv14)*CI0Kv14;
a2					= C0Kv14_to_CI0Kv14*C0Kv14 + CI1Kv14_to_CI0Kv14*CI1Kv14;
dCI0Kv14				= a2 - a1;
a1					= (CI1Kv14_to_CI2Kv14+CI1Kv14_to_C1Kv14+CI1Kv14_to_CI0Kv14)*CI1Kv14;
a2					= CI2Kv14_to_CI1Kv14*CI2Kv14 + C1Kv14_to_CI1Kv14*C1Kv14 + CI0Kv14_to_CI1Kv14*CI0Kv14;
dCI1Kv14				= a2 - a1;
a1					= (CI2Kv14_to_CI3Kv14+CI2Kv14_to_C2Kv14+CI2Kv14_to_CI1Kv14)*CI2Kv14;
a2					= CI3Kv14_to_CI2Kv14*CI3Kv14 + C2Kv14_to_CI2Kv14*C2Kv14 + CI1Kv14_to_CI2Kv14*CI1Kv14;
dCI2Kv14				= a2 - a1;
a1					= (CI3Kv14_to_OIKv14+CI3Kv14_to_C3Kv14+CI3Kv14_to_CI2Kv14)*CI3Kv14;
a2					= OIKv14_to_CI3Kv14*OIKv14 + C3Kv14_to_CI3Kv14*C3Kv14 + CI2Kv14_to_CI3Kv14*CI2Kv14;
dCI3Kv14				= a2 - a1;
a1					= (OIKv14_to_OKv14+OIKv14_to_CI3Kv14)*OIKv14;
a2					= OKv14_to_OIKv14*OKv14 + CI3Kv14_to_OIKv14*CI3Kv14;
dOIKv14				= a2 - a1;    
end

