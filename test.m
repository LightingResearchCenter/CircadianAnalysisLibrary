clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(filePath);

[phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(absTime.localDateNum,epoch,light.cs,activity);

[interdailyStability,intradailyVariability] = isiv.isiv(activity,epoch);

[         ~,millerCS] = millerize.millerize(relTime,light.cs,masks);
[millerTime,millerActivity] = millerize.millerize(relTime,activity,masks);
h = plots.miller(millerTime,'Circadian Stimulus (CS)',millerCS,'Activity Index (AI)',millerActivity);


% WARNING: DFA is slow
% alpha = dfa.dfa(epoch,activity,1,[1.5,8]);