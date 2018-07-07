fileID = fopen('states1.txt','r');
formatSpec = '%s';
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
Time    = str2double(C_data{1}(2:end));
V       = str2double(C_data{2}(2:end));
mNa     = str2double(C_data{3}(2:end));
hNa     = str2double(C_data{4}(2:end));
jNa     = str2double(C_data{5}(2:end));
Nai     = str2double(C_data{6}(2:end));
Ki      = str2double(C_data{7}(2:end));
Cai    = str2double(C_data{8}(2:end));
CaNSR  = str2double(C_data{9}(2:end));
xKs     = str2double(C_data{10}(2:end));
LTRPNCa = str2double(C_data{11}(2:end));
HTRPNCa = str2double(C_data{12}(2:end));
C0Kv43	= str2double(C_data{13}(2:end));
C1Kv43	= str2double(C_data{14}(2:end));
C2Kv43	= str2double(C_data{15}(2:end));
C3Kv43	= str2double(C_data{16}(2:end));
OKv43	= str2double(C_data{17}(2:end));
CI0Kv43	= str2double(C_data{18}(2:end));
CI1Kv43	= str2double(C_data{19}(2:end));
CI2Kv43	= str2double(C_data{20}(2:end));
CI3Kv43	= str2double(C_data{21}(2:end));
OIKv43	= str2double(C_data{22}(2:end));
C0Kv14	= str2double(C_data{23}(2:end));
C1Kv14	= str2double(C_data{24}(2:end));
C2Kv14	= str2double(C_data{25}(2:end));
C3Kv14	= str2double(C_data{26}(2:end));
OKv14	= str2double(C_data{27}(2:end));
CI0Kv14	= str2double(C_data{28}(2:end));
CI1Kv14	= str2double(C_data{29}(2:end));
CI2Kv14	= str2double(C_data{30}(2:end));
CI3Kv14 = str2double(C_data{31}(2:end));
OIKv14	= str2double(C_data{32}(2:end));
CaToT	= str2double(C_data{33}(2:end));
C1Herg	= str2double(C_data{34}(2:end));
C2Herg	= str2double(C_data{35}(2:end));
C3Herg	= str2double(C_data{36}(2:end));
OHerg	= str2double(C_data{37}(2:end));
IHerg   = str2double(C_data{38}(2:end));
fclose(fileID);
%%
fileID = fopen('states.0.txt','r');
formatSpec = '%s';
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
Time_c    = str2double(C_data{1}(2:end));
V_c       = str2double(C_data{2}(2:end));
mNa_c     = str2double(C_data{3}(2:end));
hNa_c     = str2double(C_data{4}(2:end));
jNa_c     = str2double(C_data{5}(2:end));
Nai_c     = str2double(C_data{6}(2:end));
Ki_c      = str2double(C_data{7}(2:end));
Cai_c    = str2double(C_data{8}(2:end));
CaNSR_c  = str2double(C_data{9}(2:end));
xKs_c     = str2double(C_data{10}(2:end));
LTRPNCa_c = str2double(C_data{11}(2:end));
HTRPNCa_c = str2double(C_data{12}(2:end));
C0Kv43_c	= str2double(C_data{13}(2:end));
C1Kv43_c	= str2double(C_data{14}(2:end));
C2Kv43_c	= str2double(C_data{15}(2:end));
C3Kv43_c	= str2double(C_data{16}(2:end));
OKv43_c	= str2double(C_data{17}(2:end));
CI0Kv43_c	= str2double(C_data{18}(2:end));
CI1Kv43_c	= str2double(C_data{19}(2:end));
CI2Kv43_c	= str2double(C_data{20}(2:end));
CI3Kv43_c	= str2double(C_data{21}(2:end));
OIKv43_c	= str2double(C_data{22}(2:end));
C0Kv14_c	= str2double(C_data{23}(2:end));
C1Kv14_c	= str2double(C_data{24}(2:end));
C2Kv14_c	= str2double(C_data{25}(2:end));
C3Kv14_c	= str2double(C_data{26}(2:end));
OKv14_c	= str2double(C_data{27}(2:end));
CI0Kv14_c	= str2double(C_data{28}(2:end));
CI1Kv14_c	= str2double(C_data{29}(2:end));
CI2Kv14_c	= str2double(C_data{30}(2:end));
CI3Kv14_c = str2double(C_data{31}(2:end));
OIKv14_c	= str2double(C_data{32}(2:end));
CaToT_c	= str2double(C_data{33}(2:end));
C1Herg_c	= str2double(C_data{34}(2:end));
C2Herg_c	= str2double(C_data{35}(2:end));
C3Herg_c	= str2double(C_data{36}(2:end));
OHerg_c	= str2double(C_data{37}(2:end));
IHerg_c   = str2double(C_data{38}(2:end));
fclose(fileID);
%%
fileID = fopen('currents1.txt','r');
formatSpec = '%s';
C_data1  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
INa       = str2double(C_data1{2}(2:end));
IKr     = str2double(C_data1{3}(2:end));
IKs     = str2double(C_data1{4}(2:end));
Ito1     = str2double(C_data1{5}(2:end));
IK1     = str2double(C_data1{6}(2:end));
IKp     = str2double(C_data1{7}(2:end));
INaCa     = str2double(C_data1{8}(2:end));
INaK   = str2double(C_data1{9}(2:end));
IpCa     = str2double(C_data1{10}(2:end));
ICab = str2double(C_data1{11}(2:end));
INab = str2double(C_data1{12}(2:end));
ICa	= str2double(C_data1{13}(2:end));
JDHPR	= str2double(C_data1{14}(2:end));
Jup	= str2double(C_data1{15}(2:end));
Jtrpn	= str2double(C_data1{16}(2:end));
Jtr	= str2double(C_data1{17}(2:end));
Jxfer	= str2double(C_data1{18}(2:end));
IKv43	= str2double(C_data1{19}(2:end));
IKv14	= str2double(C_data1{20}(2:end));
IKv14_K	= str2double(C_data1{21}(2:end));
IKv14_Na = str2double(C_data1{22}(2:end));
Ito2	= str2double(C_data1{23}(2:end));
Istim	= str2double(C_data1{24}(2:end));
Itot	= str2double(C_data1{25}(2:end));
fclose(fileID);

