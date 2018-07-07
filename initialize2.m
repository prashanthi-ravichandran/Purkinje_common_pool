function [ state, FRU_state,CaCSR, Ltype_state, RyR_ss_state,...
           RyR_int_state, Ito2_state,CaiArray,CaNSRArray, LTRPNCaArray,...
           HTRPNCaArray,O1_RyR,O2_RyR,C1_RyR,C2_RyR] = initialize2(ic_states_file, ic_FRU_file,...
                                       ic_LCh_file,ic_RyR_int_file,ic_Ito2_file,...
                                       ic_RyR_ss_file, ic_Cai_file, ic_CaNSR_file,ic_CaCSR_file,...
                                       ic_HTRPNCa_file, ic_LTRPNCa_file,ic_O1_RyR_file,ic_O2_RyR_file,...
                                       ic_C1_RyR_file,ic_C2_RyR_file)

% Read in initial conditions from specified text files 
 global Nclefts_FRU NRyRs_per_cleft Nstates_FRU Nindepstates_LType
 global NFRU_sim N N_ss 
% Define the indices
index_V         = 1;
index_mNa       = 2;
index_hNa       = 3;
index_jNa       = 4;
index_Nai       = 5;
index_Ki        = 6;
index_Cai       = 7;
index_CaNSR     = 8;
index_xKs       = 9;
index_LTRPNCa   = 10;
index_HTRPNCa   = 11;
index_C0Kv43    = 12;
index_C1Kv43    = 13;
index_C2Kv43    = 14;
index_C3Kv43    = 15;
index_OKv43     = 16;
index_CI0Kv43   = 17;
index_CI1Kv43   = 18;
index_CI2Kv43   = 19;
index_CI3Kv43   = 20;
index_OIKv43    = 21;
index_C0Kv14    = 22;
index_C1Kv14    = 23;
index_C2Kv14    = 24;
index_C3Kv14    = 25;
index_OKv14     = 26;
index_CI0Kv14   = 27;
index_CI1Kv14   = 28;
index_CI2Kv14   = 29;
index_CI3Kv14   = 30;
index_OIKv14    = 31;
index_CaTOT     = 32;
index_C1Herg    = 33;
index_C2Herg    = 34;
index_C3Herg    = 35;
index_OHerg     = 36;
index_IHerg     = 37;

state          = zeros(N,1);
FRU_state      = zeros(N_ss, Nstates_FRU);
Ltype_state    = zeros(N_ss, Nclefts_FRU,Nindepstates_LType);
Ito2_state     = zeros(N_ss,Nclefts_FRU);
RyR_ss_state   = zeros(N_ss, Nclefts_FRU,NRyRs_per_cleft);
RyR_int_state  = zeros((NFRU_sim - N_ss), Nclefts_FRU, NRyRs_per_cleft); 

