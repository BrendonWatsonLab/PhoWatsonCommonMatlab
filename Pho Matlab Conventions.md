Pho Matlab Conventions:
Written 4-27-2020
The purpose of this document is to standardize the conventions used within MATLAB code to provide a more reliable, referencable, and modifable code base.


Script/Function Prefix:
Each set of scripts/functions that share a common purpose should have an identifying prefix, similar to the MacOS Cocoa namespace conventions.
The prefix should be specified in all lower-case characters, and prepended to any shared structure variables and types.

Example: For the repository PhoMatlabBBVideoAnalyzer, the prefix is "bbva". The structures shared within in them are named "bbvaSettings", "bbvaVideoFile"

Function Input Settings:

Functions often need to be passed a large number of user-configurable runtime parameters, and listing them all as optional parameters is undesirable due to the MATLAB line-length issues.
To work around this, a MATLAB structure object will be used. Ease of implementation, and the lack of need of another file in the project, make this better than writting a custom class to hold the settings.
The disadvantage is that it's difficult to document these structure objects as fields can be added dynamically in MATLAB. This creates ordering dependencies in the code (the field must be set before it is referenced) and makes it difficult to reuse/repurpose code.
To work around this, a "struct description" will be added as a comment in the function, explaining the contents of the struct and enumerating all of its fields.

The astrisk (*) after the field indicates that it's not a computed quanity.

%%%+S- bbvaVideoFile
	%- filename* - filename is the filename with extension
	%- relative_file_path - relative_file_path is a 
	%- basename - basename is a 
	%- extension - extension is a 
	%- full_parent_path - full_parent_path is a 
	%- full_path - full_path is a 
	%- boxID - boxID is a 
	%- parsedDateTime - parsedDateTime is a 
	%- FrameRate - FrameRate is a 
	%- DurationSeconds - DurationSeconds is a 
	%- parsedEndDateTime - parsedEndDateTime is a 
	%- startFrameIndex - startFrameIndex is a 
	%- endFrameIndex - endFrameIndex is a 
	%- frameIndexes - frameIndexes is a 
	%- frameTimestamps - frameTimestamps is a 
	%- FIELDNAME - FIELDNAME is a 
%