%%
fileID = fopen('currents.0.txt','r');
formatSpec = '%s';
C_data1  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
INa_c       = str2double(C_data1{2}(2:end));
IKr_c     = str2double(C_data1{3}(2:end));
IKs_c     = str2double(C_data1{4}(2:end));
Ito1_c     = str2double(C_data1{5}(2:end));
IK1_c     = str2double(C_data1{6}(2:end));
IKp_c     = str2double(C_data1{7}(2:end));
INaCa_c     = str2double(C_data1{8}(2:end));
INaK_c   = str2double(C_data1{9}(2:end));
IpCa_c     = str2double(C_data1{10}(2:end));
ICab_c = str2double(C_data1{11}(2:end));
INab_c = str2double(C_data1{12}(2:end));
ICa_c	= str2double(C_data1{13}(2:end));
JDHPR_c	= str2double(C_data1{14}(2:end));
Jup_c	= str2double(C_data1{15}(2:end));
Jtrpn_c	= str2double(C_data1{16}(2:end));
Jtr_c	= str2double(C_data1{17}(2:end));
Jxfer_c	= str2double(C_data1{18}(2:end));
IKv43_c	= str2double(C_data1{19}(2:end));
IKv14_c	= str2double(C_data1{20}(2:end));
IKv14_K_c	= str2double(C_data1{21}(2:end));
IKv14_Na_c = str2double(C_data1{22}(2:end));
Ito2_c	= str2double(C_data1{23}(2:end));
Istim_c	= str2double(C_data1{24}(2:end));
Itot_c	= str2double(C_data1{25}(2:end));
fclose(fileID);
%%
fileID = fopen('otherstates1.txt');
C_data2 = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s');
CaSSavg = str2double(C_data2{2}(2:end));
CaJSRavg = str2double(C_data2{3}(2:end));
JRyRtot = str2double(C_data2{4}(2:end));
PRyR_open = str2double(C_data2{5}(2:end));
PRyR_ready = str2double(C_data2{6}(2:end));
PNorm_mode = str2double(C_data2{7}(2:end));
PnotVinact = str2double(C_data2{8}(2:end));
PLType_open = str2double(C_data2{9}(2:end));
CaToT2 = str2double(C_data2{10}(2:end));
PIto2_open = str2double(C_data2{11}(2:end));
CaJSRtot = str2double(C_data2{12}(2:end));
CaSStot = str2double(C_data2{13}(2:end));