% Initialize the states
fileID = fopen(ic_states_file,'r');
C_data  = textscan(fileID,'%s');
state(index_V)        = str2double(C_data{1}(index_V));
state(index_mNa)      = str2double(C_data{1}(index_mNa));
state(index_hNa)      = str2double(C_data{1}(index_hNa));
state(index_jNa)      = str2double(C_data{1}(index_jNa));
state(index_Nai)      = str2double(C_data{1}(index_Nai));
state(index_Ki)       = str2double(C_data{1}(index_Ki));
state(index_Cai)      = str2double(C_data{1}(index_Cai));
state(index_CaNSR)    = str2double(C_data{1}(index_CaNSR));
state(index_LTRPNCa)  = str2double(C_data{1}(index_LTRPNCa));
state(index_HTRPNCa)  = str2double(C_data{1}(index_HTRPNCa));
state(index_xKs)      = str2double(C_data{1}(index_xKs));
state(index_C1Herg)   = str2double(C_data{1}(index_C1Herg));
state(index_C2Herg)   = str2double(C_data{1}(index_C2Herg));
state(index_C3Herg)   = str2double(C_data{1}(index_C3Herg));
state(index_OHerg)    = str2double(C_data{1}(index_OHerg));
state(index_IHerg)    = str2double(C_data{1}(index_IHerg));
state(index_C0Kv43)   = str2double(C_data{1}(index_C0Kv43));
state(index_C1Kv43)   = str2double(C_data{1}(index_C1Kv43));
state(index_C2Kv43)   = str2double(C_data{1}(index_C2Kv43));
state(index_C3Kv43)   = str2double(C_data{1}(index_C3Kv43));
state(index_OKv43)    = str2double(C_data{1}(index_OKv43));
state(index_CI0Kv43)  = str2double(C_data{1}(index_CI0Kv43));
state(index_CI1Kv43)  = str2double(C_data{1}(index_CI1Kv43));
state(index_CI2Kv43)  = str2double(C_data{1}(index_CI2Kv43));
state(index_CI3Kv43)  = str2double(C_data{1}(index_CI3Kv43));
state(index_OIKv43)  = 1.0- sum(state(index_OIKv43));
state(index_C0Kv14)  = str2double(C_data{1}(index_C0Kv14));
state(index_C1Kv14)  = str2double(C_data{1}(index_C1Kv14));
state(index_C2Kv14)  = str2double(C_data{1}(index_C2Kv14));
state(index_C3Kv14)   = str2double(C_data{1}(index_C3Kv14));
state(index_OKv14)   = str2double(C_data{1}(index_OKv14));
state(index_CI0Kv14)  = str2double(C_data{1}(index_CI0Kv14));
state(index_CI1Kv14)  = str2double(C_data{1}(index_CI1Kv14));
state(index_CI2Kv14)  = str2double(C_data{1}(index_CI2Kv14));
state(index_CI3Kv14) = str2double(C_data{1}(index_CI3Kv14));
state(index_OIKv14)  =  1.0- sum(state(index_OIKv14));
state(index_CaTOT)  =   str2double(C_data{1}(index_CaTOT));

state = state';

% Initialize the FRU concentrations

fileID = fopen(ic_FRU_file, 'r');
C_data1  = textscan(fileID,'%s %s %s %s %s');
IC_length = length(str2double(C_data1{1}(1:end)));
rewind_times = ceil(N_ss/IC_length);
i = 1;
while (i <= rewind_times)
    start_ind = (i-1)*IC_length + 1;
    end_ind = min(i*IC_length, N_ss);
    FRU_state(start_ind:end_ind,1) = str2double(C_data1{1}(start_ind:end_ind));
    FRU_state(start_ind:end_ind,2) = str2double(C_data1{2}(start_ind:end_ind));
    FRU_state(start_ind:end_ind,3) = str2double(C_data1{3}(start_ind:end_ind));
    FRU_state(start_ind:end_ind,4) = str2double(C_data1{4}(start_ind:end_ind));
    FRU_state(start_ind:end_ind,5) = str2double(C_data1{5}(start_ind:end_ind));
    i = i+1;
end

fileID = fopen(ic_LCh_file);
C_data2  = textscan(fileID,'%s %s');
IC_length = str2double(C_data2{1}(1));
IC_length = IC_length/4;
rewind_times = ceil(N_ss/IC_length);
L = str2double(C_data2{1}(2:end));
Y = str2double(C_data2{2}(2:end));
r = 1;
while(r<= rewind_times)
  i=1;
  FRU_start = (r-1)*IC_length + 1;
  FRU_end = min((r*IC_length),N_ss);
  for iFRU=FRU_start:FRU_end
        for icleft = 1:Nclefts_FRU
               Ltype_state(iFRU,icleft,1) = L(i);
               Ltype_state(iFRU,icleft,2) = Y(i);
               i = i+ 1;
        end
  end
  r =  r+ 1;
end

fileID = fopen(ic_RyR_ss_file);
C_data3  = textscan(fileID,'%s %s %s %s %s');
M1 = str2double(C_data3{1}(2:end));
M2 = str2double(C_data3{2}(2:end));
M3 = str2double(C_data3{3}(2:end));
M4 = str2double(C_data3{4}(2:end));
M5 = str2double(C_data3{5}(2:end));
IC_length = length(str2double(C_data2{1}(2:end)));
rewind_times = ceil(IC_length/N_ss);
r = 1;
while(r <= rewind_times)
    start_ind = (r-1)*N_ss + 1;
    end_ind   = r*N_ss;
    RyR_ss_state(1:N_ss,r,1) = M1(start_ind:end_ind);
    RyR_ss_state(1:N_ss,r,2) = M2(start_ind:end_ind);
    RyR_ss_state(1:N_ss,r,3) = M3(start_ind:end_ind);
    RyR_ss_state(1:N_ss,r,4) = M4(start_ind:end_ind);
    RyR_ss_state(1:N_ss,r,5) = M5(start_ind:end_ind);
    r = r+1;
