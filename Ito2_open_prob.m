function [I1, I2, I3, I4 ] = Ito2_open_prob(Ito2_1, Ito2_2, Ito2_3, Ito2_4)

I1 = 0;
I2 = 0;
I3 = 0;
I4 = 0;
if(Ito2_1 == 2)
    I1 = 1;
end

if(Ito2_2 == 2)
    I2 = 1;
end

if(Ito2_3 == 2)
    I3 = 1;
end

if(Ito2_4 == 2)
    I4 = 1;
end

end

