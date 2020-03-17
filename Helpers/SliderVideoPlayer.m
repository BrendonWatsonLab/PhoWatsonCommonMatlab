function [svp, svpSettings] = sliderVideoPlayer(svpConfig)
%sliderVideoPlayer Opens a video player with a slider that reflects the current playback position:
%   Pho Hale, 3/17/2020

%     global svp;
%     svpConfig.DataPlot.x = frameIndexes;
%     svpConfig.DataPlot.y = temp;
%     svpConfig.DataPlot.title = 'Region Intensity';
%     
% %     svpConfig.VidPlayer.videoSource = greyscale_frames; % From workspace variable
%     svpConfig.VidPlayer.videoSource = curr_video_file.full_path; % from file path
%     svpConfig.VidPlayer.frameRate = v.FrameRate;
    
    
    % svp: SliderVideoPlayer
    % svpSettings.sliderWidth = 100;
    % svpSettings.sliderHeight = 23;
    % svpSettings.sliderX = 0;
    % svpSettings.sliderY = 40;
    svpSettings.sliderMajorStep = 0.01;
    svpSettings.sliderMinorStep = 0.1;

    %% Plot Window:
    svp.DataPlot.fig = figure(1);
    clf
    % svp.DataPlot.plotH = plot(frameIndexes, region_mean_per_frame_smoothed);
    svp.DataPlot.plotH = plot(svpConfig.DataPlot.x, svpConfig.DataPlot.y);
    xlabel('Frame Index');
    title(svpConfig.DataPlot.title);
    xlim([svpConfig.DataPlot.x(1), svpConfig.DataPlot.x(end)]);
    dualcursor on;
    dualcursor('onlyOneCursor');

    % Video Player
    % vidPlayCallbacks.PreFrameUpdate = @(~,~) disp('Pre Frame changed!');
    % vidPlayCallbacks.PostFrameUpdate = @(~,~) disp('Post Frame changed!');

    % svp.vidPlayer = implay(greyscale_frames, svpConfig.VidPlayer.frameRate);
    svp.vidPlayer = implay(svpConfig.VidPlayer.videoSource, svpConfig.VidPlayer.frameRate);
    spawnPosition = svp.vidPlayer.Parent.Position;
    set(svp.vidPlayer.Parent, 'Position',  [180, 300, 867, 883]);
    %% Ready to work:
%     toolbar = findobj(svp.vidPlayer.Parent,'Tag','uimgr.uitoolbar_Playback');
%     playbtn = toolbar.Children(7);
%     playbtnBackupCallback = playbtn.ClickedCallback;
%     
%     vidPlayCallbacks.PauseButtonCallback = @(~,~) disp('Pause!');
%     vidPlayCallbacks.PlayButtonCallback = @(hco,ev) playbtnBackupCallback(hco,ev); disp('Play!');
%     vidPlayCallbacks.StopButtonCallback = @(~,~) disp('Stop!');
%     vidPlayCallbacks.PlaybackMenuCallback = @(~,~) disp('Playback menu callback!!');
%     vidPlayCallbacks.LoadedCallback = @(~,~) disp('Loaded callback!!');
%     
%     playbtn.ClickedCallback = vidPlayCallbacks.PlayButtonCallback;
    
