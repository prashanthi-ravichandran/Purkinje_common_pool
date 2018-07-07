clear global
clear
clc
%Parameters
diff_factor = 1;
KSR_factor = 1.5;
NCX_factor = 1;
ksat_factor = 1;
SR_factor = 1;
vmaxr_factor = 2.0;
tubulation_factor = 0.9;
freq = 1;
num_beats  = 10;
filename = 'Fluxes';
ic_clamp = 1;
filenumber = 1; 
%output_dir = 'Trial';
output_dir = strcat('Freq_',num2str(freq),'Hz_NSRint_',num2str(SR_factor),'X_SERCA_',num2str(KSR_factor),'X_vmaxr_',num2str(vmaxr_factor),'X_k52mod_KeizerLevine_nshells_80_3');
mkdir(output_dir);
output_parameters_file   = strcat(output_dir,'/','parameters.txt');
fileID = fopen(output_parameters_file, 'w');
fprintf(fileID, '%s \t %s \n', 'Frequency = ',num2str(freq));
fprintf(fileID, '%s \t %s \n', 'KSR_factor = ',num2str(KSR_factor));
fprintf(fileID, '%s \t %s \n', 'Vmaxr_factor = ',num2str(vmaxr_factor));
fprintf(fileID, '%s \t %s \n', 'NCX_factor = ',num2str(NCX_factor));
fprintf(fileID, '%s \t %s \n', 'Tubulation_factor = ',num2str(tubulation_factor));
fprintf(fileID, '%s \t %s \n', 'Ksat_factor = ',num2str(ksat_factor));
fprintf(fileID, '%s \t %s \n', 'SR_factor = ',num2str(SR_factor));
fclose(fileID);  

%% Model definitions
global Nclefts_FRU Nstates_FRU Nstates_FRUdep Nstates_LType Nstates_RyR NRyRs_per_cleft Nindepstates_LType 
global NFRU_sim NFRU_scale
Nclefts_FRU = 4;
Nstates_FRU = (1+Nclefts_FRU);
Nstates_FRUdep = 3;

Nstates_LType = 12;
Nstates_RyR  = 6;
NRyRs_per_cleft  = 5;
Nindepstates_LType = 2;

 % Model geometry
global cell_radius r_ss n_shells r dr area shell_area area_ratios n_shells_ss n_shells_int
global shell_count N_ss cru_start cru_end 
global Acap VNSRtot Vmyotot VJSR VSS VNSR Vmyo VCSR VCSRtot

cell_radius = 17.5; % um 
cell_length = 164;  % um
Vcell = pi*cell_radius*cell_radius*cell_length*1e-9; % convert from cubic micrometer to uL
geometric_membraneArea = 1.9957e-4; %(cm^2)
Rcg = 1;
% Cell geometry
Acap= Rcg*geometric_membraneArea; % capacitive membrane area (cm^2)

% Shell geometry
r_ss = tubulation_factor*cell_radius;
n_shells = 80; 
r = linspace(cell_radius, 0, (n_shells + 1));
dr = r(1) - r(2); %um
area = pi*r.*r;
for i = 1: n_shells
    shell_area(i) = area(i) - area(i+1);
end
area_ratios = shell_area./ sum(shell_area);
n_shells_ss = 0;
for i = 1: n_shells
    if( r(i) > r_ss)
        n_shells_ss = n_shells_ss + 1;
    end
end
n_shells_int = n_shells -  n_shells_ss;
%%
NFRU_sim = 2500;
shell_count = round(NFRU_sim.*(area_ratios));
NFRU_scale      = 12500./shell_count;
N_ss            = sum(shell_count(1:n_shells_ss)); % Number of CRU's in the sarcolemmal space
cru_start       = zeros(1, n_shells);
cru_end         = zeros(1, n_shells);
cru_start(1)    = 1;
cru_end(1)      = shell_count(1);
for s = 2:n_shells
    cru_start(s) = cru_end(s-1) + 1;
    cru_end(s) = cru_start(s) + shell_count(s)-1;
end

%% Specify compartmental volumes
VNSRtot      = 0.035*Vcell; % Network SR volume (uL)
Vmyotot      = 0.8*Vcell; % myoplasmic volume (uL)
VNSR   =  VNSRtot.*area_ratios;
Vmyo   =  Vmyotot.*area_ratios;
VSStot = 9.82e-05*Vmyo(1); % subspace volume (uL) 
VJSRtot = 0.25*VNSR(1);
VSS  =  VSStot/shell_count(1);
VJSR =  VJSRtot/shell_count(1);
VCSR= 2.777042242067234e-11; % network SR volume (uL)
VCSRtot = VCSR.*shell_count(n_shells_ss:end);
%% Double the interior SR volume 
%VNSR(1:n_shells_ss) = SR_factor.*VNSR(1:n_shells_ss);
VNSR(n_shells_ss+1:end) = SR_factor.*VNSR(n_shells_ss+1:end);


%% Specify simulation parameters

%freq       = 1;
ISI        = 1000/freq; %ms
time_start = 0.0;
time_end = num_beats*ISI;
%time_end = 3000; % ms
tstep    = 0.01;
% AP Clamp
global pulse_duration pulse_amplitude  period shift
pulse_duration = 0.5;
pulse_amplitude = -100.0;
period = 1000.0;
shift = 5.0;
 
% Define parameters for voltage clamp.
global vclamp_flag vclamp_duration vclamp_set vclamp_shift vclamp_hold vclamp_period
vclamp_flag = 1;
vclamp_duration = 200.0;
vclamp_set      =   0.0;
vclamp_shift    =  10.0;
vclamp_hold     =  -100.0;
vclamp_period   = ISI;
 
%% Specify input and output files
% Define input files
% Use 0 for default, 1  if you have initial conditions from tubulated model
% and 2 if you have initial conditions from detubulated model 
 
if(ic_clamp == 1)
    input_dir = 'ic/vclamp';
    ic_states_file = strcat(input_dir,'/','ic_states_NVC.txt');
    ic_FRU_file = strcat(input_dir, '/','ic_FRU_NVC.txt');
    ic_LCh_file = strcat(input_dir,'/','ic_LCh_NVC.txt');
    ic_RyR_file = strcat(input_dir,'/','ic_RyR_NVC.txt');
    ic_Ito2_file = strcat(input_dir,'/','ic_Ito2_NVC.txt');
else
    if(ic_clamp==2)       
        input_dir = strcat('Freq_',num2str(freq),'Hz_NSRint_',num2str(SR_factor),'X_SERCA_',num2str(KSR_factor),'X_vmaxr_',num2str(vmaxr_factor),'X_k52mod_KeizerLevine_nshells_80');
        ic_states_file = strcat(input_dir,'/','ic_states_',num2str(freq) ,'Hz.txt');
        ic_FRU_file = strcat(input_dir, '/','ic_FRU_',num2str(freq) ,'Hz.txt');
        ic_LCh_file = strcat(input_dir,'/','ic_LCh_',num2str(freq) ,'Hz.txt');
        ic_RyR_ss_file = strcat(input_dir,'/','ic_RyR_ss_',num2str(freq) ,'Hz.txt');
        ic_RyR_int_file = strcat(input_dir,'/','ic_RyR_int_',num2str(freq) ,'Hz.txt');
        ic_CaCSR_file = strcat(input_dir,'/','ic_CaCSR_',num2str(freq) ,'Hz.txt');
        ic_O1_RyR_file = strcat(input_dir,'/','ic_O1_RyR_',num2str(freq) ,'Hz.txt');
        ic_O2_RyR_file = strcat(input_dir,'/','ic_O2_RyR_',num2str(freq) ,'Hz.txt');
        ic_C1_RyR_file = strcat(input_dir,'/','ic_C1_RyR_',num2str(freq) ,'Hz.txt');
        ic_C2_RyR_file = strcat(input_dir,'/','ic_C2_RyR_',num2str(freq) ,'Hz.txt');
        ic_Cai_file = strcat(input_dir,'/','ic_Cai_',num2str(freq) ,'Hz.txt');
        ic_CaNSR_file = strcat(input_dir,'/','ic_CaNSR_',num2str(freq) ,'Hz.txt');
        ic_LTRPNCa_file = strcat(input_dir,'/','ic_LTRPNCa_',num2str(freq) ,'Hz.txt');
        ic_HTRPNCa_file = strcat(input_dir,'/','ic_HTRPNCa_',num2str(freq) ,'Hz.txt');
        ic_Ito2_file = strcat(input_dir,'/','ic_Ito2_',num2str(freq) ,'Hz.txt');
    end