%%
fileID = fopen('otherstates.0.txt');
C_data2 = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s');
CaSSavg_c = str2double(C_data2{2}(2:end));
CaJSRavg_c = str2double(C_data2{3}(2:end));
JRyRtot_c = str2double(C_data2{4}(2:end));
PRyR_open_c = str2double(C_data2{5}(2:end));
PRyR_ready_c = str2double(C_data2{6}(2:end));
PNorm_mode_c = str2double(C_data2{7}(2:end));
PnotVinact_c = str2double(C_data2{8}(2:end));
PLType_open_c = str2double(C_data2{9}(2:end));
CaToT2_c = str2double(C_data2{10}(2:end));
PIto2_open_c = str2double(C_data2{11}(2:end));
CaJSRtot_c = str2double(C_data2{12}(2:end));
CaSStot_c = str2double(C_data2{13}(2:end));

%% Plots
startPlot = 1;
endPlot  = 3000;

%% Plot membrane voltage
figure
plot(Time(startPlot:endPlot), V(startPlot:endPlot));
%% Plot the myoplasmic calcium and NSR calcium
figure
subplot(4,1,1)
plot(Time, V)
hold all
% plot(Time_o, V_o)
plot(Time_c.*1000, V_c, '--')
title('Voltage Protocol');
ylabel('mV');
xlabel('Time (ms)')
legend('Euler','C code')
xlim([0 3000])
subplot(4,1,2)
plot(Time, Cai);
ylabel('mM');
xlabel('Time (ms)')
hold all
% plot(Time_o, Cai_o)
plot(Time_c.*1000, Cai_c, '--')
title('Myoplasmic calcium');
legend('Euler','C code')
xlim([0 3000])
subplot(4,1,3)
plot(Time, CaNSR);
ylabel('mM');
xlabel('Time (ms)')
hold all
% plot(Time_o, CaNSR_o);
plot(Time_c.*1000, CaNSR_c, '--');
xlim([0 3000])
legend('Euler','C code')
title('NSR Calcium');
subplot(4,1,4)
plot(Time, Nai);
ylabel('mM');
xlabel('Time (ms)')
hold all
% plot(Time_o, Nai_o)
plot(Time_c.*1000, Nai_c, '--')
legend('Euler','C code')
xlim([0 3000])
%plot(Nai(1).*ones(3000,1), 'r--');
title('Nai');

