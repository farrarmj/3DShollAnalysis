function drawFilaments(varargin)
%This function can be used to generate a 2-D or 3-D representation of
%filament data produced in Imaris

%open new figure without axes
h = figure 
axis off

%Load Matlab data file of filaments
[file,folder] = uigetfile('*.mat');
cd(folder);
load(file)

%Access data structures
cnnx = fils.cnnx; %connectivity matrix
soma = fils.soma; %soma location
X = fils.X;       %coordinates of points on filaments

%Default values for display
C = 'k'; %Drawing color is black
mthd = '2D'; %Default Drawing Method
centre = 'No'; %Do not center soma  at (0,0,0) (default)

clear fils
n = length(cnnx);

%Options block: 2D vs. 3D display, color of data, whether it is
%centered
for j=1:length(varargin)/2
    switch varargin{2*j-1}
        case 'Method'
            mthd = varargin{2*j}
            break
        case 'Color'
            C = varargin{2*j};
            break
        case 'Centre'
            if strcmpi(varargin{2*j},'Yes')
                for j=1:3
                    X(:,j) = X(:,j)-soma(j);
                end
            end
            break
        otherwise
            errordlg(strcat('Unknown parameter',varargin{2*j-1}),'Unrecognized Option');
    end
end
            
            
%Drawing of filaments
for j=1:length(cnnx)
    A = find(cnnx(j,:)); %find its connections
    if ~isempty(A)
        for k=1:length(A)
            %get coordinate pairs
            xx = [X(j,1),X(A(k),1)];
            yy = [X(j,2),X(A(k),2)];
            zz = [X(j,3),X(A(k),3)];
            %draw segment
            if strcmpi(mthd,'3D')
                line(xx,yy,zz,'Color',C);
            else
                line(xx,yy,'Color',C);
            end
            %set connectivity element to 0 so as to avoid double counting
            cnnx(A(k),j) = 0;
        end
    end
    
    %Show drawing of filaments along the way
    if ~mod(j,1000)
        M = getframe;
    end
end

%Draw soma
hold
if strcmpi(mthd,'3D')
    scatter3(soma(1),soma(2),soma(3),250,'g','filled');
else
    scatter(soma(1),soma(2),250,'g','filled');
end
hold
axis square
     