freq_array = [2.5, 2];
%diff_factor_array = [1,2,5,10,20];
filename = 'Fluxes';

for i = 1:length(freq_array)
    freq = freq_array(i);
    input_dir = strcat('Freq_',num2str(freq),'Hz');
    output_dir = strcat('Freq_',num2str(freq),'Hz');
    ic_states_file = strcat(input_dir,'/','ic_states_',num2str(freq) ,'Hz.txt');
    ic_FRU_file = strcat(input_dir, '/','ic_FRU_',num2str(freq) ,'Hz.txt');
    ic_LCh_file = strcat(input_dir,'/','ic_LCh_',num2str(freq) ,'Hz.txt');
    ic_RyR_ss_file = strcat(input_dir,'/','ic_RyR_ss_',num2str(freq) ,'Hz.txt');
    ic_RyR_int_file = strcat(input_dir,'/','ic_RyR_int_',num2str(freq) ,'Hz.txt');
    ic_CaCSR_file = strcat(input_dir,'/','ic_CaCSR_',num2str(freq) ,'Hz.txt');
    ic_Cai_file = strcat(input_dir,'/','ic_Cai_',num2str(freq) ,'Hz.txt');
    ic_CaNSR_file = strcat(input_dir,'/','ic_CaNSR_',num2str(freq) ,'Hz.txt');
    ic_LTRPNCa_file = strcat(input_dir,'/','ic_LTRPNCa_',num2str(freq) ,'Hz.txt');
    ic_HTRPNCa_file = strcat(input_dir,'/','ic_HTRPNCa_',num2str(freq) ,'Hz.txt');
    ic_Ito2_file = strcat(input_dir,'/','ic_Ito2_',num2str(freq) ,'Hz.txt');
    ic_CaCSR_file = strcat(input_dir,'/','ic_CaCSR_',num2str(freq),'Hz.txt');
    tic;
    main;
    toc;
    file_save = strcat(output_dir,'/',filename);
    save(file_save, 'JMyodiff_Array', 'JNSRdiff_Array', 'Jup_Array', 'Jtrpn_Array', 'JRyRint_Array', 'Jtrint_Array', 'Jxfer_Array', 'Jtr_Array', 'JRyR_SS_Array');
   % Update the initial conditions file 

    
    IC_state = state';
    
    IC_FRU_state(:,1) = gather(CaJSR);
    IC_FRU_state(:,2) = gather(CaSS1);
    IC_FRU_state(:,3) = gather(CaSS2);    
    IC_FRU_state(:,4) = gather(CaSS3);
    IC_FRU_state(:,5) = gather(CaSS4);
    
    IC_LCh(:,1) = int8(vertcat(gather(LCC1), gather(LCC2), gather(LCC3), gather(LCC4)));
    IC_LCh(:,2) = int8(vertcat(gather(Y1), gather(Y2), gather(Y3), gather(Y4)));
    
    IC_Ito2(:,1) = int8(vertcat(gather(Ito2_1), gather(Ito2_2), gather(Ito2_3), gather(Ito2_4)));
    
    IC_RyR_int(:,1) = int8(vertcat(gather(RyR11_int),gather(RyR21_int), gather(RyR31_int), gather(RyR41_int)));
    IC_RyR_int(:,2) = int8(vertcat(gather(RyR12_int),gather(RyR22_int), gather(RyR32_int), gather(RyR42_int)));
    IC_RyR_int(:,3) = int8(vertcat(gather(RyR13_int),gather(RyR23_int), gather(RyR33_int), gather(RyR43_int)));
    IC_RyR_int(:,4) = int8(vertcat(gather(RyR14_int),gather(RyR24_int), gather(RyR34_int), gather(RyR44_int)));
    IC_RyR_int(:,5) = int8(vertcat(gather(RyR15_int),gather(RyR25_int), gather(RyR35_int), gather(RyR45_int)));
    
    IC_RyR_ss(:,1) = int8(vertcat(gather(RyR11_ss),gather(RyR21_ss), gather(RyR31_ss), gather(RyR41_ss)));
    IC_RyR_ss(:,2) = int8(vertcat(gather(RyR12_ss),gather(RyR22_ss), gather(RyR32_ss), gather(RyR42_ss)));
    IC_RyR_ss(:,3) = int8(vertcat(gather(RyR13_ss),gather(RyR23_ss), gather(RyR33_ss), gather(RyR43_ss)));
    IC_RyR_ss(:,4) = int8(vertcat(gather(RyR14_ss),gather(RyR24_ss), gather(RyR34_ss), gather(RyR44_ss)));
    IC_RyR_ss(:,5) = int8(vertcat(gather(RyR15_ss),gather(RyR25_ss), gather(RyR35_ss), gather(RyR45_ss)));
    
    IC_CaCSR = gather(CaCSR);
    
    IC_Cai = CaiArray';
    IC_CaNSR = CaNSRArray';
    IC_LTRPNCa = LTRPNCaArray';
    IC_HTRPNCa = HTRPNCaArray';
    
    save(ic_states_file,'IC_state','-ascii');
    save(ic_FRU_file,'IC_FRU_state','-ascii');
    
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
    
    fileID = fopen(ic_RyR_int_file,'w');
    fprintf(fileID, '%d \n',((NFRU_sim - N_ss)*Nclefts_FRU));
    dlmwrite(ic_RyR_int_file,IC_RyR_int,'-append','delimiter',' ')
    fclose(fileID);
    
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
end