%% Plot currents
figure
subplot(3,4,1)
plot(INa);
% hold all
% plot(INa_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Fast Na+  current');
subplot(3,4,2)
plot(IKr);
% hold all
% plot(IKr_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Rapid potassium rectifier');
subplot(3,4,3)
plot(IKs);
% hold all
% plot(IKs_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Slow potassium rectifier current');
subplot(3,4,4)
plot(Ito1);
% hold all
% plot(Ito1_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Transient outward K+ current');
subplot(3,4,5)
plot(IK1);
% hold all
% plot(IK1_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Time independent K');
subplot(3,4,6)
plot(IKp);
% hold all
% plot(IKp_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Plateau K ');
subplot(3,4,7)
plot(Ito2);
% hold all
% plot(Ito2_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Calcium dependent chlorine current')
subplot(3,4,8)
plot(INaK);
% hold all
% plot(INaK_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Sodium potassium pump');
subplot(3,4,9)
plot(INaCa);
% hold all
% plot(INaCa_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Sodium calcium exchanger');
subplot(3,4,10)
plot(IpCa);
% hold all
% plot(IpCa_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Calcium pump');
subplot(3,4,11)
plot(INab);
% hold all
% plot(INab_c);
xlim([0 3000])
% legend('MATLAB','C code');
title('Background sodium');
subplot(3,4,12)
plot(ICab);
% hold all
% plot(ICab_c);
% legend('MATLAB','C code');
xlim([0 3000])
title('Background Calcium');

%% Plot fluxes
figure
subplot(3,2,1)
plot(Jup);
hold all
plot(Jup_c)
xlim([0 3000])
legend('MATLAB','c');
title('Serca Pump');
subplot(3,2,2)
plot(Jtr);
hold all
plot(Jtr_c)
xlim([0 3000])
legend('MATLAB','c');
title('NSR-JSR');
subplot(3,2,3)
plot(Jxfer);
hold all
plot(Jxfer_c)
xlim([0 3000])
legend('MATLAB','c');
title('Dyad myo');
subplot(3,2,4)
plot(JRyRtot);
hold all
plot(JRyRtot_c)
xlim([0 3000])
legend('MATLAB','c');
title('RyR flux');
subplot(3,2,5)
plot(Jtrpn);
hold all
plot(Jtrpn_c)
xlim([0 3000])
legend('MATLAB','c');
title('Buffer');
%% Plot concentrations
figure
subplot(4,1,1)
plot(V)
ylim([-110, 20])
xlabel('Time')
ylabel('Membrane voltage (mV)')
subplot(4,1,2)
plot(CaSSavg)
ylabel('Dyadic calcium');
xlabel('Time (ms)');
subplot(4,1,3)
plot(Cai)
ylabel('Myoplasmic calcium');
xlabel('Time (ms)');
subplot(4,1,4)
plot(CaNSR);
hold on
plot(CaJSRavg);
title('NSR and JSR');
xlabel('Time (ms)');

%%
cai = vertcat(cai_10, cai_3);
nsr = vertcat(nsr_10, nsr_3);
nai = vertcat(nai_10, nai_3);
figure
subplot(3,1,1)
plot(cai)
title('Intracellular calcium');
xlabel('Time (ms)')
xlim([0 13000])
subplot(3,1,2)
plot(nsr)
xlabel('Time (ms)')
title('NSR Calcium');
xlim([0 13000])
subplot(3,1,3)
plot(nai)
xlabel('Time (ms)')
title('Intracellular sodium');
xlim([0 13000])

%% Plot frequency relationships
figure
subplot(2,1,1)
title('Myoplasmic Calcium')
plot(Cai2_5Hz);
hold on
plot(Cai2Hz);
plot(Cai1Hz);
%plot(Cai0_5Hz);
%plot(Cai0_25Hz);
legend('2.5 Hz','2 Hz', '1 Hz');
xlim([0 4000])
title('Myoplasmic Calcium')
subplot(2,1,2)
plot(CaNSR2_5Hz);
hold on
plot(CaNSR2Hz);
plot(CaNSR1Hz);
%plot(CaNSR0_5Hz);
%plot(CaNSR0_25Hz);
legend('2.5 Hz','2 Hz', '1 Hz');
xlim([0 4000])
title('NSR Calcium')
% subplot(3,1,3)
% plot(Nai_2_5Hz);
% hold on
% plot(Nai_2Hz);
% plot(Nai_1_3Hz);
% plot(Nai_1Hz);
% plot(Nai_0_5Hz);
% plot(Nai_0_25Hz);
% legend('2.5 Hz','2 Hz', '1.3 Hz', '1 Hz', '0.5 Hz','0.25 Hz');
%%
freq = [1,2,2.5];

%systolica(1) = max(Cai0_5Hz);
systolica(1) = max(Cai1Hz);
systolica(2) = max(Cai2Hz);
systolica(3) = max(Cai2_5Hz);

%diastolica(1) = min(Cai0_5Hz);
diastolica(1) = min(Cai1Hz);
diastolica(2) = min(Cai2Hz);
diastolica(3) = min(Cai2_5Hz);
amplitude = systolica - diastolica;
figure
plot(freq, systolica);
hold on
plot(freq,diastolica);
plot(freq,amplitude);
legend('Systolic Ca','Diastolic Ca','Amplitude');
xlim([0 3])
xlabel('Frequency')
ylabel('Calcium conc mM')

%%
figure
subplot(3,1,1)
plot(CaSSavg(1:3000))
hold all
plot(CaSSavg_c(1:3000),'--')
title('Average Dyadic concentration');
legend('MATLAB','C');
xlim([0 3000])
subplot(3,1,2)
plot(CaJSRavg(1:3000))
hold all
plot(CaJSRavg_c(1:3000),'--');
title('Average JSR concentration')
legend('MATLAB','C');
subplot(3,1,3)
plot(PRyR_open(1:3000))
hold all
plot(PRyR_open_c(1:3000),'--');
plot(PRyR_ready(1:3000));
plot(PRyR_ready_c(1:3000), '--');
plot(ones(3000,1) - PRyR_open(1:3000) - PRyR_ready(1:3000));
plot(ones(3000,1) - PRyR_open_c(1:3000) - PRyR_ready_c(1:3000),'--');
legend('Open','Open c','Available','Available c','Adapted','Adapted c','Location','bestoutside');
title('RyR state occupancy')
xlim([0 3000])

%%
figure
subplot(2,1,1)
plot(Cai1Hz);
hold all
%plot(Cai_1Hz, '--');
plot(Cai2Hz);
%plot(Cai_2Hz, '--');
legend('1Hz', '2Hz');
subplot(2,1,2)
plot(CaNSR1Hz);
hold all
%plot(CaNSR_1Hz, '--');
plot(CaNSR2Hz);
%plot(CaNSR_2Hz, '--');
legend('1Hz', '2Hz');
clc

%%
freq = [1,2];
sys = [max(Cai1Hz), max(Cai2Hz)];
sys_old = [max(Cai_1Hz), max(Cai_2Hz)];
dia = [min(Cai1Hz), min(Cai2Hz)];
dia_old = [min(Cai_1Hz), min(Cai_2Hz)];
amp = sys - dia;
amp_old = sys_old - dia_old;
figure
plot(freq, sys, 'b-o','MarkerFaceColor','b');
hold all
plot(freq, sys_old, 'b--o');
plot(freq, dia, 'm-^','MarkerFaceColor','m');
plot(freq, dia_old, 'm--^');
plot(freq, amp, 'g-s','MarkerFaceColor','g');
plot(freq,amp_old,'g--s');
xlim([0 3])
ylim([0 1e-3])
legend('systole','systole old','diastole','diastole old','amplitude','amplitude old');


%%
Cai= [];
CaNSR = [];
fileID = fopen('Cai1.txt','r');
formatSpec = '%s';
n_shells= 80;
%C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s');
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
    Cai(:,s) = str2double(C_data{s+1}(2:end));
end

fileID = fopen('CaNSR1.txt','r');
formatSpec = '%s';
%C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s');
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
    CaNSR(:,s) = str2double(C_data{s+1}(2:end));
end
%%
figure 
subplot(2,1,1)
plot(Cai)
xlabel('Time (ms)');
ylabel('Cai (mM)')
xlim([6000 10000])
subplot(2,1,2)
plot(CaNSR)
xlabel('Time (ms)');
ylabel('CaNSR (mM)')
xlim([6000 10000])
ylim([0.25 0.4])
%%
figure 
subplot(3,2,1)
plot(Cai)
%legend('1','2','3','4','5','6','7','8','9','10');
title('0.5 Hz')
xlabel('Time (ms)');
ylabel('Cai (mM)')
xlim([0 6000])
ylim([0 1e-3])

subplot(3,2,2)
plot(CaNSR)
%legend('1','2','3','4','5','6','7','8','9','10');
title('0.5 Hz')
xlabel('Time (ms)');
ylabel('CaNSR (mM)')
xlim([0 6000])
ylim([0.35 1.2])

subplot(3,2,3)
plot(Cai_1Hz(6000:end,:))
%legend('1','2','3','4','5','6','7','8','9','10');
title('1 Hz')
xlabel('Time (ms)');
ylabel('Cai (mM)')
xlim([0 4000])
ylim([0 1e-3])

subplot(3,2,4)
plot(CaNSR_1Hz(6000:end,:))
%legend('1','2','3','4','5','6','7','8','9','10');
title('1 Hz')
xlabel('Time (ms)');
ylabel('CaNSR (mM)')
xlim([0 4000])
ylim([0.35 1.2])

subplot(3,2,5)
plot(Cai_2Hz(2500:end,:))
%legend('1','2','3','4','5','6','7','8','9','10');
title('2 Hz')
xlabel('Time (ms)');
ylabel('Cai (mM)')
xlim([0 2500])
ylim([0 1e-3])

subplot(3,2,6)
plot(CaNSR_2Hz(2500:end,:))
%legend('1','2','3','4','5','6','7','8','9','10');
title('2 Hz')
xlabel('Time (ms)');
ylabel('CaNSR (mM)')
xlim([0 2500])
ylim([0.35 1.2])

%%
cai_whole_cell_2Hz = horzcat(Cai_2Hz(2500:end,:), fliplr(Cai_2Hz(2500:end,:)));
cai_whole_cell = horzcat(Cai, fliplr(Cai));
cai_whole_cell_0_5Hz = horzcat(Cai_0_5Hz(14000:end,:), fliplr(Cai_0_5Hz(14000:end,:)));
figure
subplot(1,3,1)
pcolor(cai_whole_cell_0_5Hz)
shading interp
colorbar
title('0.5 Hz')
xlabel('Cell Radius');
ylabel('Time')
caxis([0.0685e-3 0.8168e-3])

subplot(1,3,2)
pcolor(cai_whole_cell_1Hz)
shading interp
colorbar
title('1 Hz')
xlabel('Cell Radius');
ylabel('Time')
caxis([0.0685e-3 0.8168e-3])

subplot(1,3,3)
pcolor(cai_whole_cell_2Hz)
shading interp
colorbar
title('2 Hz')
xlabel('Cell Radius');
ylabel('Time')
caxis([0.0685e-3 0.8168e-3])

%%
JRyR_scaled = [];
Jtr_scaled  = [];
for s = 1:n_shells-1
JRyR_scaled(:,s) = JRyRint_Array(:,s).*(VCSR(s)/Vmyo(s+1));
end

for s = 1:n_shells-1
Jtr_scaled(:,s) = Jtrint_Array(:,s).*(VCSR(s)/VNSR(s+1));
end
%%
figure
subplot(3,2,1)
plot(JMyodiff_Array)
legend('1','2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('Myoplasmic diffusion flux (mM/ms)')
title('Myoplasmic diffusion flux (mM/ms)')
xlim([0 600])

subplot(3,2,2)
plot(JNSRdiff_Array)
legend('1','2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('NSR diffusion flux (mM/ms)')
title('NSR diffusion flux (mM/ms)')
xlim([0 600])

subplot(3,2,5)
plot(JRyR_scaled)
legend('2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('RyR flux (mM/ms)')
ylim([0 1e-3])
title('RyR flux (mM/ms)')
xlim([0 600])

subplot(3,2,4)
plot(Jup_Array)
legend('1','2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('SERCA uptake flux(mM/ms)')
title('SERCA uptake flux(mM/ms)')
xlim([0 600])

subplot(3,2,3)
plot(Jtrpn_Array)
legend('1','2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('Trpn Buffer flux(mM/ms)')
title('Trpn Buffer flux(mM/ms)')
xlim([0 600])

subplot(3,2,6)
plot(Jtr_scaled)
legend('2','3','4','5','6','7','8','9','10')
xlabel('Time (ms)')
ylabel('NSR - JSR flux(mM/ms)')      
title('NSR - JSR flux(mM/ms)')   
xlim([0 600])

%%
figure
subplot(5,2,1)
plot(JRyRtot)
title('Shell 1')

subplot(5,2,3)
plot(JRyR_scaled(2:end,1))
title('Shell 2')

subplot(5,2,5)
plot(JRyR_scaled(2:end,2))
title('Shell 3')
%ylim([0 1e-3])

subplot(5,2,7)
plot(JRyR_scaled(2:end,3))
title('Shell 4')
%ylim([0 1e-3])

subplot(5,2,9)
plot(JRyR_scaled(2:end,4))
title('Shell 5')
%ylim([0 1e-3])

subplot(5,2,2)
plot(JRyR_scaled(2:end,5))
title('Shell 6')
%ylim([0 1e-3])

subplot(5,2,4)
plot(JRyR_scaled(2:end,6))
title('Shell 7')
%ylim([0 1e-3])

subplot(5,2,6)
plot(JRyR_scaled(2:end,7))
title('Shell 8')
%ylim([0 1e-3])

subplot(5,2,8)
plot(JRyR_scaled(2:end,8))
title('Shell 9')
%ylim([0 1e-3])

subplot(5,2,10)
plot(JRyR_scaled(2:end,9))
title('Shell 10')
%ylim([0 4e-3])

%%
k21= 250.0.*ones(3001,1);
k32=9.6.*ones(3001,1);
k43=13.6493.*ones(3001,1);
k45=0.07.*ones(3001,1);
k52 = 0.00667.*ones(3001,1);
k65=30.0.*ones(3001,1); %	at 10 CaNSR	rises

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
Sat_term = min(threshMAX,(Cai.*Cai)/k_rate);
Sat_term2 =	min(threshMAX,(Cai.*Cai)/k_rate2);

k12	= k12cf	* Sat_term2;
k23	= k23cf	* Sat_term;
k34	= k34cf	* Sat_term;
k54	= k54cf	* Sat_term;
k25	= k25cf	* Sat_term;
k56	= k56cf	* Sat_term;

ss1 = k21./(k21 + k12);
ss2 = (k12 + k32 + k52)./(k12 + k32 + k52 + k21 + k23 + k25);
ss3 =  (k23 + k43)./(k23 + k43 + k32 + k34);
ss4 =  (k34 + k54)./(k34 + k54 + k43 + k45);
ss5 =  (k25 + k45 + k65)./(k25 + k45 + k65 + k52 + k54 + k56);
ss6 =  (k56)./(k56 + k65);

figure
subplot(3,2,1)
plot(ss1)
xlim([0 3000])
subplot(3,2,2)
plot(ss2)
xlim([0 3000])
subplot(3,2,3)
plot(ss3)
xlim([0 3000])
subplot(3,2,4)
plot(ss4)
xlim([0 3000])
subplot(3,2,5)
plot(ss5)
xlim([0 3000])
subplot(3,2,6)
plot(ss6)
xlim([0 3000])

%%
O1_RyR = [];
O2_RyR = [];
C1_RyR = [];
C2_RyR = [];
fileID = fopen('O1_RyR1.txt','r');
formatSpec = '%s';
n_shells= 72;
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
    O1_RyR(:,s) = str2double(C_data{s+1}(2:end));
end
fileID = fopen('O2_RyR1.txt','r');
formatSpec = '%s';
n_shells= 72;
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
O2_RyR(:,s) = str2double(C_data{s+1}(2:end));
end
fileID = fopen('C2_RyR1.txt','r');
formatSpec = '%s';
n_shells= 72;
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
C2_RyR(:,s) = str2double(C_data{s+1}(2:end));
end
fileID = fopen('C1_RyR1.txt','r');
formatSpec = '%s';
n_shells= 72;
C_data  = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
for s = 1:n_shells
C1_RyR(:,s) = str2double(C_data{s+1}(2:end));
end



figure
subplot(2,2,1)
plot(O1_RyR);
xlim([6000 10000])
title('O1 RyR')
subplot(2,2,2)
plot(O2_RyR);
xlim([6000 10000])
title('O2 RyR')
subplot(2,2,3)
plot(C1_RyR);
xlim([6000 10000])
title('C1 RyR')
subplot(2,2,4)
plot(C2_RyR);
title('C2 RyR')
xlim([6000 10000])


