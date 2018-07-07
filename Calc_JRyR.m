function [JRyRtot] = Calc_JRyR(CaJSR, CaSS1, CaSS2, CaSS3, CaSS4,RyR11, RyR12, RyR13, RyR14, RyR15, RyR21, RyR22, RyR23, RyR24, RyR25, RyR31, RyR32,RyR33,...
                               RyR34, RyR35, RyR41, RyR42, RyR43, RyR44, RyR45)

O1_RyR   = 3;
O2_RyR   = 4;
O3_RyR   = 7;

% JSR to subspace through a single RyR (1/ms)
JRyRmax= (0.6*1.5*1.1*3.96);
NRyR_open1 = 0;
NRyR_open2 = 0;
NRyR_open3 = 0;
NRyR_open4 = 0;
% CaRU 1
if(RyR11 == O1_RyR || RyR11 == O2_RyR || RyR11 == O3_RyR)
    NRyR_open1 = NRyR_open1 + 1;
end
if(RyR12 == O1_RyR || RyR12 == O2_RyR || RyR12 == O3_RyR)
    NRyR_open1 = NRyR_open1 + 1;
end
if(RyR13 == O1_RyR || RyR13 == O2_RyR || RyR13 == O3_RyR)
    NRyR_open1 = NRyR_open1 + 1;
end
if(RyR14 == O1_RyR || RyR14 == O2_RyR || RyR14 == O3_RyR)
    NRyR_open1 = NRyR_open1 + 1;
end
if(RyR15 == O1_RyR || RyR15 == O2_RyR || RyR15 == O3_RyR)
    NRyR_open1 = NRyR_open1 + 1;
end
%CaRU 2
if(RyR21 == O1_RyR || RyR21 == O2_RyR || RyR21 == O3_RyR)
    NRyR_open2 = NRyR_open2 + 1;
end
if(RyR22 == O1_RyR || RyR22 == O2_RyR || RyR22 == O3_RyR)
    NRyR_open2 = NRyR_open2 + 1;
end
if(RyR23 == O1_RyR || RyR23 == O2_RyR || RyR23 == O3_RyR)
    NRyR_open2 = NRyR_open2 + 1;
end
if(RyR24 == O1_RyR || RyR24 == O2_RyR || RyR24 == O3_RyR)
    NRyR_open2 = NRyR_open2 + 1;
end
if(RyR25 == O1_RyR || RyR25 == O2_RyR || RyR25 == O3_RyR)
    NRyR_open2 = NRyR_open2 + 1;
end

% CaRU 3
if(RyR31 == O1_RyR || RyR31 == O2_RyR || RyR31 == O3_RyR)
    NRyR_open3 = NRyR_open3 + 1;
end
if(RyR32 == O1_RyR || RyR32 == O2_RyR || RyR32 == O3_RyR)
    NRyR_open3 = NRyR_open3 + 1;
end
if(RyR33 == O1_RyR || RyR33 == O2_RyR || RyR33 == O3_RyR)
    NRyR_open3 = NRyR_open3 + 1;
end
if(RyR34 == O1_RyR || RyR34 == O2_RyR || RyR34 == O3_RyR)
    NRyR_open3 = NRyR_open3 + 1;
end
if(RyR35 == O1_RyR || RyR35 == O2_RyR || RyR35 == O3_RyR)
    NRyR_open3 = NRyR_open3 + 1;
end

% CaRU 4
if(RyR41 == O1_RyR || RyR41 == O2_RyR || RyR41 == O3_RyR)
    NRyR_open4 = NRyR_open4 + 1;
end
if(RyR42 == O1_RyR || RyR42 == O2_RyR || RyR42 == O3_RyR)
    NRyR_open4 = NRyR_open4 + 1;
end
if(RyR43 == O1_RyR || RyR43 == O2_RyR || RyR43 == O3_RyR)
    NRyR_open4 = NRyR_open4 + 1;
end
if(RyR44 == O1_RyR || RyR44 == O2_RyR || RyR44 == O3_RyR)
    NRyR_open4 = NRyR_open4 + 1;
end
if(RyR45 == O1_RyR || RyR45 == O2_RyR || RyR45 == O3_RyR)
    NRyR_open4 = NRyR_open4 + 1;
end

% Calculate RyR flux

JRyR_1 = JRyRmax*(NRyR_open1)*(CaJSR-CaSS1);
JRyR_2 = JRyRmax*(NRyR_open2)*(CaJSR-CaSS2);
JRyR_3 = JRyRmax*(NRyR_open3)*(CaJSR-CaSS3);
JRyR_4 = JRyRmax*(NRyR_open4)*(CaJSR-CaSS4);
JRyRtot = JRyR_1+JRyR_2+JRyR_3+JRyR_4;

end

