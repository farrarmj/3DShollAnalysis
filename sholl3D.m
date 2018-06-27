function [crossings,radius] = sholl3D(varargin)
%This function computes the number of neurites crossings spheres
%of different radii. The input file is a Matlab-generated data
%file based on an Imaris tracing of the neuron in 3D

umPerPix = 0.343; %pixel conversion factor on cusotm microscope
Rmax = 2*1024*umPerPix; %maximum radius for analysis

%Get Imaris filaments file to analyze if not provided
if ~nargin || isempty(varargin{1})
    [file,folder] = uigetfile('*.mat');
    cd(folder)
else
    file = varargin{1};
end

%Open file
load(file)

%Create Coordinates of Filaments
Xfil = fils.X;

%Get soma location to use as center
xo = fils.soma;

%set the new origin as the soma
for j=1:3
    X(:,j) = Xfil(:,j)-xo(j);
end

%Calculte a radius for each filament coordiante
radii = sqrt(sum(X.^2,2));

%Create a radius vector in increments of 1 µm
radius = 0:1:Rmax;

%initialize the number of crossings to 0
crossings(1:length(radius)) = 0;
for j=1:length(radius)
    %find all filament points inside the sphere of current radius
    A = find(radii<=radius(j));
    %initialize the number of filament crossings of this sphere to 0
    count = 0; 
    
    %Count the number of crossings for a given radius
    for k=1:length(A)
        %Identify adjacent connected points on filaments 
        %by using a connectivity matrix
        temp = A(k);
        B = find(fils.cnnx(temp,:));
        %Search for any adjacent points that are outisde the sphere of
        %current radius
        relPoints = find(radii(B)>radius(j));
        %Any point on a filament outside the sphere connected to a point
        %inside the sphere constitutes a single crossing
        if ~isempty(B)
            count = count + length(find(radii(B)>radius(j)));
        end
    end
    %The total number of crossings for a given radius
    crossings(j) = count;
    %Remove previously considered points from future analysis
    radii(A) = NaN; %remove from further analysis
end
        
    
    