function [IKv43,dC0Kv43,dC1Kv43,dC2Kv43,dC3Kv43,dOKv43,dCI0Kv43,dCI1Kv43,dCI2Kv43,dCI3Kv43,dOIKv43 ] = Calc_IKv43(V,EK,C0Kv43,C1Kv43,C2Kv43,C3Kv43,OKv43,CI0Kv43,CI1Kv43,CI2Kv43,CI3Kv43,OIKv43)

KvScale=1.13*1.03*1.55; % Scale factor for Kv4.3 and Kv1.4 currents
Kv43Frac=0.77; % Fraction of Ito1 which is Kv4.3 current
GKv43=Kv43Frac*KvScale*0.1;  % Maximum conductance of Kv4.3 channel (mS/uF)
 %Kv43 transition rates and parameters
alphaa0Kv43		= 0.543708;
aaKv43			= 0.028983;
betaa0Kv43		= 0.080185;
baKv43			= 0.0468437;
alphai0Kv43		= 0.0498424;
aiKv43			= 0.000373016;
betai0Kv43		= 0.000819482;
biKv43			= 0.00000005374;
f1Kv43			= 1.8936;
f2Kv43			= 14.224647456;
f3Kv43			= 158.574378389;
f4Kv43			= 142.936645351;
b1Kv43			= 6.77348;
b2Kv43			= 15.6212705152;
b3Kv43			= 28.7532603313;
b4Kv43			= 524.576206679;

IKv43 = GKv43*OKv43*(V-EK);

  % Compute derivatives of Kv4.3 channel
alpha_act43		    = alphaa0Kv43*exp(aaKv43*V);
beta_act43			= betaa0Kv43*exp(-baKv43*V);
alpha_inact43		= alphai0Kv43*exp(-aiKv43*V);
beta_inact43			= betai0Kv43*exp(biKv43*V);

C0Kv43_to_C1Kv43		= 4.0*alpha_act43;
C1Kv43_to_C2Kv43		= 3.0*alpha_act43;
C2Kv43_to_C3Kv43		= 2.0*alpha_act43;
C3Kv43_to_OKv43		= alpha_act43;

CI0Kv43_to_CI1Kv43	= 4.0*b1Kv43*alpha_act43;
CI1Kv43_to_CI2Kv43	= 3.0*b2Kv43*alpha_act43/b1Kv43;
CI2Kv43_to_CI3Kv43	= 2.0*b3Kv43*alpha_act43/b2Kv43;
CI3Kv43_to_OIKv43	= b4Kv43*alpha_act43/b3Kv43;

C1Kv43_to_C0Kv43		= beta_act43;
C2Kv43_to_C1Kv43		= 2.0*beta_act43;
C3Kv43_to_C2Kv43		= 3.0*beta_act43;
OKv43_to_C3Kv43		= 4.0*beta_act43;

CI1Kv43_to_CI0Kv43	= beta_act43/f1Kv43;
CI2Kv43_to_CI1Kv43	= 2.0*f1Kv43*beta_act43/f2Kv43;
CI3Kv43_to_CI2Kv43	= 3.0*f2Kv43*beta_act43/f3Kv43;
OIKv43_to_CI3Kv43	= 4.0*f3Kv43*beta_act43/f4Kv43;

C0Kv43_to_CI0Kv43	= beta_inact43;
C1Kv43_to_CI1Kv43	= f1Kv43*beta_inact43;
C2Kv43_to_CI2Kv43	= f2Kv43*beta_inact43;
C3Kv43_to_CI3Kv43	= f3Kv43*beta_inact43;
OKv43_to_OIKv43		= f4Kv43*beta_inact43;

CI0Kv43_to_C0Kv43	= alpha_inact43;
CI1Kv43_to_C1Kv43	= alpha_inact43/b1Kv43;
CI2Kv43_to_C2Kv43	= alpha_inact43/b2Kv43;
CI3Kv43_to_C3Kv43	= alpha_inact43/b3Kv43;
OIKv43_to_OKv43		= alpha_inact43/b4Kv43;


a1					= (C0Kv43_to_C1Kv43+C0Kv43_to_CI0Kv43)*C0Kv43;
a2					= C1Kv43_to_C0Kv43*C1Kv43 + CI0Kv43_to_C0Kv43*CI0Kv43;
dC0Kv43				= a2 - a1;
a1					= (C1Kv43_to_C2Kv43+C1Kv43_to_C0Kv43+C1Kv43_to_CI1Kv43)*C1Kv43;
a2					= C2Kv43_to_C1Kv43*C2Kv43 + CI1Kv43_to_C1Kv43*CI1Kv43 + C0Kv43_to_C1Kv43*C0Kv43;
dC1Kv43				= a2 - a1;
a1					= (C2Kv43_to_C3Kv43+C2Kv43_to_C1Kv43+C2Kv43_to_CI2Kv43)*C2Kv43;
a2					= C3Kv43_to_C2Kv43*C3Kv43 + CI2Kv43_to_C2Kv43*CI2Kv43 + C1Kv43_to_C2Kv43*C1Kv43;
dC2Kv43				= a2 - a1;
a1					= (C3Kv43_to_OKv43+C3Kv43_to_C2Kv43+C3Kv43_to_CI3Kv43)*C3Kv43;
a2					= OKv43_to_C3Kv43*OKv43 + CI3Kv43_to_C3Kv43*CI3Kv43 + C2Kv43_to_C3Kv43*C2Kv43;
dC3Kv43				= a2 - a1;
a1					= (OKv43_to_C3Kv43+OKv43_to_OIKv43)*OKv43;
a2					= C3Kv43_to_OKv43*C3Kv43 + OIKv43_to_OKv43*OIKv43;
dOKv43				= a2 - a1;
a1					= (CI0Kv43_to_C0Kv43+CI0Kv43_to_CI1Kv43)*CI0Kv43;
a2					= C0Kv43_to_CI0Kv43*C0Kv43 + CI1Kv43_to_CI0Kv43*CI1Kv43;
dCI0Kv43				= a2 - a1;
a1					= (CI1Kv43_to_CI2Kv43+CI1Kv43_to_C1Kv43+CI1Kv43_to_CI0Kv43)*CI1Kv43;
a2					= CI2Kv43_to_CI1Kv43*CI2Kv43 + C1Kv43_to_CI1Kv43*C1Kv43 + CI0Kv43_to_CI1Kv43*CI0Kv43;
dCI1Kv43				= a2 - a1;
a1					= (CI2Kv43_to_CI3Kv43+CI2Kv43_to_C2Kv43+CI2Kv43_to_CI1Kv43)*CI2Kv43;
a2					= CI3Kv43_to_CI2Kv43*CI3Kv43 + C2Kv43_to_CI2Kv43*C2Kv43 + CI1Kv43_to_CI2Kv43*CI1Kv43;
dCI2Kv43				= a2 - a1;
a1					= (CI3Kv43_to_OIKv43+CI3Kv43_to_C3Kv43+CI3Kv43_to_CI2Kv43)*CI3Kv43;
a2					= OIKv43_to_CI3Kv43*OIKv43 + C3Kv43_to_CI3Kv43*C3Kv43 + CI2Kv43_to_CI3Kv43*CI2Kv43;
dCI3Kv43				= a2 - a1;
a1					= (OIKv43_to_OKv43+OIKv43_to_CI3Kv43)*OIKv43;
a2					= OKv43_to_OIKv43*OKv43 + CI3Kv43_to_OIKv43*CI3Kv43;
dOIKv43				= a2 - a1;
end

