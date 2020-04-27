Pho Matlab Conventions:
Written 4-27-2020
The purpose of this document is to standardize the conventions used within MATLAB code to provide a more reliable, referencable, and modifable code base.

Function Input Settings:

Functions often need to be passed a large number of user-configurable runtime parameters, and listing them all as optional parameters is undesirable due to the MATLAB line-length issues.
To work around this, a MATLAB structure object will be used. Ease of implementation, and the lack of need of another file in the project, make this better than writting a custom class to hold the settings.
The disadvantage is that it's difficult to document these structure objects as fields can be added dynamically in MATLAB. This creates ordering dependencies in the code (the field must be set before it is referenced) and makes it difficult to reuse/repurpose code.
To work around this, a "struct description" will be added as a comment in the function, explaining the contents of the struct and enumerating all of its fields.

