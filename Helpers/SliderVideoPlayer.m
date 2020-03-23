function [svp, svpSettings] = sliderVideoPlayer(svpConfig)
%sliderVideoPlayer Opens a video player with a slider that reflects the current playback position:
%   Pho Hale, 3/17/2020

global svp;
global svpConfig;

%% Input Argument Parsing:
% defaultHeight = 1;
% defaultUnits = 'inches';
% defaultVideoInputMode = 'file';
% expectedVideoInputModes = {'workspaceVariable','file'};
%    
% defaultVideoFilePath = 'X:\Data\Lezio Pupil 2-21-2020\121201\pupil_deeplabcut\video.avi';
% defaultVideoWorkspaceVariableName = 'greyscale_frames';
% 
% p = inputParser;
% validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
% addRequired(p,'frameRate',validScalarPosNum);
% addParameter(p,'videoInputMode',defaultVideoInputMode, @(x) any(validatestring(x,expectedVideoInputModes)));
% addOptional(p,'videoPath',defaultVideoFilePath,@isstring);
% addOptional(p,'workspaceVariableFramesName',defaultVideoWorkspaceVariableName,@isstring);
% 
% parse(p,frameRate,varargin{:});
% 
% % From input parser:
% svpConfig.VidPlayer.frameRate = p.Results.frameRate;
% 
% % Switch on results of the video input mode:
% if (strcmp(p.Results.videoInputMode, 'file'))
%     % If we're in file mode, we don't need the indicies or anything.
%     if ~exist('v','var')
%         
%     end
% else
%     
% end


if ~exist('svpConfig','var')
   disp("No svpConfig specified! Trying to build one from workspace!")
   svpConfig.DataPlot.x = frameIndexes;
   
   % Try to find 'v' VideoReader object.
   if ~exist('v','var')
       svpConfig.VidPlayer.frameRate = 20; %Default to 20fps
   else
       svpConfig.VidPlayer.frameRate = v.FrameRate;
   end
   
   if ~exist('greyscale_frames','var')
      % Try to load from workspace variable:
      if ~exist('curr_video_file.full_path','var')
          error('You must specify a video filepath!');
      else
          % Set filepath from curr_video_file variable:
         svpConfig.VidPlayer.videoSource = curr_video_file.full_path; % from file path 
      end
   else
      % Otherwise try to load from URLS:
      svpConfig.VidPlayer.videoSource = greyscale_frames; % From workspace variable
   end
   disp("Done. Continuing.")
end

% if (~svpConfig)
%     svpConfig.VidPlayer.videoSource = greyscale_frames; % From workspace variable
%     svpConfig.VidPlayer.videoSource = curr_video_file.full_path; % from file path
%     svpConfig.VidPlayer.frameRate = v.FrameRate;
% end

%     svpConfig.DataPlot.x = frameIndexes;
%     svpConfig.DataPlot.y = temp;
%     svpConfig.DataPlot.title = 'Region Intensity';
%     
% %     svpConfig.VidPlayer.videoSource = greyscale_frames; % From workspace variable
%     svpConfig.VidPlayer.videoSource = curr_video_file.full_path; % from file path
%     svpConfig.VidPlayer.frameRate = v.FrameRate;
    
    % Load config:
    svpSettings.shouldShowPairedFigure = false;
    svpSettings.shouldShowPupilOverlay = true;
    svpSettings.shouldShowEyePolygonOverlay = true;
    
    
    % svp: SliderVideoPlayer
    % svpSettings.sliderWidth = 100;
    % svpSettings.sliderHeight = 23;
    % svpSettings.sliderX = 0;
    % svpSettings.sliderY = 40;
    svpSettings.sliderMajorStep = 0.01;
    svpSettings.sliderMinorStep = 0.1;

    %% Plot Window (optional):
    if (svpSettings.shouldShowPairedFigure)
        svp.DataPlot.fig = figure(1);
        clf
        % svp.DataPlot.plotH = plot(frameIndexes, region_mean_per_frame_smoothed);
        svp.DataPlot.plotH = plot(svpConfig.DataPlot.x, svpConfig.DataPlot.y);
        xlabel('Frame Index');
        title(svpConfig.DataPlot.title);
        xlim([svpConfig.DataPlot.x(1), svpConfig.DataPlot.x(end)]);
        dualcursor on;
        dualcursor('onlyOneCursor');
    end
    
    % Video Player
    % vidPlayCallbacks.PreFrameUpdate = @(~,~) disp('Pre Frame changed!');
    % vidPlayCallbacks.PostFrameUpdate = @(~,~) disp('Post Frame changed!');

    % svp.vidPlayer = implay(greyscale_frames, svpConfig.VidPlayer.frameRate);
    svp.vidPlayer = implay(svpConfig.VidPlayer.videoSource, svpConfig.VidPlayer.frameRate);
    spawnPosition = svp.vidPlayer.Parent.Position;
    set(svp.vidPlayer.Parent, 'Position',  [180, 300, 867, 883]);
    
    %% Ready to work:
    svp.vidToolbar = findobj(svp.vidPlayer.Parent,'Tag','uimgr.uitoolbar_Playback');
    playbtn = svp.vidToolbar.Children(7);
    svp.backupCallbacks.playbtn = playbtn.ClickedCallback;


