function [INa,mNa, dmNa, dhNa, djNa] = calc_INa(V, ENa,mNa, hNa,jNa)

GNa=12.8;
if(mNa <= 0.0)
        mNa = 1e-15;
    end
INa = GNa*(mNa*mNa*mNa)*hNa*jNa*(V-ENa);

if(abs(V+47.13)<= 1.e-4)
    alpha_m = 0.32/(0.1 - 0.005*(V+47.13));
else
    a1 = 0.32*(V+47.13);
    alpha_m = a1/(1.0-exp(-0.1*(V+47.13)));
end
beta_m = 0.08*exp(-V/11.0);

if (V>=-90.0) 
    dmNa = alpha_m*(1.0-mNa)-beta_m*mNa;	
else
    dmNa = 0.0;
    mNa = alpha_m/(alpha_m + beta_m);
end

alpha_h = 0.135*exp((80+V)/-6.8);

if (V<-38.73809636838782) 
  % curves do not cross at -40mV, but close
  beta_h =3.56*exp(0.079*V)+310000*exp(0.35*V);
else 
  beta_h = 1/(0.13*(1+exp((V+10.66)/-11.1)));
end

if (V<-37.78) 
  a1 = -127140*exp(0.2444*V);
  a2 = 3.474E-5*exp(-0.04391*V);
  a3 = 1.0+exp(0.311*(V+79.23));
  alpha_j = (a1-a2)*(V+37.78)/a3;
else 
  alpha_j=0;
end

if (V<-39.82600037702883) 
  % curves do not cross at -40mV, but close
  beta_j = 0.1212*exp(-0.01052*V)/(1.0+exp(-0.1378*(V+40.14)));
else 
  beta_j = 0.3*exp(-2.535E-7*V)/(1+exp(-0.1*(V+32)));
end

dhNa = alpha_h*(1.0-hNa)-beta_h*hNa;	
djNa = alpha_j*(1.0-jNa)-beta_j*jNa;

end

