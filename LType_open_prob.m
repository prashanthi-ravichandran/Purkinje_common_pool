function [ LO1, LN1, LI1, LO2, LN2, LI2, LO3,LN3, LI3, LO4, LN4, LI4 ] = LType_open_prob( LCC1, LCC2, LCC3, LCC4, Y1, Y2, Y3, Y4)

LO1 = 0;
LN1 = 0;
LI1 = 0;
LO2 = 0;
LN2 = 0;
LI2 = 0; 
LO3 = 0;
LN3 = 0;
LI3 = 0;
LO4 = 0;
LN4 = 0;
LI4 = 0; 
if((LCC1 == 6 || LCC1 == 12) && (Y1==2))
    LO1 = 1;
end

if((LCC2 == 6 || LCC2 == 12) && (Y2==2))
    LO2 = 1;
end

if((LCC3 == 6 || LCC3 == 12) && (Y3==2))
    LO3 = 1;
end

if((LCC4 == 6 || LCC4 == 12) && (Y4==2))
    LO4 = 1;
end


if(LCC1>= 1 && LCC1<=6)
    LN1 = 1;
end

if(LCC2>= 1 && LCC2<=6)
    LN2 = 1;
end

if(LCC3>= 1 && LCC3<=6)
    LN3 = 1;
end

if(LCC4>= 1 && LCC4<=6)
    LN4 = 1;
end

if(Y1 == 1)
    LI1 = 1;
end

if(Y2 ==1)
    LI2 = 1;
end

if(Y3 ==1 )
    LI3 = 1;
end

if(Y4==1)
    LI4 = 1;
end


end