%     
    vidPlayCallbacks.PauseButtonCallback = @(hco,ev) disp('Pause!');
    vidPlayCallbacks.PlayButtonCallback = @(hco,ev) video_player_btn_play_callback(hco,ev);
    vidPlayCallbacks.StopButtonCallback = @(hco,ev) disp('Stop!');
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

    playbtn.ClickedCallback = vidPlayCallbacks.PlayButtonCallback;
        
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

    svp.Slider.Units = "normalized"; %Change slider units to normalized so that it scales with the video window.
    addlistener(svp.Slider, 'Value', 'PostSet', @slider_post_update_function);
    % addlistener(SliderVideoPlayerSettings.Slider, 'Value', 'PreSet', slider_pre_update_function);

%     function slider_pre_update_function(src, event_obj)
%         % ~            Currently not used (empty)
%         % event_obj    Object containing event data structure
%         % Pause the video here:
% 
%     end

% Called when the play button is clicked in the video GUI.
    function video_player_btn_play_callback(hco, ev)
        disp('play button callback hit!');
        svp.backupCallbacks.playbtn(hco, ev);
    end


    function slider_post_update_function(~, event_obj)
        % ~            Currently not used (empty)
        % event_obj    Object containing event data structure
        % Play the video here:
        % Get the frame from the slider:
    %     updatedFrame = get(event_obj,'NewValue');

        % the slider is the frame number from 1 - length, not the currently loaded indexes
        slider_frame = round(event_obj.AffectedObject.Value);

        % Jump to frame:
        svp.vidPlayer.DataSource.Controls.jumpTo(slider_frame); % Update the video frame
        final_frame = svp.vidInfo.frameIndexes(1) + slider_frame;
        if (svpSettings.shouldShowPairedFigure)
            dualcursor([final_frame final_frame]);
        end
        
        currAxes = svp.vidPlayer.Visual.Axes;
%         hold(currAxes,'on')
%         hold(currAxes,'off')
        if (svpSettings.shouldShowEyePolygonOverlay)
           % Add its eye-bound-polygon:
%             hold on;
%             if (exist('svpConfig.additionalDisplayData.eyePolyPlotHandle', 'var'))
%                 disp('Eye poly handle already exists!')
%             else
%                 disp('Pupil circle handle new!')
%             end
            
            hExistingPlot = findobj(currAxes, 'Tag','eyePolyPlotHandle');
            delete(hExistingPlot)
            svpConfig.additionalDisplayData.eyePolyPlotHandle = plot(currAxes, svpConfig.additionalDisplayData.eye_bound_polys{slider_frame},'Tag','eyePolyPlotHandle');
        end

        if (svpSettings.shouldShowPupilOverlay)
            % Add its pupil circle:
%             hold on;
%             if (exist('svpConfig.additionalDisplayData.pupilCirclePlotHandle', 'var'))
%                 disp('Pupil circle handle already exists!')
%             else
%                 disp('Pupil circle handle new!')
%             end
            
            hExistingPupilsPlot = findobj(currAxes, 'Tag','pupilCirclePlotHandle');
            delete(hExistingPupilsPlot)
            svpConfig.additionalDisplayData.pupilCirclePlotHandle = viscircles(currAxes, svpConfig.additionalDisplayData.processedFramePupilInfo_Center(slider_frame,:), svpConfig.additionalDisplayData.processedFramePupilInfo_Radius(slider_frame)); 
            svpConfig.additionalDisplayData.pupilCirclePlotHandle.Tag = 'pupilCirclePlotHandle';
            %       hold off;
        end
        
        
        


        
    end

    % Called when the play button is clicked in the video GUI.
    function video_player_play_callback(~, event_obj)
        % ~            Currently not used (empty)
        % event_obj    Object containing event data structure
        % Play the video here:
        % Get the frame from the slider:
        % the slider is the frame number from 1 - length, not the currently loaded indexes
        slider_frame = round(event_obj.AffectedObject.Value);

        % Jump to frame:
        svp.vidPlayer.DataSource.Controls.jumpTo(slider_frame); % Update the video frame
        final_frame = svp.vidInfo.frameIndexes(1) + slider_frame;
        if (svpSettings.shouldShowPairedFigure)
            dualcursor([final_frame final_frame]);
        end
        
%         if (svpSettings.shouldShowEyePolygonOverlay)
%            % Add its eye-bound-polygon:
%             hold on;
%             plot(eye_bound_polys{activeFrameIndex})
% 
%             % Add its pupil circle:
%             hold on;
%             h = viscircles(processedFramePupilInfo_Center(activeFrameIndex,:), processedFramePupilInfo_Radius(activeFrameIndex)); 
%         end
        
        
    end

end

