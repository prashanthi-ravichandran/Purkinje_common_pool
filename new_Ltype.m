function [ LCC, Y, Ito2] = new_Ltype( dt,V,CaSS, LCC, Y, Ito2, rand1, rand2, rand3)

 fL=0.85; % transition	rate into open state (1/ms)
 gL=2.0; %	transition rate	out	of open	state (1/ms)
 fLprime=0.005;	% transition rate into	Ca mode	open state (1/ms)
 gLprime=7.0; % transition	rate out of	Ca mode	open state (1/ms)
 bL=1.9356;	% mode	transition parameter
 bL2=bL*bL;
 bL3=bL*bL*bL;
 bL4=bL*bL*bL*bL;
 aL=2.0; %	mode transition	parameter
 aL2=aL*aL;
 aL3=aL*aL*aL;
 aL4=aL*aL*aL*aL;
 omega=0.83*2.0*1.3*0.01;  % mode transition parameter	(1/ms)

 alphacf=4.0*1.2*0.416;
 betacf=4.0*0.45*0.049;
 gammacf=0.83*1.9*1.3*0.31*7.5*0.09233;	% (ms-1 mM-1)
 
 CCa0_to_C0	= omega;		% = omega
 CCa1_to_C1	= omega/bL;	    % = omega/bL
 CCa2_to_C2	= omega/bL2;	% = omega/bL^2
 CCa3_to_C3	= omega/bL3;	% = omega/bL^3
 CCa4_to_C4	= omega/bL4;	% = omega/bL^4
 
 yCa_frac=0.4;
 
 alpha =	alphacf	* exp(0.012*(V-35.0));
 beta = betacf *	exp(-0.05*(V-35.0));
 alpha_prime	= aL*alpha;
 beta_prime = beta/bL;
 
 gamma_rate = gammacf*CaSS;
 
 if(LCC == 1)
    C0_to_C1 = 4.0*alpha;
	C0_to_CCa0 = gamma_rate;        
    Accum_Prob = 1.0 - dt*(C0_to_C1+C0_to_CCa0);
    if (rand1 > Accum_Prob) 
        LCC = 2;
        Accum_Prob = Accum_Prob + dt*C0_to_C1;
        if(rand1 > Accum_Prob)
            LCC = 7;
        end
    end
 else
     if(LCC == 2)
        C1_to_C2 = 3.0*alpha;
	    C1_to_C0 =		beta;
	    C1_to_CCa1 = aL*gamma_rate;	% = gamma_rate*aL
		Accum_Prob = 1.0 - dt*(C1_to_C0+C1_to_C2+C1_to_CCa1);
		if (rand1 > Accum_Prob) 
            LCC = 1;
            Accum_Prob = Accum_Prob + dt*C1_to_C0;
            if(rand1 > Accum_Prob)
                LCC = 3;
                Accum_Prob = Accum_Prob + dt*C1_to_C2;
                if(rand1 > Accum_Prob)
                    LCC = 8;
                end
            end
        end   
     else
         if(LCC == 3)
            C2_to_C1 = 2.0*beta;
            C2_to_C3 = 2.0*alpha;
            C2_to_CCa2 = aL2*gamma_rate;
            Accum_Prob = 1.0 - dt*(C2_to_C1+C2_to_C3+C2_to_CCa2);
            if (rand1>Accum_Prob) 
                LCC = 2;
                Accum_Prob = Accum_Prob + dt*C2_to_C1;
                if(rand1> Accum_Prob)
                    LCC = 4;
                    Accum_Prob = Accum_Prob + dt*C2_to_C3;
                    if(rand1> Accum_Prob)
                        LCC = 9;
                    end
                end
            end
         else
             if(LCC ==4)
                C3_to_C4 =		alpha;
                C3_to_C2 = 3.0*beta;
                C3_to_CCa3 = aL3*gamma_rate;
                Accum_Prob = 1.0 - dt*(C3_to_C2+C3_to_C4+C3_to_CCa3);
                if (rand1>Accum_Prob) 
                    LCC = 3;
                    Accum_Prob = Accum_Prob + dt*C3_to_C2;
                    if(rand1 > Accum_Prob)
                        LCC = 5;
                        Accum_Prob = Accum_Prob + dt*C3_to_C4;
                        if(rand1 > Accum_Prob)
                            LCC = 10;
                        end
                    end
                end
             else
                 if(LCC ==5)
                    C4_to_C3 = 4.0*beta;
                    C4_to_CCa4 = aL4*gamma_rate;
                    Accum_Prob = 1.0 - dt*(C4_to_C3+fL+C4_to_CCa4);
                    if (rand1>Accum_Prob) 
                        LCC = 4;
                        Accum_Prob = Accum_Prob + dt*C4_to_C3;
                        if(rand1 > Accum_Prob)
                            LCC = 6;
                            Accum_Prob = Accum_Prob + dt*fL;
                            if(rand1 > Accum_Prob)
                                LCC = 11;
                            end
                        end
                    end
                 else
                     if(LCC == 6)
                        Accum_Prob = 1.0 - dt*gL;
                        if (rand1>Accum_Prob) 
                            LCC = 5;
                        end
                     else
                         if(LCC == 7)
                            CCa0_to_CCa1 = 4.0*alpha_prime;  
                            Accum_Prob = 1.0 - dt*(CCa0_to_CCa1+CCa0_to_C0);
                            if (rand1>Accum_Prob) 
                                LCC = 1;
                                Accum_Prob = Accum_Prob + dt*CCa0_to_C0;
                                if(rand1 > Accum_Prob)
                                    LCC = 8;
                                end
                            end
                         else
                             if(LCC == 8)
                                CCa1_to_CCa2 = 3.0*alpha_prime;
                                CCa1_to_CCa0 =		beta_prime;
                                Accum_Prob = 1.0 - dt*(CCa1_to_CCa0+CCa1_to_CCa2+CCa1_to_C1);
                                if (rand1>Accum_Prob) 
                                    LCC = 7;
                                    Accum_Prob = Accum_Prob + dt*CCa1_to_CCa0;
                                    if(rand1 > Accum_Prob)
                                        LCC = 2;
                                        Accum_Prob = Accum_Prob + dt*CCa1_to_C1;
                                        if(rand1 > Accum_Prob)
                                            LCC = 9;
                                        end
                                    end
                                end
                             else
                                 if(LCC == 9)
                                        CCa2_to_CCa3 = 2.0*alpha_prime;
                                        CCa2_to_CCa1 = 2.0*beta_prime;
                                        Accum_Prob = 1.0 - dt*(CCa2_to_CCa1+CCa2_to_CCa3+CCa2_to_C2);
                                        if (rand1>Accum_Prob) 
                                            LCC = 8;
                                            Accum_Prob = Accum_Prob + dt*CCa2_to_CCa1;
                                            if(rand1>Accum_Prob)
                                                LCC = 3;
                                                Accum_Prob = Accum_Prob + dt*CCa2_to_C2;
                                                if(rand1>Accum_Prob)
                                                    LCC = 10;
                                                end
                                            end
                                        end
                                 else
                                     if(LCC == 10)
                                        CCa3_to_CCa4 =		alpha_prime;
                                        CCa3_to_CCa2 = 3.0*beta_prime;      
                                        Accum_Prob = 1.0 - dt*(CCa3_to_CCa2+CCa3_to_CCa4+CCa3_to_C3);
                                        if (rand1>Accum_Prob) 
                                            LCC = 9;
                                            Accum_Prob = Accum_Prob + dt*CCa3_to_CCa2;
                                            if(rand1>Accum_Prob)
                                                LCC = 4;
                                                Accum_Prob = Accum_Prob + dt*CCa3_to_C3;
                                                if(rand1>Accum_Prob)
                                                    LCC = 11;
                                                end
                                            end
                                        end
                                     else
                                         if(LCC == 11)
                                                CCa4_to_CCa3 = 4.0*beta_prime;     
                                                Accum_Prob = 1.0 - dt*(CCa4_to_CCa3+CCa4_to_C4+fLprime);
                                                if (rand1>Accum_Prob) 
                                                    LCC = 10; 
                                                    Accum_Prob = Accum_Prob + dt*CCa4_to_CCa3;
                                                    if(rand1 > Accum_Prob)
                                                        LCC = 5;
                                                        Accum_Prob = Accum_Prob + dt*CCa4_to_C4;
                                                        if(rand1 > Accum_Prob)
                                                            LCC = 12;
                                                        end
                                                    end
                                                end
                                         else
                                             if(LCC == 12)
                                                    Accum_Prob = 1.0 - dt*gLprime ;
                                                    if (rand1>Accum_Prob) 
                                                        LCC = 11;
                                                    end
                                             end
                                         end
                                     end
                                 end
                             end
                         end
                     end
                 end
             end
         end
     end
 end
                                                 
% Determine the transitions for the voltage inactivated L-type channel

Oy_LType = 2;
yCa_inf	= yCa_frac/(1.0+exp((V + 12.5)/5.0)) + (1.0- yCa_frac);
tau_yCa	= 60.0 + 340.0/(1.0	+ exp((V+30.0)/12.0));

if(Y == Oy_LType)
    exitrate_Y = (1.0-yCa_inf)/tau_yCa;
else
    exitrate_Y = yCa_inf/tau_yCa;
end

exitprob_Y = 1.0 - dt*exitrate_Y;
if(rand2 >= exitprob_Y)
    Y = 3 -  Y;
end

% Determine if Ito2 undergoes a transition

C_Ito2 = 1;

KdIto2=0.1502;	 %	(mM)
kbIto2=2.0;  % (ms-1)
kfIto2=kbIto2/KdIto2;	% (ms-1 mM-1)

if(Ito2 == C_Ito2)
    exitrate = kfIto2*CaSS;
else
    exitrate = kbIto2;
end

exitprob =1.0 - dt*exitrate;
if(rand3 >= exitprob)
    Ito2 = 3 - Ito2;
end
    
end

