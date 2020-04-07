classdef UserAnnotationsManager < handle & matlab.mixin.CustomDisplay
    %FramesListManager Keeps track of user-annotated frames in a class
    %   Holds an array of UserAnnotation objects
    
    properties
        VideoFileInfo
        UserAnnotationArrayNames
        UserAnnotationArrayDescriptions
        UserAnnotationObjMaps
        AnnotatingUser
    end
    
    methods
        function obj = UserAnnotationsManager(videoFileIdentifier, videoFileNumFrames, annotatingUser)
            %UserAnnotationsManager Construct an instance of this class
            currVideoFileInfo.videoFileIdentifier = videoFileIdentifier;
            currVideoFileInfo.videoFileNumFrames = videoFileNumFrames;
            
            if ~exist('annotatingUser','var')
                annotatingUser = 'Anonymous';
            end  
            obj.AnnotatingUser = annotatingUser;
            
            obj.UserAnnotationArrayNames = {};
            obj.UserAnnotationArrayDescriptions = {};
            
            obj.VideoFileInfo = currVideoFileInfo;
            
            obj.UserAnnotationObjMaps = {};
            
            % Add a default type
            obj.addAnnotationType('Temp');
        end
        
        
        %% Annotation Type Objects:
        function TF = addAnnotationType(obj, typeName, typeDescription)
            %addAnnotationType Adds a new annotation type

            if ~exist('typeDescription','var')
                typeDescription = '';
            end            
            
%             if isempty(ismember(typeName, obj.UserAnnotationArrayNames))
            if any(strcmp(obj.UserAnnotationArrayNames,typeName))
                % Type already exists
                TF = false;
            else
                % type doesn't yet exist, create it
                TF = true;
                obj.UserAnnotationArrayNames{end+1} = typeName;
                obj.UserAnnotationArrayDescriptions{end+1} = typeDescription;
                obj.UserAnnotationObjMaps.(typeName) = containers.Map('KeyType','uint32','ValueType','any'); % might need to be 'any'
            end
            
        end
        
        function TF = modifyAnnotationType(obj, originalTypeName, modifiedTypeName, modifiedTypeDescription)
            %METHOD1 Changes an existing annotation type's name or
            %modifiedType description.
            %   Pass empty strings if you don't want them to change.
         
            matchingArrayNameIndicies = strcmp(obj.UserAnnotationArrayNames, originalTypeName);
            if any(matchingArrayNameIndicies)
                % Type already exists, modify it
                TF = true;
                if exist('modifiedTypeName','var')
                    if ~isempty(modifiedTypeName)
                        obj.UserAnnotationArrayNames{matchingArrayNameIndicies} = modifiedTypeName;
                    end
                end            
                if exist('modifiedTypeDescription','var')
                    if ~isempty(modifiedTypeDescription)
                        obj.UserAnnotationArrayDescriptions{matchingArrayNameIndicies} = modifiedTypeDescription;
                    end
                end                  
                
            else
                % type doesn't yet exist
                TF = false;
                error('Type attempting to be modified does not exist!')
                
            end
            
        end
        
        %% Annotation Objects:
        function createAnnotation(obj, typeName, frameNumber, comment)
            %createAnnotation Adds a new annotation object to an existing typeArray
            if ~exist('frameNumber','var')
                error('Requires the frameNumber!')
            end
            
            if ~exist('comment','var')
                comment = '';
            end  
            
            if any(strcmp(obj.UserAnnotationArrayNames,typeName))
                % Type already exists
                if isKey(obj.UserAnnotationObjMaps.(typeName),frameNumber)
                   % frame already exists
                   obj.UserAnnotationObjMaps.(typeName)(frameNumber).modifyComment(comment);
                else
                   % frame does not yet exist
                   newAnnotationObj = UserAnnotation(frameNumber, comment, obj.AnnotatingUser);
                   obj.UserAnnotationObjMaps.(typeName)(frameNumber) = newAnnotationObj;
                end
            else
                % type doesn't yet exist, create it
                error('type does not exist!')
            end
            
        end
        
        function removeAnnotation(obj, typeName, frameNumber)
            %removeAnnotation Removes an existing annotation object at a given frameNumber for an existing typeArray
            if ~exist('frameNumber','var')
                error('Requires the frameNumber!')
            end

            if any(strcmp(obj.UserAnnotationArrayNames,typeName))
                % Type already exists
                
                if isKey(obj.UserAnnotationObjMaps.(typeName),frameNumber)
                   % frame already exists
				   remove(obj.UserAnnotationObjMaps.(typeName),frameNumber); % remove the frame
                else
                   % frame does not yet exist
					warning('frame does not exist!')
                end
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
        
        function map = getAnnotationMap(obj, typeName)
            %METHOD1 Gets the array at a given typeName
            map = obj.UserAnnotationObjMaps.(typeName);   
        end
        
        function array = getAnnotationsArray(obj, typeName)
            %METHOD1 Gets the array at a given typeName
            array = obj.getAnnotationMap(typeName).values;   
        end
        
        function array = getAnnotationsFrames(obj, typeName)
            %METHOD1 Gets the array at a given typeName
            array = obj.getAnnotationMap(typeName).keys;   
        end
        
        %% Aggregate and Combined:
        
        function foundFrameAnnotationObjs = getAllAnnotationsForFrame(obj, frameNumber, typeNames)
            %METHOD1 Gets all annotations for the specified frameNumber
            %that are of the types listed in typeNames, or all if
            %unspecified.
            if ~exist('frameNumber','var')
                error('Requires the frameNumber!')
            end
            
            if ~exist('typeNames','var')
                typeNames = obj.UserAnnotationArrayNames;
            end
            
            for i=1:length(typeNames)
               currTypeName = typeNames{i};
               currAnnotationMap = obj.getAnnotationMap(currTypeName);
               % if this frame exists as a key, add it to the output array:       
               if isKey(currAnnotationMap, frameNumber)
                   currExplicitAnnotation = ExplicitlyTypedUserAnnotation.createExplicitlyTypedFromRegular(currAnnotationMap(frameNumber), currTypeName);
%                    foundFrameAnnotationObjs{end+1} = currAnnotationMap(frameNumber);
                   foundFrameAnnotationObjs{end+1} = currExplicitAnnotation;
               end
            end  
        end
        
        
        function flatMap = flattenAnnotationsToFrames(obj)
            %flattenAnnotationsToFrames Produces a flat map with a list of one or more ExplictlyTypedUserAnnotations at any frame in UserAnnotationObjMaps. the array at a given typeName
            flatMap = containers.Map('KeyType','uint32','ValueType','any');
            
            for i=1:length(obj.UserAnnotationArrayNames)
                currTypeName = obj.getAnnotationName(i);
                currAnnotationMap = obj.getAnnotationMap(currTypeName);
                currFrames = currAnnotationMap.keys;
                for j = 1:length(currFrames)
                    currFrame = currFrames(j);
                    currExplicitAnnotation = ExplicitlyTypedUserAnnotation.createExplicitlyTypedFromRegular(currAnnotationMap(currFrame), currTypeName);
					if isKey(flatMap, frameNumber)
					   % already exists from another type, add it to the array
					   flatMap(currFrame) = {flatMap(currFrame), currExplicitAnnotation};
					else
					   flatMap(currFrame) = {currExplicitAnnotation};
					end
                end
            end
              
        end
        
        
    end
end

