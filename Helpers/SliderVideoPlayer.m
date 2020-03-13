%% Opens a video player with a slider that reflects the current playback position:
%% Pho Hale, 3/13/2020

% svp: SliderVideoPlayer
svpSettings.sliderWidth = 500;
svpSettings.sliderHeight = 23;
svpSettings.sliderX = 10;
svpSettings.sliderY = 50;

% Video Player
% vidPlayCallbacks.PreFrameUpdate = @(~,~) disp('Pre Frame changed!');
% vidPlayCallbacks.PostFrameUpdate = @(~,~) disp('Post Frame changed!');

svp.vidPlayer = implay(greyscale_frames, v.FrameRate);
svp.vidPlayer.addlistener(vidPlayCallbacks.FrameUpdate);

%% Get the info about the loaded video:
%vidPlayer.DataSource.Controls.CurrentFrame
svp.vidInfo.vidPlaySourceType = vidPlayer.DataSource.Type;
if svp.vidInfo.vidPlaySourceType == "Workspace"
    % Loaded from a workspace variable!
    svp.vidInfo.vidPlaySourceWorkspaceVariableName = vidPlayer.DataSource.Name;
    vidPlaySourceWorkspaceVariableValue = eval(vidPlaySourceWorkspaceVariableName);
    svp.vidInfo.numFrames = length(vidPlaySourceWorkspaceVariableValue);
    svp.vidInfo.currentPlaybackFrame = vidPlayer.DataSource.Controls.CurrentFrame;
else
    % Don't know what to do with videos loaded from disk
    disp("Unhandled type!");
end

%vidPlayer.viewMenuCallback



%% Slider:
% PreCallBack = @(~,~) disp('Pause the video here');
% PostCallBack = @(~,~)disp('Play the video here');
svp.Figure = figure();
svp.Slider = uicontrol(svp.Figure,'Style','slider',...
                'Min',0,'Max',svp.vidInfo.numFrames,'Value',1,...
                'SliderStep',[0.05 0.2],...
                'Position', [svpSettings.sliderX,svpSettings.sliderY,svpSettings.sliderWidth,svpSettings.sliderHeight]);
addlistener(svp.Slider, 'Value', 'PostSet', slider_post_update_function);
% addlistener(SliderVideoPlayerSettings.Slider, 'Value', 'PreSet', slider_pre_update_function);

vidPlayer.DataSource.Controls.jumpTo(10);

function output_txt = slider_pre_update_function(~,event_obj)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % Pause the video here:
    
    
end

function output_txt = slider_post_update_function(~,event_obj)
    % ~            Currently not used (empty)
    % event_obj    Object containing event data structure
    % Play the video here:
    % Get the frame from the slider:
    
    % Jump to frame:
    svp.vidPlayer.DataSource.Controls.jumpTo(10);
end