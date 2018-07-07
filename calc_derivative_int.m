function [dCaiArray, dCaNSRArray,dCaCSR, dLTRPNCaArray, dHTRPNCaArray,dO1_RyR, dO2_RyR, dC1_RyR, dC2_RyR, JMyo_diff, JNSR_diff, Jup, Jtrpn]...
    = calc_derivative_int(CaiArray, CaNSRArray,CaCSR, LTRPNCaArray, HTRPNCaArray,subsarc_state,Jtr, Jxfer, Jtr_int, JRyR_int,...
      C1_RyR,C2_RyR, O1_RyR, O2_RyR)

global r Vmyo VNSR n_shells dr n_shells_ss VSS VJSR VCSRtot

KSR_factor = 1;
NCX_factor = 1;
% Physical constants
Faraday=  96.5;     % Faraday's constant (C/mmol)
Temp=    310.0;     % absolute temperature (K)
Rgas=      8.314;   % ideal gas constant (J/(mol*K))
RT_over_F= (Rgas*Temp/Faraday); %  Rgas*Temp/Faraday (mV)

% Cell geometry

Acap= 1.534e-4; % capacitive membrane area (cm^2)


% Buffering parameters
% total troponin low affinity site conc. (mM)
LTRPNtot= 70.0e-3;
% total troponin high affinity site conc. (mM)
HTRPNtot= 140.0e-3;
% Ca++ on rate for troponin high affinity sites (1/(mM*ms))
khtrpn_plus= 20.0;
% Ca++ off rate for troponin high affinity sites (1/ms)
khtrpn_minus= 0.066e-3;
% Ca++ on rate for troponin low affinity sites (1/(mM*ms))
kltrpn_plus= 40.0;
% Ca++ off rate for troponin low affinity sites (1/ms)
kltrpn_minus= 40.0e-3;
% total myoplasmic calmodulin concentration (mM)
CMDNtot= 50.0e-3;
% total myoplasmic EGTA concentration (mM)
EGTAtot= 0.0;
% Ca++ half sat. constant for calmodulin (mM)
KmCMDN= 2.38e-3;
% Ca++ half sat. constant for EGTA (mM)
KmEGTA= 1.5e-4;


% SR parameters
Kfb=0.26e-3; % foward half sat. constant for Ca++ ATPase (mM)
Krb=1.8; % backward half sat. constant for Ca++ ATPase (mM)
KSR=1.0; % scaling factor for Ca++ ATPase
Nfb=0.75; % foward cooperativity constant for Ca++ ATPase
Nrb=0.75; % backward cooperativity constant for Ca++ ATPase
vmaxf=1.53*137.0e-6; % Ca++ ATPase forward rate parameter (mM/ms)
vmaxr=1.53*137.0e-6; % Ca++ ATPase backward rate parameter (mM/ms)
 
fb = power(CaiArray./Kfb,Nfb);
rb = power(CaNSRArray./Krb,Nrb);
Jup = (KSR_factor*KSR).*(vmaxf.*fb - vmaxr.*rb)./(1.0 + fb + rb); 

if(~isreal(Jup))
    pause;
end
% Calculate diffusive fluxes
% alpha_myo = 0.002*diff_factor;
% alpha_NSR = 0.002*diff_factor;
alpha_myo = 0.7;
alpha_NSR = 0.7;
diff_flag = 1;

 if(diff_flag)
  for s = 1: n_shells
    radius = (r(s) + r(s+1)) / 2;
    if(s == 1)
        JMyo_diff(s) = (alpha_myo / (radius* dr* dr))* ( r(s)*( CaiArray(s+1) - CaiArray(s)));
        JNSR_diff(s) = (alpha_NSR / (radius* dr* dr))* ( r(s)*( CaNSRArray(s+1) - CaNSRArray(s)));
    else
        if( s == n_shells)
            JMyo_diff(s) = -(alpha_myo / (radius* dr* dr))* ( r(s -1)*( CaiArray(s) - CaiArray(s -1)));
            JNSR_diff(s) = -(alpha_NSR / (radius* dr* dr))* ( r(s -1)*( CaNSRArray(s) - CaNSRArray(s-1)));
        else
            JMyo_diff(s) = (alpha_myo / (radius* dr* dr))* ( (r(s)*( CaiArray(s+1) - CaiArray(s))) - (r(s -1)*( CaiArray(s) - CaiArray(s -1))));
            JNSR_diff(s) = (alpha_NSR / (radius* dr* dr))* ( (r(s)*( CaNSRArray(s+1) - CaNSRArray(s))) - (r(s -1)*( CaNSRArray(s) - CaNSRArray(s-1))));
        end
    end
  end
 else
     JMyo_diff = zeros(1, n_shells);
     JNSR_diff = zeros(1, n_shells);
 end

a1 = kltrpn_minus.*LTRPNCaArray;
dLTRPNCaArray = kltrpn_plus.*CaiArray.*(ones(1,n_shells) - LTRPNCaArray) - a1;

a1 = khtrpn_minus.*HTRPNCaArray;
dHTRPNCaArray = khtrpn_plus.*CaiArray.*(ones(1,n_shells) - HTRPNCaArray) - a1;
Jtrpn = LTRPNtot.*dLTRPNCaArray + HTRPNtot.*dHTRPNCaArray;