end
 
 % Define output files
% output_dir           = 'Diff_0_7';


output_states_file   = strcat(output_dir,'/','states', num2str(filenumber),'.txt');
output_currents_file = strcat(output_dir,'/','currents', num2str(filenumber),'.txt');
output_otherstates_file = strcat(output_dir,'/','otherstates', num2str(filenumber),'.txt');
output_Cai_file = strcat(output_dir,'/','Cai', num2str(filenumber),'.txt');
output_CaNSR_file = strcat(output_dir,'/','CaNSR', num2str(filenumber),'.txt');
output_CaCSR_file = strcat(output_dir,'/','CaCSR', num2str(filenumber),'.txt');
output_LTRPNCa_file = strcat(output_dir,'/','LTRPNCa', num2str(filenumber),'.txt');
output_HTRPNCa_file = strcat(output_dir,'/','HTRPNCa', num2str(filenumber),'.txt');
output_RyR_SS_file = strcat(output_dir,'/','RyR_SS',num2str(filenumber),'.txt');
output_O1RyR_file = strcat(output_dir,'/','O1_RyR',num2str(filenumber),'.txt');
output_O2RyR_file = strcat(output_dir,'/','O2_RyR',num2str(filenumber),'.txt');
output_C1RyR_file = strcat(output_dir,'/','C1_RyR',num2str(filenumber),'.txt');
output_C2RyR_file = strcat(output_dir,'/','C2_RyR',num2str(filenumber),'.txt');

fileID = fopen(output_states_file, 'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s \n', ...
    'Time','V','mNa','hNa','jNa','Nai','Ki','Cai','CaNSR','xKs', ...
    'LTRPNCa','HTRPNCa','C0Kv43','C1Kv43','C2Kv43','C3Kv43','OKv43','CI0Kv43','CI1Kv43','CI2Kv43', ...
    'CI3Kv43','OIKv43','C0Kv14','C1Kv14','C2Kv14','C3Kv14','OKv14','CI0Kv14','CI1Kv14','CI2Kv14', ...
    'CI3Kv14','OIKv14','CaToT','C1Herg','C2Herg','C3Herg','OHerg','IHerg');
fclose(fileID);  
fileID = fopen(output_currents_file, 'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s \n', ...
    'Time','INa','IKr','IKs','Ito1','IK1','IKp','INaCa','INaK','IpCa', ...
    'ICab','INab','ICa','JDHPR','Jup','Jtrpn','Jtr','Jxfer','IKv43','IKv14', ...
    'IKv14_K','IKv14_Na','Ito2','Istim','Itot');
fclose(fileID);

fileID = fopen(output_otherstates_file, 'w');

fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s \n', ...
        'Time','CaSSavg','CaJSRavg','JRyRtot','PRyR_open','PRyR_ready','PNorm_mode','PnotVinact','PLType_open','PIto2_open');
fclose(fileID);
%fileID = fopen(output_Cai_file,'w');
%fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s\n', ...
%         'Time','1','2','3','4','5','6','7','8','9','10');
%fclose(fileID);
%fileID = fopen(output_CaNSR_file,'w');
%fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s\n', ...
%         'Time','1','2','3','4','5','6','7','8','9','10');
%fclose(fileID);
%fileID = fopen(output_LTRPNCa_file,'w');
%fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s\n', ...
%         'Time','1','2','3','4','5','6','7','8','9','10');
%fclose(fileID);
%fileID = fopen(output_HTRPNCa_file,'w');
%fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s\n', ...
%         'Time','1','2','3','4','5','6','7','8','9','10');
% fclose(fileID);

