function [ RyR ] = switch_RyR_int(dt,Cai,RyR, rand1, rand2, rand3)

k21=250.0;
k32=9.6;
k43=13.6493;
k45=0.07;
k52 = 0.00667;
k65=30.0; %	at 10 CaNSR	rises
k12cf=3000.0;
k23cf=10.0*30000.0;
k34cf=0.6*3000.0; %	(ms-1 mM-2)
k54cf=0.6*0.198;
k25cf=10.0*300.0;
k56cf=2.0*4.0*3000.0;
% parameters below	determine threshold	Ca levels for switching	between	different
% RyR models based	on rapid equilibrium approximations
k_rate=  0.00127215;	 
k_rate2= 3.4188;
threshCa34to7= 0.0368369379834969;	 %	Factor of 200 (0.005) difference in	rates 
threshCa56to8= 0.00011447933531005 ;

threshMAX=2.0;	
threshMAXCa = 0.0504410547074504; 
Sat_term = min(threshMAX,(Cai*Cai)/k_rate);
Sat_term2 =	min(threshMAX,(Cai*Cai)/k_rate2);


k12	= k12cf	* Sat_term2;
k23	= k23cf	* Sat_term;
k34	= k34cf	* Sat_term;
k54	= k54cf	* Sat_term;
k25	= k25cf	* Sat_term;
k56	= k56cf	* Sat_term;

if(min(Cai, threshMAXCa)<threshCa56to8)
    if(RyR == 1)
        trans = k12;
        if (rand1 < trans*dt) 
            RyR = 2;
        end
    else
         if(RyR == 2)
             trans = k21+k23+k25;
				if (rand1 < trans*dt) 
                    if(rand2 <= (k21/trans))
                        RyR = 1;
                    else
                        if(rand2 <= ((k21 + k23)/trans))
                            RyR = 3;
                        else
                            RyR = 5;
                        end
                    end
                end
        else
            if(RyR == 3)
                trans = (k32+k34);
				if (rand1 < trans*dt ) 
                    if(rand2 <= (k32/trans))
                        RyR = 2;
                    else
                        RyR = 4;
                    end
                end            
            else
                if(RyR == 4)
                    trans = (k43+k45);
                    if (rand1 < trans*dt)
                        if(rand2 <= k43/trans)
                            RyR = 3;
                        else
                            RyR = 5;
                        end
                    end                
                else
                    if(RyR == 5)
                        trans = (k52+k54+k56);
                        if (rand1 < trans*dt) 
                            if(rand2 <= k52/trans)
                                RyR = 2;
                            else
                                if(rand2 <= (k52 + k54)/trans)
                                    RyR = 4;
                                else
                                    RyR = 6;
                                end
                            end
                        end
                    else
                        if(RyR == 6)
                            trans = k65;
                            if (rand1 < trans*dt) 
                                RyR = 5;
                            end
                        else
                            if(RyR == 7)
                              if (rand3 < (k34/(k34+k43)) )           
                                RyR = 4;           
                                trans = (k43+k45);
                                if (rand1 < trans*dt)
                                    if(rand2 <= k43/trans)
                                        RyR = 3;
                                    else
                                        RyR = 5;
                                    end
                                end      
                              else 
                                  RyR = 3;
                                  trans = (k32+k34);
                                    if (rand1 < trans*dt ) 
                                        if(rand2 <= (k32/trans))
                                            RyR = 2;
                                        else
                                            RyR = 4;
                                        end
                                    end      
                              end
                            else
                                if(RyR == 8)
                                  if (rand3< k56/(k56+k65)) 
                                        RyR = 6;
                                        trans = k65;
                                        if (rand1 < trans*dt) 
                                            RyR = 5;
                                        end
                                  else
                                    RyR = 5;
                                    trans = (k52+k54+k56);
                                    if (rand1 < trans*dt) 
                                        if(rand2 <= k52/trans)
                                            RyR = 2;
                                        else
                                            if(rand2 <= (k52 + k54)/trans)
                                                RyR = 4;
                                            else
                                                RyR = 6;
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
    
