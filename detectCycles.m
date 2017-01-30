function [ intensityRun ] = detectCycles(intensityRun, samplePeriod)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    data = intensityRun.data;
    F = data(:,18);
    
    filtCutOff = 3;
    [b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'low');
    Ffilt = filtfilt(b, a, F);

    % detect uprising force that corresponds to initial contact of the foot
    ic_threshold = 200; % force threshold for initial contact [N]
    cyclestart = find(diff(Ffilt < ic_threshold) == -1);
    
    %clip incomplete cycle at beginning and end
    intensityRun.data = intensityRun.data(cyclestart(1):cyclestart(end),:);
    
    F = F(cyclestart(1):cyclestart(end));
    Ffilt = Ffilt(cyclestart(1):cyclestart(end));
    cyclestart = cyclestart - cyclestart(1) +1;
%     cyclestart = cyclestart - cyclestart(1) +1;
    
%     cycleend = find(diff(Ffilt(cyclestart:end) < 100) == 1);
%     
%     N = min(length(cyclestart),length(cycleend));
%     
%     cyclestart = cyclestart(1:N);
%     cycleend = cycleend(1:N);
%     
%     delta = cycleend - cyclestart;
    
%     figure;
%     plot(delta);hold on;
%     plot(mean(delta)*ones(1,length(delta)),'r');
%     plot((mean(delta)+2*std(delta))*ones(1,length(delta)),'r');
%     plot((mean(delta)-2*std(delta))*ones(1,length(delta)),'r');
%     % detect false detections

    intervals = diff(cyclestart)*samplePeriod;
    outlierIdx = find(intervals < mean(intervals)-2*std(intervals) & intervals < 0.5)+1;
    cyclestart(outlierIdx) = [];
    
    intensityRun.cyclestart = cyclestart(1:end-1);
    intensityRun.N_cycles = length(cyclestart) - 1;
    
    for i = 1:(intensityRun.N_cycles)
        intensityRun.cycles{i} = intensityRun.data(cyclestart(i):cyclestart(i+1)-1);   
    end
    
    
    

%     close all;
%     figure;
%     plot(intervals);hold on;
%     plot(mean(intervals)*ones(1,length(intervals)),'r');
%     plot((mean(intervals)+2*std(intervals))*ones(1,length(intervals)),'r');
%     plot((mean(intervals)-2*std(intervals))*ones(1,length(intervals)),'r');
%     if(~isempty(outlierIdx))
%         plot(outlierIdx,intervals(outlierIdx),'*r');
%     end
% 
%     close all;
%     N = length(F);
%     time = [0:N-1]*samplePeriod;
%     figure;
%     plot(time,F);hold on;
%     plot(time,Ffilt);
%     plot(time(cyclestart),F(cyclestart),'*r');
%     if(~isempty(outlierIdx))
%         plot(time(cyclestart(outlierIdx)),F(cyclestart(outlierIdx)),'ko');
%     end


end