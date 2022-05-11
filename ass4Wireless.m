clc;
clear;
close all;

N=30000;
M=16;
k = log2(M);
infoSignal=  randi([0 1],N,1);

disp('infoSignal');
disp(infoSignal);
dataSymbolsInteger = bit2int(infoSignal,k)


%% QAM Modulation
Qam_16 = qammod(dataSymbolsInteger,M);

%% Constellation Plots (without noise)
scatterplot(Qam_16);
title('Noiseless 16-QAM Constellation Diagram');

EbNo =0.00000000000001;
sps=1;
snr = EbNo+10*log10(k)-10*log10(sps);

% AWGN Channal

awgn_signal_16=awgn(Qam_16,snr,'measured');

% AWGN channel plots
scatterplot(awgn_signal_16);
title('AWGN Channel Signal with 16 QAM Modulation');

% AWGN channel signals
awgn_demodulated_16 =qamdemod(awgn_signal_16,M);
disp('awgn_demodulated_16')
disp(awgn_demodulated_16)
Binary_demodulatedQam_16 = int2bit(awgn_demodulated_16, log2(M));


[numErrors,ber] = biterr(infoSignal,Binary_demodulatedQam_16);
fprintf('\nThe Gray coding bit error rate is %5.2e, based on %d errors.\n', ...
    ber,numErrors);

% %% SNR and BER Graphs
 SNR = [];
 BER_16_awgn = [];
signal_16_B = de2bi(dataSymbolsInteger, 4);

% 
counter=1;
for EbNo =-100:0.001;0.00000000000000000000000000001

    
   snr = EbNo+10*log10(k)-10*log10(sps);
   awgn_signal_16=awgn(Qam_16,snr,'measured');
   awgn_demodulated_16 =qamdemod(awgn_signal_16, M);
   Binary_demodulatedQam_16 = int2bit(awgn_demodulated_16, log2(M));
   [numErrors,ber] = biterr(infoSignal,Binary_demodulatedQam_16);
  
    SNR(end + 1) = counter;
    BER_16_awgn(end + 1) = ber;
    counter=counter+1;
end 
%% Graphs of BER with AWGN addition
figure;
 EbNo =-100:0.001;0.00000000000000000000000000001;
 snr = EbNo+10*log10(k)-10*log10(sps);
semilogy(snr, BER_16_awgn);
xlim([-100 50]);
xlabel("SNR");
ylabel("BER");
title('practical BER  with AWGN ')
legend("16-QAM")
figure;
EbNo = -100:0.001;0.00000000000000000000000000001;
theoryBer = (1/4)*3/2*erfc(sqrt(4*0.1*(10.^(EbNo/10))));
snr = EbNo+10*log10(k)-10*log10(sps);

semilogy(snr,theoryBer);
xlabel("SNR");
ylabel("BER");
xlim([-100 50]);
title('theoritical BER  with AWGN ');
legend("16-QAM");

bitsPersymbol=4;
shape=ones(bitsPersymbol,1);
psd=upfirdn(awgn_signal_16,shape,bitsPersymbol);
figure;
pwelch(psd);
