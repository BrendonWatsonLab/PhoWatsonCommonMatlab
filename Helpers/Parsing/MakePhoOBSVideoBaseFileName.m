function [OBSVideoBasename] = MakePhoOBSVideoBaseFileName(boxIdentifier, datetime)
%MakePhoOBSVideoFileName Parses the name of a OBS-recorded video file (the format created 7/25/2019 by Pho Hale)
%   Detailed explanation goes

format long g

% BehavioralBox_B00_T%NANOSEC
% _B{BOX_IDENTIFIER_NUMBER}: Box number
% _T{NANOSEC}: Timestamp of file creation 

% videoFile.nanosecondsTimestampString = tokenNames.nanosecondsTimestamp;
% videoFile.nanosecondsTimestampValue = sscanf(videoFile.nanosecondsTimestampString, '%lu');
% videoFile.dateTime = datetime(videoFile.nanosecondsTimestampValue/1e9,'convertFrom','posixtime');

% temp.outDateString = datestr(datetime, 'yyyyMMdd''T''HHmmssSSS');
temp.outDateDayString = datestr(datetime, 'yyyyMMdd');
% temp.outDateTimeString = datestr(datetime, 'HHmmssSSS');
temp.outDateTimeString = datestr(datetime, 'HHmmssFFF');


% temp.combinedVideoDateString = tokenNames.DatePortion + "T" + tokenNames.TimePortion;
% % Convert the string to a datetime (the string is specified in UTC)
% videoFile.dateTime = datetime(temp.combinedVideoDateString,'InputFormat','yyyyMMdd''T''HHmmssSSS','TimeZone','UTC');
% % Convert the datetime to local time
% videoFile.dateTime.TimeZone = 'local';


OBSVideoBasename = sprintf('BehavioralBox_B%s_T%s-%s', boxIdentifier, temp.outDateDayString, temp.outDateTimeString);

end

