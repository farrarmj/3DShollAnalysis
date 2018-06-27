function [fils,im] = generateFilamentData(varargin)
%This function takes a trace in Imaris and converts it to
%a Matlab data file. Each point on each filament is assigned a coordinate
%in micrometers and a connectivity matrix is used to determine the linkage
%between nodes

%Select file to analyze
[file,folder] = uigetfile('*.ims');
cd(folder)

%Open Imaris if not open, but make invisible
if ~nargin
    im = StartImaris();
    im.SetVisible(0);
    pause(5);
else
    im = varargin{1};
end

%Open Target File
im.FileOpen(strcat(folder,file),[]);
%Get Scene Data
scene = im.GetSurpassScene;
%Get number of scene children
n = scene.GetNumberOfChildren();

%Create Factory Object
fac = im.GetFactory();

%Find the filament object 
for j=1:n
    temp = scene.GetChild(j);
    if fac.IsFilaments(temp)
        filObj = fac.ToFilaments(temp);
    end
end



%Should only be 1 filament object
if(filObj.GetNumberOfFilaments()>1)
    warndlg('More than 1 Filament.  Using index 0 only')
end

%Initialize filament structure variable
fils.X = [];    %filament point coordinates
fils.edg = [];  %edge indices
fils.cnnx = []; %connectivity matrix
fils.branchIdx = []; %index of branch locations
fils.firstIdx  = []; %index of point at beginning of filament 

%Get positions of each tracked point from Imaris Filament Object
fils.X = filObj.GetPositionsXYZ(0);
%Get connectivity from Imaris Filament Object
edg = filObj.GetEdges(0); %Get index of edges
fils.edg = edg+1; % Map onto Matlab indexing (starts at 1, not 0)

%Create connectivity matrix based on number of edges
M(1:length(edg)+1,1:length(edg)+1) =0;
for j=1:length(edg)
    M(fils.edg(j,1),fils.edg(j,2)) = 1;
    M(fils.edg(j,2),fils.edg(j,1)) = 1;
end
fils.cnnx = sparse(M);

%Find branch indices. A point on an unbranched filament has a connectivity
%of 2 (i.e. one point before and after), while a true branch point has
%more than 2 points connected to it.
fils.branchIdx = find(sum(M)>2); 

%Index of start point, typically close to soma
%NB: We added the position of the soma from the Imaris software directly
%rather than writing a script
fils.firstIdx = filObj.GetBeginningVertexIndex(0)+1;

%Save Result
ok =questdlg('Save results?','Save Results?','Yes','No','Yes');
if strcmp(ok,'Yes')
    save(strcat(file(1:end-3),'mat'),'fils');
end
    
%Quit Imaris
ok = questdlg('Quit Imaris?','Quit Imaris','Yes','No','Yes');
if ~strcmp(ok,'No')
    im.Quit();
end