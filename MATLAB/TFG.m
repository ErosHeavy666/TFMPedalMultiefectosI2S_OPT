%% Carga de un fichero .wav en Matlab y creaci ?on de otro fichero con el formato que emplea el
%testbench.
[data, fs] = audioread('input_test.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*65535));

%% Carga y escucha de un fichero con el formato de salida del testbench. 
vhdlout=load('sample_out.dat')/65535;
sound(vhdlout);

%% Guarda el audio procesado
load handel.mat

audiowrite('haha_bankfilterHPF.wav',vhdlout,fs);
clear y Fs
