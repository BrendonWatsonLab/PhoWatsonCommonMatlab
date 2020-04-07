classdef UserAnnotationsManager
    %FramesListManager Keeps track of user-annotated frames in a class
    %   Holds an array of UserAnnotation objects
    
    properties
        VideoFileInfo
        UserAnnotationArrayNames
        UserAnnotationObjArrays
        AnnotatingUser
    end
    
    methods
        function obj = UserAnnotationsManager(videoFileIdentifier, videoFileNumFrames, annotatingUser)
            %FRAMESMANAGER Construct an instance of this class
            %   Detailed explanation goes here
            currVideoFileInfo.videoFileIdentifier = videoFileIdentifier;
            currVideoFileInfo.videoFileNumFrames = videoFileNumFrames;
            
            if ~exist('annotatingUser','var')
                annotatingUser = 'Anonymous';
            end  
            obj.AnnotatingUser = annotatingUser;
            
            obj.VideoFileInfo = currVideoFileInfo;
            
%             obj.UserAnnotationArrayNames = 'Temp';
            obj.UserAnnotationObjArrays = {};
            obj.addAnnotationType('Temp');
            
        end
        
        function TF = addAnnotationType(obj, typeName)
            %METHOD1 Adds a new annotation type
            %   Detailed explanation goes here
%             if isempty(ismember(typeName, obj.UserAnnotationArrayNames))
            if ~any(strcmp(obj.UserAnnotationArrayNames,typeName))
                % Type already exists
                TF = false;
            else
                % type doesn't yet exist, create it
                TF = true;
                obj.UserAnnotationArrayNames{end+1} = typeName;
                obj.UserAnnotationObjArrays.(typeName) = {};
            end
            
        end
        
        
        function createAnnotation(obj, typeName, frameNumber, comment)
            %createAnnotation Adds a new annotation object to an existing typeArray
            if ~exist('frameNumber','var')
                error('Requires the frameNumber!')
            end
            
            if ~exist('comment','var')
                comment = '';
            end  
            
            if ~any(strcmp(obj.UserAnnotationArrayNames,typeName))
                % Type already exists
                newAnnotationObj = UserAnnotation(frameNumber, comment, obj.AnnotatingUser);
                %             (obj.UserAnnotationObjArrays.(typeName)){end+1} = newAnnotationObj;
                obj.UserAnnotationObjArrays.(typeName) = {obj.UserAnnotationObjArrays.(typeName), newAnnotationObj};
            else
                % type doesn't yet exist, create it
                error('type does not exist!')
            end
            
        end
        
        
        
        %% Getters:
        function name = getAnnotationName(obj, idx)
            %METHOD1 Gets the name of an annotation type at a given index
            name = obj.UserAnnotationArrayNames{idx};   
        end
        
        function array = getAnnotationArray(obj, typeName)
            %METHOD1 Gets the array at a given typeName
            array = obj.UserAnnotationFrameArrays.(typeName);   
        end
        
        
    end
end