fileID = fopen(output_Cai_file,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72','73','74','75','76','77','78','79','80');
fclose(fileID);
fileID = fopen(output_CaNSR_file,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72','73','74','75','76','77','78','79','80');
fclose(fileID);
fileID = fopen(output_LTRPNCa_file,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72','73','74','75','76','77','78','79','80');
fclose(fileID);
fileID = fopen(output_HTRPNCa_file,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72','73','74','75','76','77','78','79','80');
fclose(fileID);
fileID = fopen(output_RyR_SS_file,'w');
fprintf(fileID,'%s %s %s %s %s %s %s %s %s',...
        'Time','1','2','3','4','5','6','7','8');
fclose(fileID);
fileID = fopen(output_O1RyR_file ,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72');
fclose(fileID);
fileID = fopen(output_O2RyR_file ,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72');
fclose(fileID);
fileID = fopen(output_C1RyR_file ,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72');
fclose(fileID);
fileID = fopen(output_C2RyR_file ,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72');
fclose(fileID);
fileID = fopen(output_CaCSR_file ,'w');
fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...
        'Time','1','2','3','4','5','6','7','8','9','10',...
        '11','12','13','14','15','16','17','18','19','20',...
        '21','22','23','24','25','26','27','28','29','30',...
        '31','32','33','34','35','36','37','38','39','40',...
        '41','42','43','44','45','46','47','48','49','50',...
        '51','52','53','54','55','56','57','58','59','60',...
        '61','62','63','64','65','66','67','68','69','70',...
        '71','72');
fclose(fileID);

%% Initialize state variables and gates
onez = gpuArray.ones(NFRU_sim,1,'double');
onez_SS = gpuArray.ones(N_ss,1,'double');
onez_int = gpuArray.ones((NFRU_sim - N_ss),1,'double');
zeroz_int = gpuArray.zeros((NFRU_sim - N_ss),1,'double');
index_V = 1;
index_Cai       = 7;
index_CaNSR     = 8;
index_LTRPNCa   = 10;
index_HTRPNCa   = 11;

index_CaSSavg  = 1;
index_CaJSRavg = 2;
index_JRyRtot  = 3;
index_PRyR_Open = 4;
index_PRyR_ready = 5;
index_PNorm_Mode = 6;
index_PVinact = 7;
index_PLtype_Open = 8;
index_PIto2_Open = 9;

if(ic_clamp ~= 2)
    if(ic_clamp==1) % Reading in data from the tubulated model
        [state, FRU_state, LType_state, RyR_state, Ito2_state] = initialize(ic_states_file, ic_FRU_file, ic_LCh_file,ic_RyR_file,ic_Ito2_file);
        if(iscolumn(state))
            state = state';
        end
    else
        % Default parameters
        state = [ -100.0100   1.21087e-4    0.999484    0.999480      10.0000     133.24    1.11074e-4   0.72873    0.104829e-3    0.1003...
                     0.9780      0.968277     0.0133601   0.691875e-4   0.159092e-6 0.0     0.0153235    0.00271424   0.243515e-3 ...
                     0.115007e-4    0.163239e-6 0.824239    0.0522865   0.00124396  0.131359e-4 0.522383e-7 0.118010    0.003334011 0.684631e-3...
                     0.136717e-3 0.451249e-4 0.6810488214E+01   0.990   0.008   0.002   0.0     0.0];
        LType_state = zeros(N_ss, Nclefts_FRU,Nindepstates_LType);
        FRU_state = horzcat( 0.728921.*ones(N_ss,1), 0.111074e-3.*ones(N_ss, Nclefts_FRU));
        RyR_state = ones(NFRU_sim, Nclefts_FRU, NRyRs_per_cleft);
        Ito2_state = ones(N_ss, Nclefts_FRU);
        LType_state(:,:,1) = ones(N_ss, Nclefts_FRU);
        LType_state(:,:,2) = 2.*ones(N_ss, Nclefts_FRU);  
    end
    CaiArray   = state(index_Cai).*ones(1, n_shells);
    CaNSRArray = state(index_CaNSR).*ones(1, n_shells);
    LTRPNCaArray = state(index_LTRPNCa).*ones(1, n_shells);
    HTRPNCaArray = state(index_HTRPNCa).*ones(1, n_shells);
    O1_RyR = 7.516e-5.*ones(1,n_shells_int);
    O2_RyR = 1.749e-11.*zeros(1,n_shells_int);
    C1_RyR = 9.366e-1.*ones(1,n_shells_int);
    C2_RyR = ones(1,n_shells_int) - O1_RyR - O2_RyR - C1_RyR;
    
    
    LCC1 = LType_state(:,1,1).*onez_SS;
    LCC2 = LType_state(:,2,1).*onez_SS;
    LCC3 = LType_state(:,3,1).*onez_SS;
    LCC4 = LType_state(:,4,1).*onez_SS;

    Y1 = LType_state(:,1,2).*onez_SS;
    Y2 = LType_state(:,2,2).*onez_SS;
    Y3 = LType_state(:,3,2).*onez_SS;
    Y4 = LType_state(:,4,2).*onez_SS;

    Ito2_1 = Ito2_state(:,1).*onez_SS;
    Ito2_2 = Ito2_state(:,2).*onez_SS;
    Ito2_3 = Ito2_state(:,3).*onez_SS;
    Ito2_4 = Ito2_state(:,4).*onez_SS;

    RyR11_ss = RyR_state((1:N_ss),1,1).*onez_SS;
    RyR12_ss = RyR_state((1:N_ss),1,2).*onez_SS;
    RyR13_ss = RyR_state((1:N_ss),1,3).*onez_SS;
    RyR14_ss = RyR_state((1:N_ss),1,4).*onez_SS;
    RyR15_ss = RyR_state((1:N_ss),1,5).*onez_SS;

    RyR21_ss = RyR_state((1:N_ss),2,1).*onez_SS;
    RyR22_ss = RyR_state((1:N_ss),2,2).*onez_SS;
    RyR23_ss = RyR_state((1:N_ss),2,3).*onez_SS;
    RyR24_ss = RyR_state((1:N_ss),2,4).*onez_SS;
    RyR25_ss = RyR_state((1:N_ss),2,5).*onez_SS;

    RyR31_ss = RyR_state((1:N_ss),3,1).*onez_SS;
    RyR32_ss = RyR_state((1:N_ss),3,2).*onez_SS;
    RyR33_ss = RyR_state((1:N_ss),3,3).*onez_SS;
    RyR34_ss = RyR_state((1:N_ss),3,4).*onez_SS;
    RyR35_ss = RyR_state((1:N_ss),3,5).*onez_SS;

    RyR41_ss = RyR_state((1:N_ss),4,1).*onez_SS;
    RyR42_ss = RyR_state((1:N_ss),4,2).*onez_SS;
    RyR43_ss = RyR_state((1:N_ss),4,3).*onez_SS;
    RyR44_ss = RyR_state((1:N_ss),4,4).*onez_SS;
    RyR45_ss = RyR_state((1:N_ss),4,5).*onez_SS;

%     RyR11_int = onez_int;
%     RyR12_int = onez_int;
%     RyR13_int = onez_int;
%     RyR14_int = onez_int;
%     RyR15_int = onez_int;
% 
%     RyR21_int = onez_int;
%     RyR22_int = onez_int;
%     RyR23_int = onez_int;
%     RyR24_int = onez_int;
%     RyR25_int = onez_int;
% 
%     RyR31_int = onez_int;
%     RyR32_int = onez_int;
%     RyR33_int = onez_int;
%     RyR34_int = onez_int;
%     RyR35_int = onez_int;
% 
%     RyR41_int = onez_int;
%     RyR42_int = onez_int;
%     RyR43_int = onez_int;
%     RyR44_int = onez_int;
%     RyR45_int = onez_int;

    CaJSR   = FRU_state(:,1).*onez_SS;
%     CaCSR   = FRU_state(1,1).*onez_int;
    CaCSR = CaNSRArray(n_shells_ss+1:n_shells);
    [CaSS1, CaSS2, CaSS3, CaSS4] = arrayfun(@calc_local_states, state(index_V).*onez_SS,state(index_Cai).*onez_SS,CaJSR, ...
                                            LCC1,LCC2, LCC3,LCC4,Y1, Y2, Y3, Y4,...
                                            RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss,...
                                            RyR21_ss, RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss,...
                                            RyR31_ss, RyR32_ss, RyR33_ss, RyR34_ss, RyR35_ss,...
                                            RyR41_ss, RyR42_ss, RyR43_ss, RyR44_ss, RyR45_ss);
else
   
   [ state, FRU_state,CaCSR, LType_state, RyR_ss_state,...
           RyR_int_state, Ito2_state,CaiArray,CaNSRArray, LTRPNCaArray,...
           HTRPNCaArray,O1_RyR,O2_RyR,C1_RyR,C2_RyR] = initialize2(ic_states_file, ic_FRU_file,...
                                       ic_LCh_file,ic_RyR_int_file,ic_Ito2_file,...
                                       ic_RyR_ss_file, ic_Cai_file, ic_CaNSR_file,ic_CaCSR_file,...
                                       ic_HTRPNCa_file, ic_LTRPNCa_file,ic_O1_RyR_file,ic_O2_RyR_file,...
                                       ic_C1_RyR_file,ic_C2_RyR_file);
    if(iscolumn(state))
	state = state';
    end
    LCC1 = LType_state(:,1,1).*onez_SS;
    LCC2 = LType_state(:,2,1).*onez_SS;
    LCC3 = LType_state(:,3,1).*onez_SS;
    LCC4 = LType_state(:,4,1).*onez_SS;

    Y1 = LType_state(:,1,2).*onez_SS;
    Y2 = LType_state(:,2,2).*onez_SS;
    Y3 = LType_state(:,3,2).*onez_SS;
    Y4 = LType_state(:,4,2).*onez_SS;

    Ito2_1 = Ito2_state(:,1).*onez_SS;
    Ito2_2 = Ito2_state(:,2).*onez_SS;
    Ito2_3 = Ito2_state(:,3).*onez_SS;
    Ito2_4 = Ito2_state(:,4).*onez_SS;

    RyR11_ss = RyR_ss_state(:,1,1).*onez_SS;
    RyR12_ss = RyR_ss_state(:,1,2).*onez_SS;
    RyR13_ss = RyR_ss_state(:,1,3).*onez_SS;
    RyR14_ss = RyR_ss_state(:,1,4).*onez_SS;
    RyR15_ss = RyR_ss_state(:,1,5).*onez_SS;

    RyR21_ss = RyR_ss_state(:,2,1).*onez_SS;
    RyR22_ss = RyR_ss_state(:,2,2).*onez_SS;
    RyR23_ss = RyR_ss_state(:,2,3).*onez_SS;
    RyR24_ss = RyR_ss_state(:,2,4).*onez_SS;
    RyR25_ss = RyR_ss_state(:,2,5).*onez_SS;

    RyR31_ss = RyR_ss_state(:,3,1).*onez_SS;
    RyR32_ss = RyR_ss_state(:,3,2).*onez_SS;
    RyR33_ss = RyR_ss_state(:,3,3).*onez_SS;
    RyR34_ss = RyR_ss_state(:,3,4).*onez_SS;
    RyR35_ss = RyR_ss_state(:,3,5).*onez_SS;

    RyR41_ss = RyR_ss_state(:,4,1).*onez_SS;
    RyR42_ss = RyR_ss_state(:,4,2).*onez_SS;
    RyR43_ss = RyR_ss_state(:,4,3).*onez_SS;
    RyR44_ss = RyR_ss_state(:,4,4).*onez_SS;
    RyR45_ss = RyR_ss_state(:,4,5).*onez_SS;

%     RyR11_int = RyR_int_state(:,1,1).*onez_int;
%     RyR12_int = RyR_int_state(:,1,2).*onez_int;
%     RyR13_int = RyR_int_state(:,1,3).*onez_int;
%     RyR14_int = RyR_int_state(:,1,4).*onez_int;
%     RyR15_int = RyR_int_state(:,1,5).*onez_int;
% 
%     RyR21_int = RyR_int_state(:,2,1).*onez_int;
%     RyR22_int = RyR_int_state(:,2,2).*onez_int;
%     RyR23_int = RyR_int_state(:,2,3).*onez_int;
%     RyR24_int = RyR_int_state(:,2,4).*onez_int;
%     RyR25_int = RyR_int_state(:,2,5).*onez_int;
% 
%     RyR31_int = RyR_int_state(:,3,1).*onez_int;
%     RyR32_int = RyR_int_state(:,3,2).*onez_int;
%     RyR33_int = RyR_int_state(:,3,3).*onez_int;
%     RyR34_int = RyR_int_state(:,3,4).*onez_int;
%     RyR35_int = RyR_int_state(:,3,5).*onez_int;
% 
%     RyR41_int = RyR_int_state(:,4,1).*onez_int;
%     RyR42_int = RyR_int_state(:,4,2).*onez_int;
%     RyR43_int = RyR_int_state(:,4,3).*onez_int;
%     RyR44_int = RyR_int_state(:,4,4).*onez_int;
%     RyR45_int = RyR_int_state(:,4,5).*onez_int;
    
    CaJSR   = FRU_state(:,1).*onez_SS;
    [CaSS1, CaSS2, CaSS3, CaSS4] = arrayfun(@calc_local_states, state(index_V).*onez_SS,state(index_Cai).*onez_SS,CaJSR, ...
                                            LCC1,LCC2, LCC3,LCC4,Y1, Y2, Y3, Y4,...
                                            RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss,...
                                            RyR21_ss, RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss,...
                                            RyR31_ss, RyR32_ss, RyR33_ss, RyR34_ss, RyR35_ss,...
                                            RyR41_ss, RyR42_ss, RyR43_ss, RyR44_ss, RyR45_ss);
%      CaCSR   = CaCSR_CPU.*onez_int;
end

%% Set up arrays to store simulation data
global N Ncur Nother
N = 37;
Ncur = 24;
Nother = 12;
currents     = zeros(Ncur,1);
otherstates = zeros(Nother,1);
Fstate = zeros(N,1);
ii = 1;
saveinterval = 1;
fprintf('Time \t Voltage \t Cai \t Nai\n');

JMyodiff_Array = [];
JNSRdiff_Array = [];
Jup_Array = [];
Jtrpn_Array = [];
JRyRint_Array = [];
Jtrint_Array = [];
Jxfer_Array = [];
Jtr_Array = [];
JRyR_SS_Array = [];
%% Main loop
for time = time_start:tstep:time_end
    index_V = 1;
     if(mod(time,1)==0)
        fprintf('%g \t %g \t %g \t %g\n',time, state(1), state(7), state(5));
     end
     if(vclamp_flag == 1)
      time_vclamp_on = floor((time-vclamp_shift)/vclamp_period)*vclamp_period;
	  time_vclamp_off = time_vclamp_on + vclamp_duration;
          if (((time-vclamp_shift) >= time_vclamp_on)  && (time_vclamp_on>=0.0) && ((time-vclamp_shift) < time_vclamp_off)) 
              % Change the ramp time to 5 ms
             ramp = (((time-vclamp_shift)-time_vclamp_on)/2.0)*(vclamp_set-vclamp_hold) + vclamp_hold;
                  if (vclamp_hold<=vclamp_set) 
                    state(index_V) = min(vclamp_set,ramp); % depol.  steps
                  else 
                    state(index_V) = max(vclamp_set,ramp); % hyperpol. steps
                  end
               %state(index_V) = vclamp_set;
          else 
              if (((time-vclamp_shift)<time_vclamp_on)||(time_vclamp_on<0.0)) 
                  state(index_V) = vclamp_hold;
              else 
                   ramp = vclamp_set +((time_vclamp_on + vclamp_duration-(time-vclamp_shift))/2.0)*(vclamp_set-vclamp_hold);
                   if (vclamp_hold<=vclamp_set) 
                      state(index_V) = max(vclamp_hold,ramp); % depol. step
                   else 
                      state(index_V) = min(vclamp_hold,ramp); % hyper. step
                   end
              end
                %state(index_V) = vclamp_hold;
          end
     end
     
     % Calculate the derivatives
%      FRUdep_states(1) = state(1);
%      FRUdep_states(2) = state(7); 
%      FRUdep_states(3) = state(8);
      
     %[dFRU_state, Jxfer, Jtr, ICa, Ito2]  = calc_fru_local(FRUdep_states,FRU_state, Ltype_state, RyR_state,Ito2_state);
     % Calculate  the state derivatives    
     
     [dCaJSR, Jtr_local,ICa_local, Ito2_local,Jxfer_local,JRyR_SS_local] = arrayfun(@calc_dCaJSR,state(index_V).*onez_SS,state(index_Cai).*onez_SS, state(index_CaNSR).*onez_SS,...
                                     CaJSR, CaSS1,CaSS2, CaSS3, CaSS4, RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss,...
                                     RyR21_ss, RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss, RyR31_ss, RyR32_ss, RyR33_ss, RyR34_ss, RyR35_ss, RyR41_ss, RyR42_ss,...
                                     RyR43_ss, RyR44_ss, RyR45_ss, LCC1, LCC2,LCC3, LCC4, Y1, Y2, Y3, Y4, Ito2_1, Ito2_2, Ito2_3, Ito2_4);
     Jtr = zeros(1, n_shells_ss);
     ICa = zeros(1,n_shells_ss);
     Ito2 = zeros(1,n_shells_ss);
     Jxfer = zeros(1,n_shells_ss);
     JRyR_SS = zeros(1,n_shells_ss);
     for s = 1:n_shells_ss
         Jtr(s)   = gather(sum(Jtr_local(cru_start(s):cru_end(s))));
         ICa(s)   = gather(sum(ICa_local(cru_start(s):cru_end(s))));
         Ito2(s)  =gather(sum(Ito2_local(cru_start(s):cru_end(s))));
         Jxfer(s) = gather(sum(Jxfer_local(cru_start(s):cru_end(s)))); 
         JRyR_SS(s) = gather(sum(JRyR_SS_local(cru_start(s):cru_end(s))));
     end
     % Calculate the dervatives in the sarcolemmal shell

     [state, Fstate, currents] = calc_derivative(time, state, currents, Jxfer(1), Jtr(1), ICa(1), Ito2(1));
     % Calculate RyR flux in the interior shells
%      Cai_GPU = [];
%      CaNSR_GPU = [];
%      for s = n_shells_ss + 1:n_shells
%          Cai_GPU = [Cai_GPU; repmat(CaiArray(s),shell_count(s),1)];
%          CaNSR_GPU = [CaNSR_GPU;
%          repmat(CaNSRArray(s),shell_count(s),1)]
%      end
%      Cai_GPU = Cai_GPU.*onez_int;
%      CaNSR_GPU = CaNSR_GPU.*onez_int;
%      [dCaCSR, Jtr_local, JRyR_local, NRyR_open1, NRyR_open2, NRyR_open3, NRyR_open4 ] = arrayfun(@calc_dCaCSR, Cai_GPU, CaNSR_GPU, CaCSR, RyR11_int, RyR12_int, RyR13_int, RyR14_int, RyR15_int,...
%                                      RyR21_int, RyR22_int, RyR23_int, RyR24_int, RyR25_int, RyR31_int, RyR32_int, RyR33_int,...
%                                      RyR34_int, RyR35_int, RyR41_int, RyR42_int,...
%                                      RyR43_int, RyR44_int, RyR45_int);
 
    CSQNtot= 13.5; 
    KmCSQN=   0.63; 
    JRyRmax= (0.6*1.5*1.1*3.96);
    tautr= 3.0;
      

%      v1	      = 1.8*1.5;
%      tautr	  = 0.5747;
     NRyRopen = (O1_RyR+O2_RyR).*(NRyRs_per_cleft*Nclefts_FRU);
     JRyR_int = JRyRmax.*NRyRopen.*(CaCSR-CaiArray(n_shells_ss+1:n_shells));
     Jtr_int  = ((CaNSRArray(n_shells_ss+1:n_shells) - CaCSR))./tautr;
%     JRyR_int = zeros(n_shells - n_shells_ss,1)';
%     Jtr_int = zeros(n_shells - n_shells_ss,1)';

%      for s = n_shells_ss+1:n_shells
%          Jtr_int(s-n_shells_ss) =  gather(sum(Jtr_local((cru_start(s) - N_ss): (cru_end(s) - N_ss))));
%          JRyR_int(s-n_shells_ss) = gather(sum(JRyR_local((cru_start(s) - N_ss): (cru_end(s) - N_ss))));
%      end
     subsarc_state(1) = state(1);
     subsarc_state(2) = state(5);
    [dCaiArray, dCaNSRArray,dCaCSR, dLTRPNCaArray, dHTRPNCaArray,dO1_RyR, dO2_RyR, dC1_RyR,...
     dC2_RyR, JMyo_diff, JNSR_diff, Jup, Jtrpn] = ...
     calc_derivative_int(CaiArray, CaNSRArray,CaCSR, LTRPNCaArray, HTRPNCaArray,subsarc_state,...
     Jtr, Jxfer, Jtr_int, JRyR_int, C1_RyR,C2_RyR, O1_RyR, O2_RyR);
     Fstate(index_Cai) = dCaiArray(1);
     Fstate(index_CaNSR) = dCaNSRArray(1);
     
     % Write currents states into file
     if(mod(time,saveinterval) == 0)
         fileID = fopen(output_states_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_states_file, state,'-append','delimiter',' ')
         fclose(fileID);

         fileID = fopen(output_Cai_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_Cai_file, CaiArray,'-append','delimiter',' ')
         fclose(fileID);
         
         fileID = fopen(output_CaNSR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_CaNSR_file, CaNSRArray,'-append','delimiter',' ')
         fclose(fileID);
         
         fileID = fopen(output_LTRPNCa_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_LTRPNCa_file, LTRPNCaArray,'-append','delimiter',' ')
         fclose(fileID);
         
        fileID = fopen(output_HTRPNCa_file, 'a');
        fprintf(fileID, '%d %s', time,' ');
        dlmwrite(output_HTRPNCa_file, HTRPNCaArray,'-append','delimiter',' ')
        fclose(fileID);
         
         fileID = fopen(output_CaCSR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_CaCSR_file, CaCSR,'-append','delimiter',' ')
         fclose(fileID);
        
         fileID = fopen(output_O1RyR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_O1RyR_file, O1_RyR,'-append','delimiter',' ')
         fclose(fileID);
         
         fileID = fopen(output_O2RyR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_O2RyR_file, O2_RyR,'-append','delimiter',' ')
         fclose(fileID);
         
         fileID = fopen(output_C1RyR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_C1RyR_file, C1_RyR,'-append','delimiter',' ')
         fclose(fileID);
         
         fileID = fopen(output_C2RyR_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_C2RyR_file, C2_RyR,'-append','delimiter',' ')
         fclose(fileID);
         
        % Populate currents file and otherstates file
        fileID = fopen(output_currents_file, 'a');
        fprintf(fileID,'%d %s',time,' ');
        dlmwrite(output_currents_file, currents','-append','delimiter',' ')
        fclose(fileID);
        [N11,N12,N13,N14,N15,N16,N17,N18] = arrayfun(@RyR_occupancy_ss,RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss);
        [N21,N22,N23,N24,N25,N26,N27,N28] = arrayfun(@RyR_occupancy_ss,RyR21_ss, RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss);
        [N31,N32,N33,N34,N35,N36,N37,N38] = arrayfun(@RyR_occupancy_ss,RyR31_ss, RyR32_ss, RyR33_ss, RyR34_ss, RyR35_ss);
        [N41,N42,N43,N44,N45,N46,N47,N48] = arrayfun(@RyR_occupancy_ss,RyR41_ss, RyR42_ss, RyR43_ss, RyR44_ss, RyR45_ss);
        [LO1, LN1, LI1, LO2, LN2, LI2, LO3,LN3, LI3, LO4, LN4, LI4] = arrayfun(@LType_open_prob, LCC1, LCC2, LCC3, LCC4, Y1, Y2, Y3, Y4);
        [I1, I2, I3, I4] = arrayfun(@Ito2_open_prob, Ito2_1, Ito2_2,Ito2_3, Ito2_4);
        
        N1 = N11 + N21 + N31 + N41;
        N2 = N12 + N22 + N32 + N42;
        N3 = N13 + N23 + N33 + N43;
        N4 = N14 + N24 + N34 + N44;
        N5 = N15 + N25 + N35 + N45;
        N6 = N16 + N26 + N36 + N46;
        N7 = N17 + N27 + N37 + N47;
        N8 = N18 + N28 + N38 + N48;
        RyR_occupancies_SS = zeros(1,8);
        RyR_occupancies_int = zeros(1,4);
        RyR_occupancies_SS(1) = gather(sum(N1));
        RyR_occupancies_SS(2) = gather(sum(N2));
        RyR_occupancies_SS(3) = gather(sum(N3));
        RyR_occupancies_SS(4) = gather(sum(N4));
        RyR_occupancies_SS(5) = gather(sum(N5));
        RyR_occupancies_SS(6) = gather(sum(N6));
        RyR_occupancies_SS(7) = gather(sum(N7));
        RyR_occupancies_SS(8) = gather(sum(N8));

%         [N11,N12,N13,N14] = arrayfun(@RyR_occupancy_int,RyR11_int, RyR12_int, RyR13_int, RyR14_int, RyR15_int);
%         [N21,N22,N23,N24] = arrayfun(@RyR_occupancy_int,RyR21_int, RyR22_int, RyR23_int, RyR24_int, RyR25_int);
%         [N31,N32,N33,N34] = arrayfun(@RyR_occupancy_int,RyR31_int, RyR32_int, RyR33_int, RyR34_int, RyR35_int);
%         [N41,N42,N43,N44] = arrayfun(@RyR_occupancy_int,RyR41_int, RyR42_int, RyR43_int, RyR44_int, RyR45_int);
       
%         N1 = N11 + N21 + N31 + N41;
%         N2 = N12 + N22 + N32 + N42;
%         N3 = N13 + N23 + N33 + N43;
%         N4 = N14 + N24 + N34 + N44;
%         
%         RyR_occupancies_int(1) = gather(sum(N1));
%         RyR_occupancies_int(2) = gather(sum(N2));
%         RyR_occupancies_int(3) = gather(sum(N3));
%         RyR_occupancies_int(4) = gather(sum(N4));
        
         fileID = fopen(output_RyR_SS_file, 'a');
         fprintf(fileID, '%d %s', time,' ');
         dlmwrite(output_RyR_SS_file, RyR_occupancies_SS,'-append','delimiter',' ')
         fclose(fileID);
         
%          fileID = fopen(output_RyR_int_file, 'a');
%          fprintf(fileID, '%d %s', time,' ');
%          dlmwrite(output_RyR_int_file, RyR_occupancies_int,'-append','delimiter',' ')
%          fclose(fileID);
        
        P_RyR_occupancies_SS = RyR_occupancies_SS./(NFRU_sim*Nclefts_FRU*NRyRs_per_cleft);
        [JRyRtot] = arrayfun(@Calc_JRyR,CaJSR, CaSS1, CaSS2, CaSS3, CaSS4,RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss, RyR21_ss,...
                             RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss, RyR31_ss, RyR32_ss,RyR33_ss,...
                             RyR34_ss, RyR35_ss, RyR41_ss, RyR42_ss, RyR43_ss, RyR44_ss, RyR45_ss);
        otherstates(index_CaSSavg)  = (gather(sum(CaSS1)) + gather(sum(CaSS2)) + gather(sum(CaSS3)) +  gather(sum(CaSS4)))/(N_ss*Nclefts_FRU);
        otherstates(index_CaJSRavg) = gather(sum(CaJSR))/N_ss;
        otherstates(index_JRyRtot) = gather(sum(JRyRtot))*NFRU_scale(1)*VSS(1)/Vmyo(1);
        otherstates(index_PRyR_Open)  = (RyR_occupancies_SS(3) + RyR_occupancies_SS(4) + RyR_occupancies_SS(7))/(NRyRs_per_cleft*Nclefts_FRU*N_ss);
        otherstates(index_PRyR_ready)  = (RyR_occupancies_SS(1) + RyR_occupancies_SS(2))/(NRyRs_per_cleft*Nclefts_FRU*N_ss);
        otherstates(index_PNorm_Mode) = (gather(sum(LN1)) + gather(sum(LN2)) + gather(sum(LN3)) + gather(sum(LN4)))/(N_ss*Nclefts_FRU);
        otherstates(index_PVinact) = (gather(sum(LI1)) + gather(sum(LI2)) + gather(sum(LI3)) + gather(sum(LI4)))/(N_ss*Nclefts_FRU);
        otherstates(index_PLtype_Open) = (gather(sum(LO1)) + gather(sum(LO2)) + gather(sum(LO3)) + gather(sum(LO4)))/(N_ss*Nclefts_FRU);
        otherstates(index_PIto2_Open) = (gather(sum(I1)) + gather(sum(I2)) + gather(sum(I3)) + gather(sum(I4)))/(N_ss*Nclefts_FRU);
        
        fileID = fopen(output_otherstates_file,'a');
        fprintf(fileID, '%d %s', time,' ');
        dlmwrite(output_otherstates_file,otherstates' ,'-append','delimiter',' ')
        fclose(fileID);
        
        JMyodiff_Array = [JMyodiff_Array;JMyo_diff];
        JNSRdiff_Array = [JNSRdiff_Array; JNSR_diff];
        Jup_Array = [Jup_Array; Jup];
        Jtrpn_Array = [Jtrpn_Array; Jtrpn];
        JRyRint_Array = [JRyRint_Array; JRyR_int];
        Jtrint_Array = [Jtrint_Array;Jtr_int];
        Jxfer_Array = [Jxfer_Array; Jxfer];
        Jtr_Array = [Jtr_Array; Jtr];
        JRyR_SS_Array = [JRyR_SS_Array; JRyR_SS];
     end
    if(mod(time,ISI) == 0)
         file_save = strcat(output_dir,'/',filename);
         save(file_save, 'JMyodiff_Array', 'JNSRdiff_Array', 'Jup_Array', 'Jtrpn_Array', 'JRyRint_Array', 'Jtrint_Array', 'Jxfer_Array', 'Jtr_Array', 'JRyR_SS_Array');
            % Update the initial conditions file 
            ic_states_file = strcat(output_dir,'/','ic_states_',num2str(freq) ,'Hz.txt');
            ic_FRU_file = strcat(output_dir, '/','ic_FRU_',num2str(freq) ,'Hz.txt');
            ic_LCh_file = strcat(output_dir,'/','ic_LCh_',num2str(freq) ,'Hz.txt');
            ic_RyR_ss_file = strcat(output_dir,'/','ic_RyR_ss_',num2str(freq) ,'Hz.txt');
%             ic_RyR_int_file = strcat(output_dir,'/','ic_RyR_int_',num2str(freq) ,'Hz.txt');
            ic_CaCSR_file = strcat(output_dir,'/','ic_CaCSR_',num2str(freq) ,'Hz.txt');
            ic_Cai_file = strcat(output_dir,'/','ic_Cai_',num2str(freq) ,'Hz.txt');
            ic_CaNSR_file = strcat(output_dir,'/','ic_CaNSR_',num2str(freq) ,'Hz.txt');
            ic_LTRPNCa_file = strcat(output_dir,'/','ic_LTRPNCa_',num2str(freq) ,'Hz.txt');
            ic_HTRPNCa_file = strcat(output_dir,'/','ic_HTRPNCa_',num2str(freq) ,'Hz.txt');
            ic_Ito2_file = strcat(output_dir,'/','ic_Ito2_',num2str(freq) ,'Hz.txt');
            ic_O1_RyR_file = strcat(output_dir,'/','ic_O1_RyR_',num2str(freq) ,'Hz.txt');
            ic_O2_RyR_file = strcat(output_dir,'/','ic_O2_RyR_',num2str(freq) ,'Hz.txt');
            ic_C1_RyR_file = strcat(output_dir,'/','ic_C1_RyR_',num2str(freq) ,'Hz.txt');
            ic_C2_RyR_file = strcat(output_dir,'/','ic_C2_RyR_',num2str(freq) ,'Hz.txt');

            IC_state = state';

            IC_FRU_state(:,1) = gather(CaJSR);
            IC_FRU_state(:,2) = gather(CaSS1);
            IC_FRU_state(:,3) = gather(CaSS2);    
            IC_FRU_state(:,4) = gather(CaSS3);
            IC_FRU_state(:,5) = gather(CaSS4);

            IC_LCh(:,1) = int8(vertcat(gather(LCC1), gather(LCC2), gather(LCC3), gather(LCC4)));
            IC_LCh(:,2) = int8(vertcat(gather(Y1), gather(Y2), gather(Y3), gather(Y4)));

            IC_Ito2(:,1) = int8(vertcat(gather(Ito2_1), gather(Ito2_2), gather(Ito2_3), gather(Ito2_4)));

%             IC_RyR_int(:,1) = int8(vertcat(gather(RyR11_int),gather(RyR21_int), gather(RyR31_int), gather(RyR41_int)));
%             IC_RyR_int(:,2) = int8(vertcat(gather(RyR12_int),gather(RyR22_int), gather(RyR32_int), gather(RyR42_int)));
%             IC_RyR_int(:,3) = int8(vertcat(gather(RyR13_int),gather(RyR23_int), gather(RyR33_int), gather(RyR43_int)));
%             IC_RyR_int(:,4) = int8(vertcat(gather(RyR14_int),gather(RyR24_int), gather(RyR34_int), gather(RyR44_int)));
%             IC_RyR_int(:,5) = int8(vertcat(gather(RyR15_int),gather(RyR25_int), gather(RyR35_int), gather(RyR45_int)));

            IC_RyR_ss(:,1) = int8(vertcat(gather(RyR11_ss),gather(RyR21_ss), gather(RyR31_ss), gather(RyR41_ss)));
            IC_RyR_ss(:,2) = int8(vertcat(gather(RyR12_ss),gather(RyR22_ss), gather(RyR32_ss), gather(RyR42_ss)));
            IC_RyR_ss(:,3) = int8(vertcat(gather(RyR13_ss),gather(RyR23_ss), gather(RyR33_ss), gather(RyR43_ss)));
            IC_RyR_ss(:,4) = int8(vertcat(gather(RyR14_ss),gather(RyR24_ss), gather(RyR34_ss), gather(RyR44_ss)));
            IC_RyR_ss(:,5) = int8(vertcat(gather(RyR15_ss),gather(RyR25_ss), gather(RyR35_ss), gather(RyR45_ss)));

%             IC_CaCSR = gather(CaCSR);

            IC_Cai = CaiArray';
            IC_CaNSR = CaNSRArray';
            IC_LTRPNCa = LTRPNCaArray';
            IC_HTRPNCa = HTRPNCaArray';
            IC_CaCSR = CaCSR';
            IC_O1_RyR = O1_RyR';
            IC_O2_RyR = O2_RyR';
            IC_C1_RyR = C1_RyR';
            IC_C2_RyR = C2_RyR';
            

            save(ic_states_file,'IC_state','-ascii');
            save(ic_FRU_file,'IC_FRU_state','-ascii');
            save(ic_CaCSR_file,'IC_CaCSR','-ascii');

            fileID = fopen(ic_LCh_file,'w');
            fprintf(fileID, '%d \n',(N_ss*Nclefts_FRU));
            dlmwrite(ic_LCh_file,IC_LCh,'-append','delimiter',' ')
            fclose(fileID);

            fileID = fopen(ic_Ito2_file,'w');
            fprintf(fileID, '%d \n',(N_ss*Nclefts_FRU));
            dlmwrite(ic_Ito2_file,IC_Ito2,'-append','delimiter',' ')
            fclose(fileID);

            fileID = fopen(ic_RyR_ss_file,'w');
            fprintf(fileID, '%d \n',(N_ss*Nclefts_FRU));
            dlmwrite(ic_RyR_ss_file,IC_RyR_ss,'-append','delimiter',' ')
            fclose(fileID);

%             fileID = fopen(ic_RyR_int_file,'w');
%             fprintf(fileID, '%d \n',((NFRU_sim - N_ss)*Nclefts_FRU));
%             dlmwrite(ic_RyR_int_file,IC_RyR_int,'-append','delimiter',' ')
%             fclose(fileID);

            fileID = fopen(ic_Cai_file,'w');
            fprintf(fileID, '%d \n',n_shells);
            dlmwrite(ic_Cai_file,IC_Cai,'-append','delimiter',' ')
            fclose(fileID);

            fileID = fopen(ic_CaNSR_file,'w');
            fprintf(fileID, '%d \n',n_shells);
            dlmwrite(ic_CaNSR_file,IC_CaNSR,'-append','delimiter',' ')
            fclose(fileID);

            fileID = fopen(ic_LTRPNCa_file,'w');
            fprintf(fileID, '%d \n',n_shells);
            dlmwrite(ic_LTRPNCa_file,IC_LTRPNCa,'-append','delimiter',' ')
            fclose(fileID);

            fileID = fopen(ic_HTRPNCa_file,'w');
            fprintf(fileID, '%d \n',n_shells);
            dlmwrite(ic_HTRPNCa_file,IC_HTRPNCa,'-append','delimiter',' ')
            fclose(fileID);
            
            fileID = fopen(ic_CaCSR_file,'w');
            fprintf(fileID, '%d \n',n_shells);
            dlmwrite(ic_CaCSR_file,IC_CaCSR,'-append','delimiter',' ')
            fclose(fileID);
            
            fileID = fopen(ic_O1_RyR_file ,'w');
            fprintf(fileID,'%d \n',n_shells_int);
            dlmwrite(ic_O1_RyR_file,IC_O1_RyR,'-append','delimiter',' ')
            fclose(fileID);
            
            fileID = fopen(ic_O2_RyR_file ,'w');
            fprintf(fileID,'%d \n',n_shells_int);
            dlmwrite(ic_O2_RyR_file,IC_O2_RyR,'-append','delimiter',' ')
            fclose(fileID);
            
            fileID = fopen(ic_C1_RyR_file ,'w');
            fprintf(fileID,'%d \n',n_shells_int);
            dlmwrite(ic_C1_RyR_file,IC_C1_RyR,'-append','delimiter',' ')
            fclose(fileID);
            
            fileID = fopen(ic_C2_RyR_file ,'w');
            fprintf(fileID,'%d \n',n_shells_int);
            dlmwrite(ic_C2_RyR_file,IC_C2_RyR,'-append','delimiter',' ')
            fclose(fileID);
            

    end
    % Determine stochastic switching of the gates
    
    % Perform montecarlo sim
       
    rand1  = gpuArray.rand(N_ss,1,'single');
    rand2  = gpuArray.rand(N_ss,1,'single');
    rand3  = gpuArray.rand(N_ss,1,'single');
    rand4  = gpuArray.rand(N_ss,1,'single');
    rand5  = gpuArray.rand(N_ss,1,'single');
    rand6  = gpuArray.rand(N_ss,1,'single');
    rand7  = gpuArray.rand(N_ss,1,'single');
    rand8  = gpuArray.rand(N_ss,1,'single');
    rand9  = gpuArray.rand(N_ss,1,'single');
    rand10 = gpuArray.rand(N_ss,1,'single');
    rand11 = gpuArray.rand(N_ss,1,'single');
    rand12 = gpuArray.rand(N_ss,1,'single');

    rand13  = gpuArray.rand(N_ss,1,'single');
    rand14  = gpuArray.rand(N_ss,1,'single');
    rand15  = gpuArray.rand(N_ss,1,'single');
    rand16  = gpuArray.rand(N_ss,1,'single');
    rand17  = gpuArray.rand(N_ss,1,'single');
    rand18  = gpuArray.rand(N_ss,1,'single');
    rand19  = gpuArray.rand(N_ss,1,'single');
    rand20 = gpuArray.rand(N_ss,1,'single');
    rand21  = gpuArray.rand(N_ss,1,'single');
    rand22 = gpuArray.rand(N_ss,1,'single');
    rand23 = gpuArray.rand(N_ss,1,'single');
    rand24 = gpuArray.rand(N_ss,1,'single');
    rand25 = gpuArray.rand(N_ss,1,'single');

    rand26  = gpuArray.rand(N_ss,1,'single');
    rand27  = gpuArray.rand(N_ss,1,'single');
    rand28  = gpuArray.rand(N_ss,1,'single');
    rand29  = gpuArray.rand(N_ss,1,'single');
    rand30  = gpuArray.rand(N_ss,1,'single');
    rand31  = gpuArray.rand(N_ss,1,'single');
    rand32  = gpuArray.rand(N_ss,1,'single');
    rand33 = gpuArray.rand(N_ss,1,'single');
    rand34  = gpuArray.rand(N_ss,1,'single');
    rand35 = gpuArray.rand(N_ss,1,'single');
    rand36 = gpuArray.rand(N_ss,1,'single');
    rand37 = gpuArray.rand(N_ss,1,'single');

    rand38  = gpuArray.rand(N_ss,1,'single');
    rand39  = gpuArray.rand(N_ss,1,'single');
    rand40  = gpuArray.rand(N_ss,1,'single');
    rand41  = gpuArray.rand(N_ss,1,'single');
    rand42  = gpuArray.rand(N_ss,1,'single');
    rand43  = gpuArray.rand(N_ss,1,'single');
    rand44  = gpuArray.rand(N_ss,1,'single');
    rand45 = gpuArray.rand(N_ss,1,'single');
    rand46  = gpuArray.rand(N_ss,1,'single');
    rand47 = gpuArray.rand(N_ss,1,'single');
    rand48 = gpuArray.rand(N_ss,1,'single');
    rand49 = gpuArray.rand(N_ss,1,'single');
    rand50 = gpuArray.rand(N_ss,1,'single');

    rand51  = gpuArray.rand(N_ss,1,'single');
    rand52  = gpuArray.rand(N_ss,1,'single');
    rand53  = gpuArray.rand(N_ss,1,'single');
    rand54  = gpuArray.rand(N_ss,1,'single');
    rand55  = gpuArray.rand(N_ss,1,'single');
    rand56  = gpuArray.rand(N_ss,1,'single');
    rand57  = gpuArray.rand(N_ss,1,'single');
    rand58  = gpuArray.rand(N_ss,1,'single');
    rand59  = gpuArray.rand(N_ss,1,'single');
    rand60 = gpuArray.rand(N_ss,1,'single');
    rand61 = gpuArray.rand(N_ss,1,'single');
    rand62 = gpuArray.rand(N_ss,1,'single');

    rand63  = gpuArray.rand(N_ss,1,'single');
    rand64  = gpuArray.rand(N_ss,1,'single');
    rand65  = gpuArray.rand(N_ss,1,'single');
    rand66  = gpuArray.rand(N_ss,1,'single');
    rand67  = gpuArray.rand(N_ss,1,'single');
    rand68  = gpuArray.rand(N_ss,1,'single');
    rand69  = gpuArray.rand(N_ss,1,'single');
    rand70 = gpuArray.rand(N_ss,1,'single');
    rand71  = gpuArray.rand(N_ss,1,'single');
    rand72 = gpuArray.rand(N_ss,1,'single');

    tempdt = tstep.*onez_SS;
    V = state(index_V);
    [LCC1, Y1, Ito2_1] = arrayfun( @new_Ltype, tempdt,V.*onez_SS,CaSS1, LCC1, Y1, Ito2_1, rand1, rand2, rand3);
    [LCC2, Y2, Ito2_2] = arrayfun( @new_Ltype, tempdt,V.*onez_SS,CaSS2, LCC2, Y2, Ito2_2, rand4, rand5, rand6);
    [LCC3, Y3, Ito2_3] = arrayfun( @new_Ltype, tempdt,V.*onez_SS,CaSS3, LCC3, Y3, Ito2_3, rand7, rand8, rand9);
    [LCC4, Y4, Ito2_4] = arrayfun( @new_Ltype, tempdt,V.*onez_SS,CaSS4, LCC4, Y4, Ito2_4, rand10, rand11, rand12);

    [RyR11_ss] = arrayfun( @switch_RyR, tempdt, CaSS1, RyR11_ss,rand13, rand14, rand15);
    [RyR12_ss] = arrayfun( @switch_RyR, tempdt, CaSS1, RyR12_ss,rand16, rand17, rand18);
    [RyR13_ss] = arrayfun( @switch_RyR, tempdt, CaSS1, RyR13_ss,rand19, rand20, rand21);
    [RyR14_ss] = arrayfun( @switch_RyR, tempdt, CaSS1, RyR14_ss, rand22, rand23, rand24);
    [RyR15_ss] = arrayfun( @switch_RyR, tempdt, CaSS1, RyR15_ss, rand25, rand26, rand27);

    [RyR21_ss] = arrayfun( @switch_RyR, tempdt, CaSS2, RyR21_ss,rand28, rand29, rand30);
    [RyR22_ss] = arrayfun( @switch_RyR, tempdt, CaSS2, RyR22_ss,rand31, rand32, rand33);
    [RyR23_ss] = arrayfun( @switch_RyR, tempdt, CaSS2, RyR23_ss,rand34, rand35, rand36);
    [RyR24_ss] = arrayfun( @switch_RyR, tempdt, CaSS2, RyR24_ss, rand37, rand38, rand39);
    [RyR25_ss] = arrayfun( @switch_RyR, tempdt, CaSS2, RyR25_ss, rand40, rand41, rand42);

    [RyR31_ss] = arrayfun( @switch_RyR, tempdt, CaSS3, RyR31_ss,rand43, rand44, rand45);
    [RyR32_ss] = arrayfun( @switch_RyR, tempdt, CaSS3, RyR32_ss,rand46, rand47, rand48);
    [RyR33_ss] = arrayfun( @switch_RyR, tempdt, CaSS3, RyR33_ss,rand49, rand50, rand51);
    [RyR34_ss] = arrayfun( @switch_RyR, tempdt, CaSS3, RyR34_ss, rand52, rand53, rand54);
    [RyR35_ss] = arrayfun( @switch_RyR, tempdt, CaSS3, RyR35_ss, rand55, rand56, rand57);

    [RyR41_ss] = arrayfun( @switch_RyR, tempdt, CaSS4, RyR41_ss,rand58, rand59, rand60);
    [RyR42_ss] = arrayfun( @switch_RyR, tempdt, CaSS4, RyR42_ss,rand61, rand62, rand63);
    [RyR43_ss] = arrayfun( @switch_RyR, tempdt, CaSS4, RyR43_ss,rand64, rand65, rand66);
    [RyR44_ss] = arrayfun( @switch_RyR, tempdt, CaSS4, RyR44_ss, rand67, rand68, rand69);
    [RyR45_ss] = arrayfun( @switch_RyR, tempdt, CaSS4, RyR45_ss, rand70, rand71, rand72);
       
    % Perform stochastic switching of the interior RyR gates 
%     tempdt = tstep.*onez_int;
    
%     rand13  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand14  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand15  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand16  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand17  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand18  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand19  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand20  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand21  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand22 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand23 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand24 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand25 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
% 
%     rand26  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand27  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand28  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand29  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand30  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand31  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand32  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand33 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand34  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand35 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand36 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand37 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
% 
%     rand38  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand39  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand40  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand41  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand42  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand43  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand44  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand45 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand46  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand47 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand48 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand49 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand50 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
% 
%     rand51  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand52  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand53  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand54  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand55  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand56  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand57  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand58  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand59  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand60 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand61 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand62 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
% 
%     rand63  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand64  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand65  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand66  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand67  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand68  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand69  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand70 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand71  = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     rand72 = gpuArray.rand((NFRU_sim - N_ss),1,'single');
%     
%     [RyR11_int] = arrayfun( @switch_RyR_int1, tempdt, Cai_GPU, RyR11_int,rand13, rand14); %, rand15);
%     [RyR12_int] = arrayfun( @switch_RyR_int1, tempdt, Cai_GPU, RyR12_int,rand16, rand17); %, rand18);
%     [RyR13_int] = arrayfun( @switch_RyR_int1, tempdt, Cai_GPU, RyR13_int,rand19, rand20); %, rand21);
%     [RyR14_int] = arrayfun( @switch_RyR_int1, tempdt, Cai_GPU, RyR14_int, rand22, rand23); %, rand24);
%     [RyR15_int] = arrayfun( @switch_RyR_int1, tempdt, Cai_GPU, RyR15_int, rand25, rand26); %, rand27);
% 
%     [RyR21_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR21_int,rand28, rand29); %, rand30);
%     [RyR22_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR22_int,rand31, rand32); %, rand33);
%     [RyR23_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR23_int,rand34, rand35); %, rand36);
%     [RyR24_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR24_int, rand37, rand38); %,rand39);
%     [RyR25_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR25_int, rand40, rand41); %, rand42);
% 
%     [RyR31_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR31_int,rand43, rand44); %, rand45);
%     [RyR32_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR32_int,rand46, rand47); %, rand48);
%     [RyR33_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR33_int,rand49, rand50); %, rand51);
%     [RyR34_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR34_int, rand52, rand53); %,rand54);
%     [RyR35_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR35_int, rand55, rand56); %, rand57);
% 
%     [RyR41_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR41_int,rand58, rand59); %, rand60);
%     [RyR42_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR42_int,rand61, rand62); %, rand63);
%     [RyR43_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR43_int,rand64, rand65); %, rand66);
%     [RyR44_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR44_int, rand67, rand68); %, rand69);
%     [RyR45_int] = arrayfun( @switch_RyR_int1, tempdt,Cai_GPU, RyR45_int, rand70, rand71); %, rand72);
    
    % Euler integration
   
    state = state + (tstep.*Fstate);
    CaJSR = CaJSR + (tstep.*dCaJSR);
    CaCSR = CaCSR + (tstep.*dCaCSR);
    a = min(CaiArray + (tstep.*dCaiArray));
