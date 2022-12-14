%% Carga de un fichero .wav en Matlab y creaci ?on de otro fichero con el formato que emplea el
%testbench.

[data_8b, fs_8b] = audioread('haha_input.wav');
file_8b = fopen('haha_sample_in_8b.dat','w');
fprintf(file_8b, '%d\n', round(data_8b.*255));

[data_10b, fs_10b] = audioread('haha_input.wav');
file_10b = fopen('haha_sample_in_10b.dat','w');
fprintf(file_10b, '%d\n', round(data_10b.*1023));

[data_12b, fs_12b] = audioread('haha_input.wav');
file_12b = fopen('haha_sample_in_12b.dat','w');
fprintf(file_12b, '%d\n', round(data_12b.*4095));

[data_14b, fs_14b] = audioread('haha_input.wav');
file_14b = fopen('haha_sample_in_14b.dat','w');
fprintf(file_14b, '%d\n', round(data_14b.*16383));

[data_16b, fs_16b] = audioread('haha_input.wav');
file_16b = fopen('haha_sample_in_16b.dat','w');
fprintf(file_16b, '%d\n', round(data_16b.*65535));

[data_18b, fs_18b] = audioread('haha_input.wav');
file_18b = fopen('haha_sample_in_18b.dat','w');
fprintf(file_18b, '%d\n', round(data_18b.*262143));

%% Carga y escucha de un fichero con el formato de salida del testbench. 
vhdlout=load('l_sample_out_re_arch_v1.dat')/65535;
%vhdlout=load('l_sample_out_re_arch_v2.dat')/65535;
sound(vhdlout);
load handel.mat

audiowrite('haha_bankfilterHPF.wav',vhdlout,fs_16b);
%% Gráficas para comparar la cuantificación de los formatos de 12b, 14b y 16b

% Delays de Lectura --> 2 Delays por la implementación + 2 Delays del TB
% Lectura del audio:
fileID_8b  = fopen('l_sample_out_8b.dat','r');
result_8b  = fscanf(fileID_8b,'%f');
fileID_10b = fopen('l_sample_out_10b.dat','r');
result_10b = fscanf(fileID_10b,'%f');
fileID_12b = fopen('l_sample_out_12b.dat','r');
result_12b = fscanf(fileID_12b,'%f');
fileID_14b = fopen('l_sample_out_14b.dat','r');
result_14b = fscanf(fileID_14b,'%f');
fileID_16b = fopen('l_sample_out_16b.dat','r');
result_16b = fscanf(fileID_16b,'%f');
fileID_18b = fopen('l_sample_out_18b.dat','r');
result_18b = fscanf(fileID_18b,'%f');

% Normalización del audio:
result_8b_norm  = result_8b/127;
result_10b_norm = result_10b/511;
result_12b_norm = result_12b/2047;
result_14b_norm = result_14b/8191;
result_16b_norm = result_16b/32767;
result_18b_norm = result_18b/131071;

% Recorte del audio para dejarlos con el mismo tamaño
result_8b_norm_resize  = result_8b_norm(1000:15999,1);
result_10b_norm_resize = result_10b_norm(1000:15999,1);
result_12b_norm_resize = result_12b_norm(1000:15999,1);
result_14b_norm_resize = result_14b_norm(1000:15999,1);
result_16b_norm_resize = result_16b_norm(1000:15999,1);
result_18b_norm_resize = result_18b_norm(1000:15999,1);

% Analizamos un fragmento de audio solapando todas las cuantificaciones:
x = linspace(0,1,15000)';
figure(1);
plot(x, result_8b_norm_resize,  ...
     x, result_10b_norm_resize, ...
     x, result_12b_norm_resize, ...
     x, result_14b_norm_resize, ...
     x, result_16b_norm_resize, ...
     x, result_18b_norm_resize);

figure(2);
plot(x, result_8b_norm_resize);
figure(3);
plot(x, result_10b_norm_resize);
figure(4);
plot(x, result_12b_norm_resize);
figure(5);
plot(x, result_14b_norm_resize);
figure(6);
plot(x, result_16b_norm_resize);
figure(7);
plot(x, result_18b_norm_resize);

% Error de cuantificación de todo el audio procesado
error_8b  = abs(result_16b_norm_resize - result_8b_norm_resize);
error_10b = abs(result_16b_norm_resize - result_10b_norm_resize);
error_12b = abs(result_16b_norm_resize - result_12b_norm_resize);
error_14b = abs(result_16b_norm_resize - result_14b_norm_resize);
error_16b = abs(result_16b_norm_resize - result_16b_norm_resize); % Debería salir 0
error_18b = abs(result_16b_norm_resize - result_18b_norm_resize);

figure(7);
plot(x, error_8b);
figure(8);
plot(x, error_10b);
figure(9);
plot(x, error_12b);
figure(10);
plot(x, error_14b);
figure(11);
plot(x, error_16b);
figure(12);
plot(x, error_18b);

%% Calcular el SNR y confirmar que es como Vin^2/Vn^2. Volver a poner los 8b. Hisograma del error
% snr_8b_lineal = (result_8b_norm_resize.^2 / error_8b.^2);
% snr_8b_dB = 10*log10(snr_8b_lineal);
% snr_10b_lineal = (result_10b_norm_resize.^2 / error_10b.^2);
% snr_10b_dB = 10*log10(snr_10b_lineal);
% snr_12b_lineal = abs(result_12b_norm_resize ./ error_12b);
% snr_14b_lineal = (result_14b_norm_resize.^2 / error_14b.^2);
% snr_14b_dB = 10*log10(snr_14b_lineal);
% snr_16b_lineal = (result_16b_norm_resize.^2 / error_16b.^2);
% snr_16b_dB = 10*log10(snr_16b_lineal);
% snr_18b_lineal = (result_18b_norm_resize.^2 / error_18b.^2);
% snr_18b_dB = 10*log10(snr_18b_lineal);
%%
% figure(13);
% plot(x, snr_8b_dB);
% figure(14);
% plot(x, snr_10b_dB);
% figure(15);
% plot(x, snr_12b_lineal);
% figure(16);
% plot(x, snr_14b_dB);
% figure(17);
% plot(x, snr_16b_dB);
% figure(18);
% plot(x, snr_18b_dB);