%Jtrpn = zeros(1,n_shells);    
a1 = (CMDNtot*KmCMDN.*ones(1,n_shells))./((CaiArray + KmCMDN.*ones(1,n_shells)).^2);
a2 = (EGTAtot*KmEGTA.*ones(1,n_shells))./((CaiArray +KmEGTA.*ones(1,n_shells)).^2);
beta_i = 1.0./(1.0+a1+a2);

% if(abs(sum(JNSR_diff)) > tol || abs(sum(JMyo_diff)) > tol)
%     disp('Error in diffusion');
% end
dCaiArray = zeros(1,n_shells);
dCaNSRArray = zeros(1, n_shells);

% Standard ionic concentrations
Nao= 138.0;   % extracellular Na+  concentration (mM)
Cao=   2.0;   % extracellular Ca++ concentration (mM)

kNaCa=0.9*0.30; 
KmNa=87.5;% Na+  half sat. constant for Na+/Ca++ exch. (mM)
KmCa=1.38;% Ca++ half sat. constant for Na+/Ca++ exch. (mM)
ksat=0.2;% Na+/Ca++ exch. sat. factor at negative potentials 
eta=0.35;% controls voltage dependence of Na+/Ca++ exch.

IpCamax=0.6*0.05; % maximum sarcolemmal Ca++ pump current (uA/uF)
KmpCa=0.0005; % half sat. constant for sarcolemmal Ca++ pump (mM)

% max. background Ca++ current conductance (mS/uF)
GCab=3.3*7.684e-5; % 3e-5 in stable C++

V = subsarc_state(1);
Nai = subsarc_state(2);
VF_over_RT=V/RT_over_F;
exp_VFRT=exp(VF_over_RT);

for s = 1:n_shells_ss
    if (CaiArray(s)<=0.0)
        CaiArray(s) = 1.e-15;
    end
    ECa = 0.5*RT_over_F*log(Cao/CaiArray(s));
    exp_etaVFRT=exp(eta*VF_over_RT);
    a1 = exp_etaVFRT*(Nai*Nai*Nai)*Cao;
    a2 = exp_etaVFRT/exp_VFRT*(Nao*Nao*Nao)*CaiArray(s);
    a3 = 1.0+(ksat)*exp_etaVFRT/exp_VFRT;
    a4 = KmCa+Cao;
    a5 = 5000.0/(KmNa*KmNa*KmNa+Nao*Nao*Nao);
    INaCa(s) = NCX_factor*kNaCa*a5*(a1-a2)/(a4*a3);
    ICab(s) = GCab*(V-ECa);
    IpCa(s) = IpCamax*CaiArray(s)/(KmpCa+CaiArray(s));
end

for s = 1:n_shells_ss
    a1 = Acap/(Vmyo(s)*Faraday*1000.0); 
    a3 = ICab(s) -2.0*INaCa(s) + IpCa(s);
	dCaiArray(s) = beta_i(s)*(Jxfer(s)*(VSS/Vmyo(s)) -Jup(s) -Jtrpn(s) - a3*0.5*a1) + JMyo_diff(s);
    dCaNSRArray(s) = Jup(s)*(Vmyo(s)/VNSR(s)) - Jtr(s)*(VJSR/VNSR(1)) + JNSR_diff(s);
end
for s = n_shells_ss+1:n_shells
        dCaiArray(s) = beta_i(s)*(-Jup(s) -Jtrpn(s) + JRyR_int(s-n_shells_ss)*(VCSRtot(s-n_shells_ss)/Vmyo(s))) + JMyo_diff(s);
        dCaNSRArray(s) = Jup(s)*(Vmyo(s)/VNSR(s))  - Jtr_int(s-n_shells_ss)*(VCSRtot(s-n_shells_ss)/VNSR(s)) + JNSR_diff(s);
end

        CSQNtot			= 13.5;
        KmCSQN			= 0.63;
        a1			= CSQNtot*KmCSQN./(((CaCSR+KmCSQN).^2.0));
	    beta_CSR	= 1.0./(1.0+a1);
        dCaCSR = beta_CSR.*(Jtr_int - JRyR_int);
        
%         n = 4;
%         m = 3; 
%         ka_minus = 0.0288*2;
%         kb_minus = 0.3859;
%         kc_plus = 0.0018*1.5;
%         kc_minus = 0.0001;  

        
%         ka_plus = 5*(CaiArray(n_shells_ss+1:n_shells).^n)*1e8;
%         kb_plus = 3*(CaiArray(n_shells_ss+1:n_shells).^m)*1e7;

        n = 4;
        m = 3; 
        ka_minus = 0.0288;
        kb_minus = 0.3859;
        kc_plus = 0.0018;
        kc_minus = 0.0001;  

        ka_plus = 1.5*(CaiArray(n_shells_ss+1:end).^n)*1e12;
        kb_plus = 1.5*(CaiArray(n_shells_ss+1:end).^m)*1e9;
      % The rates were for uM not mM

      dC1_RyR		= -ka_plus.*C1_RyR + ka_minus.*O1_RyR;
      dO2_RyR		=  kb_plus.*O1_RyR - kb_minus.*O2_RyR;
      dC2_RyR		=  kc_plus.*O1_RyR - kc_minus.*C2_RyR; 
      dO1_RyR		= -(dC1_RyR + dO2_RyR + dC2_RyR);
end


