function out = Time_Analysis(Baseline,Test,Nw,Fs)
Baseline=Baseline;
Test=Test;
%Nw: size of hanning window
%Fs: sampling frequency
xnn= cell2mat(Test); %Getting the noisy data timestamp
xn=xnn(:,3); %Getting the data comlumn
xden=wden(xn,'sqtwolog','s','mln',4,'sym8'); %denoise the data
y=xden;
[ywinhat,fw2,t2,P2] = spectrogram(y,hann(Nw,'periodic'),Nw/2,Nw,Fs);
S2 = P2*Fs/Nw;        % Convert 1-sided power spectral density P2 (in power per Hz)into two sided periodogram (in power per FFT frequency            
SdB2 = 10*log10(S2);  % Convert spectral power to decibel scale
figure
image(t2,fw2/1000,SdB2,'CDataMapping','scaled')  
axis xy      
colorbar
xlabel('time [s]')
ylabel('Frequency [kHz]')
title("PSD[dB]T9-Denoised (HW length: "+(Nw)+")")


y2=Baseline;
[ywinhat2,fw4,t4,P4] = spectrogram(y2,hann(Nw,'periodic'),Nw/2,Nw,Fs);
S4 = P4*Fs/Nw;        % Convert 1-sided power spectral density P2 (in power per Hz)into two sided periodogram (in power per FFT frequency            
SdB4 = 10*log10(S4);  % Convert spectral power to decibel scale
figure
image(t4,fw4/1000,SdB4,'CDataMapping','scaled')  
axis xy      
colorbar
xlabel('time [s]')
ylabel('Frequency [kHz]')
title("PSD[dB]T9-Original (HW length: "+(Nw)+")")
Hotteling_article(SdB2,SdB4,50,2);