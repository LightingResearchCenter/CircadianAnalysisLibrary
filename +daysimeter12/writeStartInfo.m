function [ output_args ] = writeStartInfo( handels )
% WRITESTARTINFO will write the chosen starting information to daysimeters
%   This function will check to make sure that the desiered date is a date
%   that can exist and fundimentally makes sence. It will then take all the
%   information it needs to write the starting information to the
%   daysimeter and will write it. Finally it will save the new log_info.txt
%   file to the users default directory. 

currentDate = datevec(now);
potentialDate = (currentDate(1):currentDate(1)+10);
month = (get(handels.logInfoControl.startMonth,'Value'))-1;
day = (get(handels.logInfoControl.startDay,'Value'))-1;
year = potentialDate((get(handels.logInfoControl.startYear,'Value'))-1);
hour = (get(handels.logInfoControl.startHour,'Value'))-1;
minute = (get(handels.logInfoControl.startMinute,'Value'))-1;
if month<10
    if day<10
        if hour<10
            if minute<10
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    else
        if hour<10
            if minute<10
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    end
else
    if day<10
        if hour<10
            if minute<10
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    else
        if hour<10
            if minute<10
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    end
end

Date1 = datenum(date_string1,'mm/dd/yyyy HH:MM');
date_string2 = datestr(Date1,'mm/dd/yyyy HH:MM');
if ~(strcmp(date_string1,date_string2))
    set(handels.logInfoControl.instructBlock,'string','Invalid date Please Select a proper date.') ;
    return
end
set(handels.logInfo,'visible','off');
pause(0.0001);
potentialLogInterval = get(handels.logInfoControl.startLogInterval,'string');
index = get(handels.logInfoControl.startLogInterval,'value');
logInterval = str2double(potentialLogInterval{index});
daysims = daysimeter12.getDaysimeters();
start = daysimeter12.daysimeterStatus(2);
x = 0;
h = waitbar(x,'Starting Daysimeters');
for iDaysim = 1:length(daysims)
    logInfoTxt = daysimeter12.readloginfo(fullfile(daysims{iDaysim},'log_info.txt'));
    device = daysimeter12.parseDeviceSn(logInfoTxt);
    message = daysimeter12.setStatus(fullfile(daysims{iDaysim},'log_info.txt'), start);
    x = x+1;
    waitbar(x/(length(daysims)*4),h,'Writing Daysimeter to Default Folder');
    if isempty(message)
        message = daysimeter12.setStartDateTime(fullfile(daysims{iDaysim},'log_info.txt'), Date1);
        x = x+1;
        waitbar(x/(length(daysims)*4),h,'Writing Daysimeter to Default Folder');
        if isempty(message)
            message = daysimeter12.setLoggingInterval(fullfile(daysims{iDaysim},'log_info.txt'), logInterval);
            x = x+1;
            waitbar(x/(length(daysims)*4),h,'Writing Daysimeter to Default Folder');
            if ~isempty(message)
                set(handels.error,'visible','on');
                set(handels.errorControl.instructBlock,'String',sprintf('There was an error writing the Logging interval to daysimeter in daysimeter %d',  device));
                return
            end
        else
            set(handels.error,'visible','on');
            set(handels.errorControl.instructBlock,'String',sprintf('There was an error writing the date and time to daysimeter in daysimeter %d',  device));
            return
        end
    else
        set(handels.error,'visible','on');
        set(handels.errorControl.instructBlock,'String',sprintf('There was an error writing the Status to daysimeter in daysimeter %d',  device));
        return
    end
    newFileName = daysimeter12.makeNameStub(device);
    x = x+1;
    waitbar(x/(length(daysims)*4),h,'Writing Daysimeter to Default Folder');
    copyfile(fullfile(daysims{iDaysim},'log_info.txt'),fullfile(getenv('DAYSIMSAVELOC'),[newFileName,'-LOG.txt']),'f');
end
delete(h);
set(handels.daysimSearch,'visible','on');
set(handels.search.instructBlock,'string',sprintf('Daysimeters started. \nPlease Select what you would like to do.'));

end

