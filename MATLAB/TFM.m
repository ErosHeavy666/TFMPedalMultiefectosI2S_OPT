%% Carga de un fichero .wav en Matlab y creaci ?on de otro fichero con el formato que emplea el
%testbench.
[data, fs] = audioread('guitar_input.wav');
file = fopen('guitar_sample_in.dat','w');
fprintf(file, '%d\n', round(data.*65535));

%% Carga y escucha de un fichero con el formato de salida del testbench. 
vhdlout=load('guitar_sample_in.dat')/65535;
sound(vhdlout);

%% Gráficas para comparar la cuantificación de los formatos de 12b, 14b y 16b