%     if(a < 1.104e-04)
%        pause;
%     end
    CaiArray = CaiArray + (tstep.*dCaiArray);
    for s = 1:n_shells_ss
        if (CaiArray(s)<=0.0)
            CaiArray(s) = 1.e-15;
        end
    end
    CaNSRArray = CaNSRArray + (tstep.*dCaNSRArray);
    LTRPNCaArray = LTRPNCaArray + (tstep.*dLTRPNCaArray);
    HTRPNCaArray = HTRPNCaArray + (tstep.*dHTRPNCaArray);
    O1_RyR = O1_RyR + (tstep.*dO1_RyR);
    O2_RyR = O2_RyR + (tstep.*dO2_RyR);
    C1_RyR = C1_RyR + (tstep.*dC1_RyR);
    C2_RyR = C2_RyR + (tstep.*dC2_RyR);
    % Use rapid equilibrium assumption to update local concentrations
    [CaSS1, CaSS2, CaSS3, CaSS4] = arrayfun(@calc_local_states, state(index_V).*onez_SS,state(index_Cai).*onez_SS,CaJSR, LCC1,LCC2, LCC3,LCC4,Y1, Y2, Y3, Y4,...
                                        RyR11_ss, RyR12_ss, RyR13_ss, RyR14_ss, RyR15_ss,...
                                        RyR21_ss, RyR22_ss, RyR23_ss, RyR24_ss, RyR25_ss,...
                                        RyR31_ss, RyR32_ss, RyR33_ss, RyR34_ss, RyR35_ss,...
                                        RyR41_ss, RyR42_ss, RyR43_ss, RyR44_ss, RyR45_ss);

    %FRU_state = FRU_state + (tstep.*dFRU_state);
    if(isnan(CaiArray(end)))
        pause;
    end
    

end



