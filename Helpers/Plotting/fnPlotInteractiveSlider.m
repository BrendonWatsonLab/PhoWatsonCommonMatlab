%% Requires a two cell arrays: x_cells, y_cells
function [FigH] = fnPlotInteractiveSlider(x_cells, y_cells, extant_fig, seriesConfigs)
%FNPLOTINTERACTIVESLIDER figure with an interactive slider that allows you
	% to scroll through multiple series (x vector, y vector pairs) that will be
	% plotted on the plot.

	% x_cells: an N x 1 cell array of series': composed of arrays of doubles.
	% y_cells: an N x 1 cell array of series': composed of arrays of doubles.
	% extant_fig: an existing figure handle you want to plot on.
	% seriesConfigs: an optional pisConfig object used to add labels, etc
	% to plots
	
	%%%+S- pisInfo
		%= NumberOfSeries - constructed from the actual frame index
		%= curr_i - Current series index: i
		%= lim - The global xlim and ylims for all series
	%
	
	%%%+S- pisConfig
		%- xlabel - an N x 1 cell array of charStrings
		%- ylabel - an N x 1 cell array of charStrings
		%- title - an N x 1 cell array of charStrings
		%= additionalDisplayData.mainPlotAxesHandle - holds the plot axes
	%
	
	
	% pisInfo: plotInteractiveSliderInfo:
	[pisInfo.lim] = fnFindSeriesBounds(x_cells, y_cells, false);

	if ~exist('extant_fig','var')
		% create a new figure
		FigH = figure;
	else
		%clf(extant_fig);
		FigH = extant_fig;
	end

	pisInfo.NumberOfSeries = length(x_cells);
	if (length(y_cells) ~= pisInfo.NumberOfSeries)
		error('x_cells and y_cells should be cell arrays of the same length. This corresponds to the x_cells{i}, y_cells{i} is the series that will be plotted when the slider is set to i.')
	end
	
	if exist('seriesConfigs','var')
		if isfield(seriesConfigs, 'xlabel')
			if ischar(seriesConfigs.xlabel) % If it's a simple char string
				% Repeat the label for each series
				pisConfig.xlabel = cell(1, pisInfo.NumberOfSeries);
				pisConfig.xlabel(:) = {seriesConfigs.xlabel};
			elseif iscellstr(seriesConfigs.xlabel) % if it's a cell array. Note: Assumes correct length
				if (length(seriesConfigs.xlabel) ~= pisInfo.NumberOfSeries)
					error('Wrong length!')
				end
				pisConfig.xlabel = seriesConfigs.xlabel;
			else
				error('Unknown type for: xlabel')	
			end
		end
		
		if isfield(seriesConfigs, 'ylabel')
			if ischar(seriesConfigs.ylabel) % If it's a simple char string
				% Repeat the label for each series
				pisConfig.ylabel = cell(1, pisInfo.NumberOfSeries);
				pisConfig.ylabel(:) = {seriesConfigs.ylabel};
			elseif iscellstr(seriesConfigs.ylabel) % if it's a cell array. Note: Assumes correct length
				if (length(seriesConfigs.ylabel) ~= pisInfo.NumberOfSeries)
					error('Wrong length!')
				end
				pisConfig.ylabel = seriesConfigs.ylabel;
			else
				error('Unknown type for: ylabel')	
			end
		end
		
		if isfield(seriesConfigs, 'title')
			if ischar(seriesConfigs.title) % If it's a simple char string
				% Repeat the label for each series
				pisConfig.title = cell(1, pisInfo.NumberOfSeries);
				pisConfig.title(:) = {seriesConfigs.title};
			elseif iscellstr(seriesConfigs.title) % if it's a cell array. Note: Assumes correct length
				if (length(seriesConfigs.title) ~= pisInfo.NumberOfSeries)
					error('Wrong length!')
				end
				pisConfig.title = seriesConfigs.title;
			else
				error('Unknown type for: title')	
			end
		end
	
	end
	
	% Current index: i
	pisInfo.curr_i = 1;

% 	pisConfig.additionalDisplayData.mainPlotAxesHandle = plot(x_cells{pisInfo.curr_i}, y_cells{pisInfo.curr_i},'Tag','plotInteractiveSliderMainPlotHandle');
% 	%% Add Additional Plot Info:
% 	xlim([pisInfo.lim(1),pisInfo.lim(2)]);
% 	ylim([pisInfo.lim(3),pisInfo.lim(4)]);
% 	if isfield(pisConfig, 'xlabel')
% 		xlabel(pisConfig.xlabel{pisInfo.curr_i});
% 	end
% 	if isfield(pisConfig, 'ylabel')
% 		ylabel(pisConfig.ylabel{pisInfo.curr_i});
% 	end
% 	if isfield(pisConfig, 'title')
% 		title(pisConfig.title{pisInfo.curr_i});
% 	end
	
	update_plots(pisInfo.curr_i);
	
	
	%% Slider:
    % Gets the slider position from the figure
    pisSettings.sliderWidth = FigH.Position(3) - 20;
    pisSettings.sliderHeight = 23;
    pisSettings.sliderX = 5;
    pisSettings.sliderY = 0;

	maxSliderValue = pisInfo.NumberOfSeries;
	minSliderValue = 1;
	theRange = maxSliderValue - minSliderValue;
	pisSettings.steps = [1/theRange, 10/theRange];

    % svp.Slider = uicontrol(svp.Figure,'Style','slider',...
    svp.Slider = uicontrol(FigH,'Style','slider',...
                    'Min',1,'Max',pisInfo.NumberOfSeries,'Value',pisInfo.curr_i,...
					'SliderStep',pisSettings.steps,...
                    'Position', [pisSettings.sliderX,pisSettings.sliderY,pisSettings.sliderWidth,pisSettings.sliderHeight]);

    svp.Slider.Units = "normalized"; %Change slider units to normalized so that it scales with the video window.
    addlistener(svp.Slider, 'Value', 'PostSet', @slider_post_update_function);

	%% Slider callback function:
	function slider_post_update_function(~, event_obj)
        % ~            Currently not used (empty)
        % event_obj    Object containing event data structure

        % get the current index from the slider
        pisInfo.curr_i = round(event_obj.AffectedObject.Value);
		update_plots(pisInfo.curr_i);
		
	end

	function update_plots(curr_i)
		% Update the plot:
		pisConfig.additionalDisplayData.mainPlotAxesHandle = plot(x_cells{curr_i}, y_cells{curr_i},'Tag','plotInteractiveSliderMainPlotHandle');
		xlim([pisInfo.lim(1),pisInfo.lim(2)]);
		ylim([pisInfo.lim(3),pisInfo.lim(4)]);
		if isfield(pisConfig, 'xlabel')
			xlabel(pisConfig.xlabel{pisInfo.curr_i});
		end
		if isfield(pisConfig, 'ylabel')
			ylabel(pisConfig.ylabel{pisInfo.curr_i});
		end
		if isfield(pisConfig, 'title')
			title(pisConfig.title{pisInfo.curr_i});
		end
		
	end

end
