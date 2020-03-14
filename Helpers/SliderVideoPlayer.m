%% Opens a video player with a slider that reflects the current playback position:
%% Pho Hale, 3/13/2020

global svp;

% svp: SliderVideoPlayer
svpSettings.sliderWidth = 500;
svpSettings.sliderHeight = 23;
svpSettings.sliderX = 10;
svpSettings.sliderY = 50;
svpSettings.sliderMajorStep = 0.01;
svpSettings.sliderMinorStep = 0.1;

% Video Player
% vidPlayCallbacks.PreFrameUpdate = @(~,~) disp('Pre Frame changed!');
% vidPlayCallbacks.PostFrameUpdate = @(~,~) disp('Post Frame changed!');

svp.vidPlayer = implay(greyscale_frames, v.FrameRate);
% svp.vidPlayer.resi
% svp.vidPlayer.addlistener(vidPlayCallbacks.FrameUpdate);

%% Get the info about the loaded video:
%vidPlayer.DataSource.Controls.CurrentFrame
svp.vidInfo.vidPlaySourceType = svp.vidPlayer.DataSource.Type;
if svp.vidInfo.vidPlaySourceType == "Workspace"
    % Loaded from a workspace variable!
    svp.vidInfo.vidPlaySourceWorkspaceVariableName = svp.vidPlayer.DataSource.Name;
    vidPlaySourceWorkspaceVariableValue = eval(vidPlaySourceWorkspaceVariableName);
    svp.vidInfo.numFrames = length(vidPlaySourceWorkspaceVariableValue);
    svp.vidInfo.currentPlaybackFrame = svp.vidPlayer.DataSource.Controls.CurrentFrame;
else
    % Don't know what to do with videos loaded from disk
    disp("Unhandled type!");
end

%vidPlayer.viewMenuCallback
% guidata(hObject, handles);


%% Slider:
% PreCallBack = @(~,~) disp('Pause the video here');
% PostCallBack = @(~,~)disp('Play the video here');
% svp.Figure = figure();

% svp.Slider = uicontrol(svp.Figure,'Style','slider',...
svp.Slider = uicontrol(svp.vidPlayer.Parent,'Style','slider',...
                'Min',0,'Max',svp.vidInfo.numFrames,'Value',1,...
                'SliderStep',[svpSettings.sliderMinorStep svpSettings.sliderMajorStep],...
                'Position', [svpSettings.sliderX,svpSettings.sliderY,svpSettings.sliderWidth,svpSettings.sliderHeight]);
addlistener(svp.Slider, 'Value', 'PostSet', @slider_post_update_function);
% addlistener(SliderVideoPlayerSettings.Slider, 'Value', 'PreSet', slider_pre_update_function);

function output_txt = slider_pre_update_function(src, event_obj)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % Pause the video here:
    
    
end

function output_txt = slider_post_update_function(src, event_obj)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % Play the video here:
    % Get the frame from the slider:
%     updatedFrame = get(event_obj,'NewValue');

    updatedFrame = round(event_obj.AffectedObject.Value);

    %updatedFrame = get(svp.Slider,'Value');
    disp(updatedFrame);
    % Jump to frame:
%     h = findobj('Tag','slider1');
    global svp;
    svp.vidPlayer.DataSource.Controls.jumpTo(updatedFrame);
end