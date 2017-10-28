function [time, sats, NoSv, eof, datee] = fepoch_0(fid)
% FEPOCH_0   Finds the next epoch in an opened RINEX file with
%	          identification fid. From the epoch line is produced
%	          time (in seconds of week), number of sv.s, and a mark
%	          about end of file. Only observations with epoch flag 0
%	          are delt with.

%Kai Borre 09-14-96; revised 03-22-97; revised Sept 4, 2001
%Copyright (c) by Kai Borre
%$Revision: 1.0 $  $Date: 1997/09/22  $
%fide = fopen(fid,'rt');

global sat_index;
time = 0;
sats = [];
NoSv = 0;
eof = 0;
year = 0;
while 1
    
    lin = fgets(fid); % earlier fgetl
    
    if (feof(fid) == 1);%s�Ƿ��ļ�ĩβ
        eof = 1;
        break
    end;
    
    [year, lin] = strtok(lin);%һ��һ�ν�ȡlin��ǰ��һ�븳ֵ������һ�μ����ȴ���ȡ
    [month, lin] = strtok(lin);
    [day, lin] = strtok(lin);
    [hour, lin] = strtok(lin);
    [minute, lin] = strtok(lin);
    [second, lin] = strtok(lin);
    
    [OK_flag, lin] = strtok(lin);
    
    h = str2num(hour)+str2num(minute)/60+str2num(second)/3600;
    jd = julday(str2num(year)+2000, str2num(month), str2num(day), h);
    
    [week, sec_of_week] = gps_time(jd);
    
    time = sec_of_week;
    
    [NoSv, lin] = strtok(lin,'G');%��һ��Gǰ�棬�Ǳ���Ԫ��������Ŀ
    NoSv=str2num(NoSv);
    if NoSv > 12
        for k = 1:12
            [sat, lin] = strtok(lin,'G');
            answer = findstr(sat,'R');
            if ~isempty(answer)
                sat = strtok(sat,'R');
                prn(k) = str2num(sat);
                lin = fgetl(fid);
                break;
            end
            prn(k) = str2num(sat);
        end
    else
        for k = 1:NoSv
            [sat, lin] = strtok(lin,'G');
            prn(k) = str2num(sat);
        end%���PRN�б�
    end;
    
    sats = prn(:);
    
    break
end;
datee=[str2num(year) str2num(month) str2num(day) str2num(hour) str2num(minute) str2num(second)];

%%%%%%%% end fepoch_0.m %%%%%%%%%