%     svp.vidPlayer.playbackMenuCallback = vidPlayCallbacks.PlaybackMenuCallback;
%     svp.vidPlayer.addlistener(vidPlayCallbacks.FrameUpdate);
%     addlistener(svp.Slider, 'Value', 'PostSet', @slider_post_update_function);
%     svp.vidPlayer.addlistener(
%     el = svp.vidPlayer.addlistener(svp.vidPlayer, 'DataLoadedEvent', vidPlayCallbacks.PlaybackMenuCallback)
%     el = addlistener(svp.vidPlayer, 'DataLoadedEvent', vidPlayCallbacks.LoadedCallback)
%     svp.vidPlayer.addlistener('DataLoadedEvent', vidPlayCallbacks.LoadedCallback);
%     svp.vidPlayer.addlistener('PlayEvent', vidPlayCallbacks.PlayButtonCallback);
%     svp.vidPlayer.addlistener('PauseEvent', vidPlayCallbacks.PauseButtonCallback);
%     svp.vidPlayer.addlistener('StopEvent', vidPlayCallbacks.StopButtonCallback);
%     

    % playbtn.ClickedCallback = @(hco,ev)playPause(this)
    
    
    
%     'uimgr.uitoolbar_Playback'
    
    
%     'playPause'
    % svp.vidPlayer.addlistener(vidPlayCallbacks.FrameUpdate);

    %% Get the info about the loaded video:
    %vidPlayer.DataSource.Controls.CurrentFrame
    svp.vidInfo.frameIndexes = svpConfig.DataPlot.x;
    svp.vidInfo.vidPlaySourceType = svp.vidPlayer.DataSource.Type;
    if svp.vidInfo.vidPlaySourceType == "Workspace"
        % Loaded from a workspace variable!
        svp.vidInfo.vidPlaySourceWorkspaceVariableName = svp.vidPlayer.DataSource.Name;
        vidPlaySourceWorkspaceVariableValue = eval(svp.vidInfo.vidPlaySourceWorkspaceVariableName);
        svp.vidInfo.numFrames = length(vidPlaySourceWorkspaceVariableValue);
        svp.vidInfo.currentPlaybackFrame = svp.vidPlayer.DataSource.Controls.CurrentFrame;
    elseif svp.vidInfo.vidPlaySourceType == "File"
        svp.vidInfo.vidPlaySourceWorkspaceVariableName = svp.vidPlayer.DataSource.Name;
        svp.vidInfo.numFrames = length(svpConfig.DataPlot.x);
        svp.vidInfo.currentPlaybackFrame = svp.vidPlayer.DataSource.Controls.CurrentFrame;

    else
        % Don't know what to do with videos loaded from disk
        error("Unhandled type!");
    end

    %vidPlayer.viewMenuCallback
    % guidata(hObject, handles);


    %% Slider:
    % PreCallBack = @(~,~) disp('Pause the video here');
    % PostCallBack = @(~,~)disp('Play the video here');
    % svp.Figure = figure();
    % Gets the slider position from the video player
    svpSettings.sliderWidth = svp.vidPlayer.Parent.Position(3) - 20;
    svpSettings.sliderHeight = 23;
    svpSettings.sliderX = 5;
    svpSettings.sliderY = 40;

    % svp.Slider = uicontrol(svp.Figure,'Style','slider',...
    svp.Slider = uicontrol(svp.vidPlayer.Parent,'Style','slider',...
                    'Min',1,'Max',svp.vidInfo.numFrames,'Value',svp.vidInfo.currentPlaybackFrame,...
                    'SliderStep',[svpSettings.sliderMinorStep svpSettings.sliderMajorStep],...
                    'Position', [svpSettings.sliderX,svpSettings.sliderY,svpSettings.sliderWidth,svpSettings.sliderHeight]);

    svp.Slider.Units = "normalized";
    addlistener(svp.Slider, 'Value', 'PostSet', @slider_post_update_function);
    % addlistener(SliderVideoPlayerSettings.Slider, 'Value', 'PreSet', slider_pre_update_function);

%     function slider_pre_update_function(src, event_obj)
%         % ~            Currently not used (empty)
%         % event_obj    Object containing event data structure
%         % Pause the video here:
% 
%     end

    function slider_post_update_function(~, event_obj)
        % ~            Currently not used (empty)
        % event_obj    Object containing event data structure
        % Play the video here:
        % Get the frame from the slider:
    %     updatedFrame = get(event_obj,'NewValue');

        % the slider is the frame number from 1 - length, not the currently loaded indexes
        slider_frame = round(event_obj.AffectedObject.Value);

        % Jump to frame:
%         global svp;
        svp.vidPlayer.DataSource.Controls.jumpTo(slider_frame); % Update the video frame
        final_frame = svp.vidInfo.frameIndexes(1) + slider_frame;
        dualcursor([final_frame final_frame]);
    end

    function video_player_play_callback(~, event_obj)
        % ~            Currently not used (empty)
        % event_obj    Object containing event data structure
        % Play the video here:
        % Get the frame from the slider:
    %     updatedFrame = get(event_obj,'NewValue');

        % the slider is the frame number from 1 - length, not the currently loaded indexes
        slider_frame = round(event_obj.AffectedObject.Value);

        % Jump to frame:
%         global svp;
        svp.vidPlayer.DataSource.Controls.jumpTo(slider_frame); % Update the video frame
        final_frame = svp.vidInfo.frameIndexes(1) + slider_frame;
        dualcursor([final_frame final_frame]);
    end

end