end

fileID = fopen(ic_RyR_int_file);
C_data3  = textscan(fileID,'%s %s %s %s %s');
M1 = [];
M2 = [];
M3 = [];
M4 = [];
M5 = [];
M1 = str2double(C_data3{1}(2:end));
M2 = str2double(C_data3{2}(2:end));
M3 = str2double(C_data3{3}(2:end));
M4 = str2double(C_data3{4}(2:end));
M5 = str2double(C_data3{5}(2:end));
IC_length = length(str2double(C_data3{1}(2:end)));
rewind_times = ceil(IC_length/(NFRU_sim - N_ss));
r = 1;
while(r <= rewind_times)
    start_ind = (r-1)*(NFRU_sim - N_ss) + 1;
    end_ind   = r*(NFRU_sim - N_ss);
    RyR_int_state(1:(NFRU_sim - N_ss),r,1) = M1(start_ind:end_ind);
    RyR_int_state(1:(NFRU_sim - N_ss),r,2) = M2(start_ind:end_ind);
    RyR_int_state(1:(NFRU_sim - N_ss),r,3) = M3(start_ind:end_ind);
    RyR_int_state(1:(NFRU_sim - N_ss),r,4) = M4(start_ind:end_ind);
    RyR_int_state(1:(NFRU_sim - N_ss),r,5) = M5(start_ind:end_ind);
    r = r+1;
end

fileID = fopen(ic_Ito2_file );
C_data4  = textscan(fileID,'%s');
IC_length = length(str2double(C_data2{1}(2:end)));
IC_length = IC_length/Nclefts_FRU;
rewind = ceil(N_ss/ IC_length);
r =1;
while(r<= rewind)
start = (r-1)*IC_length + 1;
end_ind = min(r*IC_length, N_ss);
Ito2_state(start:end_ind, 1) = str2double(C_data4{1}(2:(2+end_ind - start)));
Ito2_state(start:end_ind, 2) = str2double(C_data4{1}(252:(252+end_ind - start)));
Ito2_state(start:end_ind, 3) = str2double(C_data4{1}(502:(502+end_ind - start)));
Ito2_state(start:end_ind, 4) = str2double(C_data4{1}(752:(752+end_ind - start)));
r= r+1;
end

fileID = fopen(ic_Cai_file);
C_data5  = textscan(fileID,'%s');
CaiArray = str2double(C_data5{1}(2:end));

fileID = fopen(ic_CaNSR_file);
C_data6  = textscan(fileID,'%s');
CaNSRArray = str2double(C_data6{1}(2:end));

fileID = fopen(ic_LTRPNCa_file);
C_data7  = textscan(fileID,'%s');
LTRPNCaArray = str2double(C_data7{1}(2:end));

fileID = fopen(ic_HTRPNCa_file);
C_data8  = textscan(fileID,'%s');
HTRPNCaArray = str2double(C_data8{1}(2:end));

CaiArray = CaiArray';
CaNSRArray = CaNSRArray';
HTRPNCaArray = HTRPNCaArray';
LTRPNCaArray = LTRPNCaArray';

fileID = fopen(ic_CaCSR_file);
C_data9 = textscan(fileID, '%s');
CaCSR = str2double(C_data9{1}(1:end));
CaCSR = CaCSR';

fileID = fopen(ic_O1_RyR_file);
C_data10  = textscan(fileID,'%s');
O1_RyR = str2double(C_data10{1}(2:end));

fileID = fopen(ic_O2_RyR_file);
C_data11  = textscan(fileID,'%s');
O2_RyR = str2double(C_data11{1}(2:end));

fileID = fopen(ic_C1_RyR_file);
C_data12  = textscan(fileID,'%s');
C1_RyR = str2double(C_data12{1}(2:end));

fileID = fopen(ic_C2_RyR_file);
C_data13  = textscan(fileID,'%s');
C2_RyR = str2double(C_data13{1}(2:end));

end

