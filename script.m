close all;
clc;clear;

%% Settings
samplefreq = 50;
samplePeriod = 1/samplefreq;

%% Load data
filename{1} = 'moticon_synkronisert/L1_161013_160534.txt';    % elite
filename{2} = 'moticon_synkronisert/L4_161013_175803.txt';    % tur
filename{3} = 'moticon_synkronisert/L5_161013_183431.txt';    % elite
filename{4} = 'moticon_synkronisert/L6_p1_161013_194538.txt'; % elite


%Marked beginning and end of skating settings
sidx = [  7 10     13     19    22     25    29.5    31    34;...  %L1
         11 13.751 16.655 22.5  25.501 28.55 33    36    39;...    %L4
         10 13.05  16.05  19.05 22.05  25.05 28.05 31.05 34.05;... %L5
         4  7      10     13    16     19    22.5  25.5  29]*1e3;  %L6
     
eidx = [10    13    16 22   25   28   31   34   37;...   %L1
        13.75 16.65 20 25.5 28.5 31.5 36   39   42;...   %L4
        13    16    19 22   25   28   31   34   37;...   %L5
        7     10    13 16   19   22   25.5 28.5 31]*1e3; %L6
    
L = cell(4,1);
L{1}.level = 'elite';
L{2}.level = 'tur';
L{3}.level = 'elite';
L{4}.level = 'elite';

for k = 1:length(filename);
    data = load(filename{k});
    L{k}.file = filename{k};
    L{k}.samplePeriod = samplePeriod;
    L{k}.enkelt  = cell(3,1); % cell index corresponds to intensity level
    L{k}.dobbelt = cell(3,1);
    L{k}.padling = cell(3,1);
    
    for i = 1:3
        disp(['k: ',num2str(k),' / i: ',num2str(i)]);
        L{k}.enkelt{i}.data  = data(sidx(k,i):eidx(k,i),:);
        L{k}.dobbelt{i}.data = data(sidx(k,i+3):eidx(k,i+3),:);
        L{k}.padling{i}.data = data(sidx(k,i+6):eidx(k,i+6),:);
        L{k}.enkelt{i}  = detectCycles(L{k}.enkelt{i},samplePeriod);
        L{k}.dobbelt{i} = detectCycles(L{k}.dobbelt{i},samplePeriod);
        L{k}.padling{i} = detectCycles(L{k}.padling{i},samplePeriod);
    end
end

%% Evaluate cycle detection
for k = 1:length(L)
    figure;
    for i = 1:3
        subplot(3,3,i)
        plot(L{k}.enkelt{i}.data(:,18));hold on;
        plot(L{k}.enkelt{i}.data(:,18+19));
        plot(L{k}.enkelt{i}.cyclestart,L{k}.enkelt{i}.data(L{k}.enkelt{i}.cyclestart,18),'r*');
        subplot(3,3,i+3)
        plot(L{k}.dobbelt{i}.data(:,18));hold on;
        plot(L{k}.dobbelt{i}.data(:,18+19));
        plot(L{k}.dobbelt{i}.cyclestart,L{k}.dobbelt{i}.data(L{k}.dobbelt{i}.cyclestart,18),'r*');
        subplot(3,3,i+6);
        plot(L{k}.padling{i}.data(:,18));hold on;
        plot(L{k}.padling{i}.data(:,18+19));
        plot(L{k}.padling{i}.cyclestart,L{k}.padling{i}.data(L{k}.padling{i}.cyclestart,18),'r*');
    end
end


%%

%Columns:
%1 #  time
%2    pressure 0[N/cm²] 
%3    pressure 1[N/cm²] 
%4    pressure 2[N/cm²] 
%5    pressure 3[N/cm²] 
%6    pressure 4[N/cm²] 
%7    pressure 5[N/cm²] 
%8    pressure 6[N/cm²] 
%9    pressure 7[N/cm²] 
%10   pressure 8[N/cm²] 
%11   pressure 9[N/cm²] 
%12   pressure 10[N/cm²] 
%13   pressure 11[N/cm²] 
%14   pressure 12[N/cm²] 
%15   acceleration X[g] 
%16   acceleration Y[g] 
%17   acceleration Z[g] 
%18   total force[N] 
%19   center of pressure X[mm]
%20   center of pressure Y[mm]
% ... right side (+19)







