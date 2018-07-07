function [N1,N2,N3,N4] = RyR_occupancy_int(RyR1, RyR2, RyR3, RyR4, RyR5)

N1 = 0;
N2 = 0;
N3 = 0;
N4 = 0;

% State 1
if(RyR1==1)
   N1 = N1 + 1;
end
if(RyR2==1)
   N1 = N1 + 1;
end
if(RyR3==1)
   N1 = N1 + 1;
end
if(RyR4==1)
   N1 = N1 + 1;
end
if(RyR5==1)
   N1 = N1 + 1;
end

% State 2
if(RyR1==2)
   N2 = N2 + 1;
end
if(RyR2==2)
   N2 = N2 + 1;
end
if(RyR3==2)
   N2 = N2 + 1;
end
if(RyR4==2)
   N2 = N2 + 1;
end
if(RyR5==2)
   N2 = N2 + 1;
end

%State 3
if(RyR1==3)
   N3 = N3 + 1;
end
if(RyR2==3)
   N3 = N3 + 1;
end
if(RyR3==3)
   N3 = N3 + 1;
end
if(RyR4==3)
   N3 = N3 + 1;
end
if(RyR5==3)
   N3 = N3 + 1;
end

% State 4
if(RyR1==4)
   N4 = N4 + 1;
end
if(RyR2==4)
   N4 = N4 + 1;
end
if(RyR3==4)
   N4 = N4 + 1;
end
if(RyR4==4)
   N4 = N4 + 1;
end
if(RyR5==4)
   N4 = N4 + 1;
end


end