else
    if(min(Cai,threshMAXCa)<threshCa34to7)
    if(RyR == 1)
        trans = k12;
        if (rand1 < trans*dt) 
            RyR = 2;
        end
    else
        if(RyR == 2)
            trans = k21+k23+k25;
            if (rand1 < trans*dt) 
                if(rand2 <= (k21/trans))
                    RyR = 1;
                else
                    if(rand2 <= ((k21 + k23)/trans))
                        RyR = 3;
                    else
                        RyR = 8;
                    end
                end
            end
        else
            if(RyR == 3)
                trans = (k32+k34);
				if (rand1 < trans*dt ) 
                    if(rand2 <= (k32/trans))
                        RyR = 2;
                    else
                        RyR = 4;
                    end
                end      
            else
                if(RyR == 4)
                    trans = (k43+k45);
                    if (rand1 < trans*dt) 
                        if(rand2 <= k43/trans)
                            RyR = 3;
                        else
                            RyR = 8;
                        end
                    end
                else
                    if(RyR == 5)
                          RyR = 8;
                          a1 = k65/(k56+k65);
                          a2 = a1*k52;
                          a3 = a1*k54;                          
                          trans = (a2+a3);
                          if (rand1 < trans*dt)
                            if(rand2 <= a2/trans)
                                RyR = 2;
                            else
                                RyR = 4;
                            end 
                          end
                    else
                        if(RyR == 6)
                            RyR = 8;
                            a1 = k65/(k56+k65);
                            a2 = a1*k52;
                            a3 = a1*k54;
                            trans = a2+a3;
                              if (rand1 < trans*dt)
                                if(rand2 <= a2/trans)
                                    RyR = 2;
                                else
                                    RyR = 8;
                                end
                              end
                        else
                            if(RyR == 7)
                                  if (rand3 < (k34/(k34+k43)) )           
                                    RyR = 4;           
                                    trans = (k43+k45);
                                    if (rand1 < trans*dt)
                                        if(rand2 <= k43/trans)
                                            RyR = 3;
                                        else
                                            RyR = 8;
                                        end
                                    end      
                                  else 
                                      RyR = 3;
                                      trans = (k32+k34);
                                        if (rand1 < trans*dt ) 
                                            if(rand2 <= (k32/trans))
                                                RyR = 2;
                                            else
                                                RyR = 4;
                                            end
                                        end      
                                  end
                            else
                                if(RyR == 8)
                                    a1 = k65/(k56+k65);
                                    a2 = a1*k52;
                                    a3 = a1*k54;
                                    trans = a2+a3;
                                      if (rand1 < trans*dt)
                                        if(rand2 <= a2/trans)
                                            RyR = 2;
                                        else
                                            RyR = 8;
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
        
    else
        
    if(RyR == 1)
        trans = k12;
        if (rand1 < trans*dt) 
            RyR = 2;
        end
    else
        if(RyR == 2)
            trans = k21+k23+k25;
            if (rand1 < trans*dt) 
                if(rand2 <= (k21/trans))
                    RyR = 1;
                else
                    if(rand2 <= ((k21 + k23)/trans))
                        RyR = 7;
                    else
                        RyR = 8;
                    end
                end
            end
        else
            if(RyR == 3)
                RyR = 7;
                a1 = k34/(k43+k34);
                a2 = (1.0-a1)*k32;
                a3 = a1*k45;               
                trans = a2+a3;
                    if (rand1 <  trans*dt) 
                        if(rand2 <= a2/trans)
                            RyR = 2;
                        else
                            RyR = 8;
                        end
                    end
            else
                if(RyR == 4)
                    RyR = 7;
                    a1 = k34/(k43+k34);
                    a2 = (1.0-a1)*k32;
                    a3 = a1*k45;               
                    trans = a2+a3;
                        if (rand1 <  trans*dt) 
                            if(rand2 <= a2/trans)
                                RyR = 2;
                            else
                                RyR = 8;
                            end
                        end
                 else
                    if(RyR == 5)
                        RyR = 8;		
                        a1 = k65/(k56+k65);
                        a2 = a1*k52;
                        a3 = a1*k54;         
                        trans = (a2 +a3);
                            if (rand1 < trans*dt) 
                                if(rand2 <= a2/trans)
                                    RyR = 2;
                                else
                                    RyR = 8;
                                end
                            end
                    else
                        if(RyR == 6)
                            RyR = 8;
                            a1 = k65/(k56+k65);
                            a2 = a1*k52;
                            a3 = a1*k54;         
                            trans = (a2 +a3);
                                if (rand1 < trans*dt) 
                                    if(rand2 <= a2/trans)
                                        RyR = 2;
                                    else
                                        RyR = 8;
                                    end
                                end
                        else
                            if(RyR == 7)                                
                                a1 = k34/(k43+k34);
                                a2 = (1.0-a1)*k32;
                                a3 = a1*k45;               
                                trans = a2+a3;
                                    if (rand1 <  trans*dt) 
                                        if(rand2 <= a2/trans)
                                            RyR = 2;
                                        else
                                            RyR = 8;
                                        end
                                    end
                            else
                                if(RyR == 8)                                		
                                    a1 = k65/(k56+k65);
                                    a2 = a1*k52;
                                    a3 = a1*k54;         
                                    trans = (a2 +a3);
                                        if (rand1 < trans*dt) 
                                            if(rand2 <= a2/trans)
                                                RyR = 2;
                                            else
                                                RyR = 8;
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

