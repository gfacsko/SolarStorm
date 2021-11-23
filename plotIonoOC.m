function [ error ] = plotIonoOC( simDir, mstateFilename, dump)
global GEOPACK1;
%plotIonoOC Plots open-closed field line boundary on ionosphere plot.
%
%   simDir        : Location of the simulation
%   mstateFilename: Processed filename
%   dump          : Dump the data from simulation savings file or use 
%                   the existing data
%
%   Developed by Gabor Facsko (facsko.gabor@wigner.hu)
%   Wigner Research Centre for Physics, 2012-2021
%
% ------------------------------------------------------------------------
   
    % Normal start
    error=0; 
%    path(path,'/home/facskog/Projectek/Matlab/geopack');
    % E radius in m
    RE=6380000;
    root_path='/home/facskog/Projectek/Matlab/SolarStorm/';  
    sim_path=['/home/facskog/GUMICS4/',simDir,'/'];

    % Getting time from mstateFilename
    year=str2double(mstateFilename(7:10));
    month=str2double(mstateFilename(11:12));
    day=str2double(mstateFilename(13:14));
    hour=str2double(mstateFilename(16:17));
    minute=str2double(mstateFilename(18:19));
    tStart=datenum(year,month,day,hour,minute,0);        
       
    % Open-close line boundary cap ---------------------------------------
    % Count lines/existence
    ocFilename=[sim_path,mstateFilename(1:21),'.oc'];
    [status,result]=unix(['wc -l ',ocFilename]);
    % Is there ocfile at all?
    isOCFile=0;
    if (isempty(strfind(result,'such'))),isOCFile=1;end;
    % Read the ocfile if it exists
    if (isOCFile)
        Noc=str2double(result(1:strfind(result,' ')));
        % Two hemisphera
        ocNorthArray=zeros(Noc,2);
        ocSouthArray=zeros(Noc,2);
        ocNorthArray=load(ocFilename);
        % Convert coordinate system - South
        [ocSouthArray(:,2),ocSouthArray(:,1)]=...
            pol2cart(pi/2-ocNorthArray(:,2),pi-ocNorthArray(:,1));
        % Convert coordinate system - North
        [ocNorthArray(:,2),ocNorthArray(:,1)]=...
            pol2cart(pi/2+ocNorthArray(:,2),ocNorthArray(:,1));            
    end;
    
    % Ionospheric plots -------------------------------------------------- 
    % hem = 'hemisphere', N/S
    for hem=['n','s']
        % Dump Northerm or Southerm hemispheres
        if (dump)
            [status,result]=unix(['/home/facskog/gumics/appl/gumics/ionointpol -n -v phi,SigmaP,SigmaH,jPar,precip ',...
                sim_path,'i',mstateFilename(2:length(mstateFilename)-3),'.tri < ',...
                root_path,'pointfiles/',hem,'Pointfile-ECLAT-0.5.dat',' > ',...
                root_path,'data/',hem,'Dump-',mstateFilename(7:21),'.dat']);        
        end;       

        % Northerm or Southerm hemisphere Quicklook plot       
        % Read data  % lat lon phi SigmaP SigmaH jPar precip      
        dumpFilename=[root_path,'data/',hem,'Dump-',mstateFilename(7:21),...
            '.dat'];
        An=load(dumpFilename);
        % Coordinate conversion
        if (hem=='n')
            [An(:,2),An(:,1)]=pol2cart(pi/2+An(:,2)*pi/180,...
                sin((90-An(:,1))*pi/180));     
        end;
        if (hem=='s')
            [An(:,2),An(:,1)]=pol2cart(pi/2-An(:,2)*pi/180,...
                sin((90-An(:,1))*pi/180));     
        end;
        % Get matrix
        [C,X,Y]=getMatrix(An);
        % Delete colour edges. The reason of their apperance is that the 
        % white color is NOT the zero color, except for FAC
        for i=1:numel(An(:,1))
            if (sqrt(An(i,1)^2+An(i,2)^2)>pi/6-0.01)
                An(i,4)=5;
                An(i,5)=6;
                An(i,7)=3*10^(-4);
            end;
        end;           

        % Figure in the background   
        p = figure('visible','off'); 

        % Plot all subplots
        for ip=1:4
            % Plot pattern
            switch ip
                case 1
                    % SigmaP
                    subplot('Position',[0.1 0.5 0.4 0.4]);
                    scatter(An(:,2),An(:,1),5,An(:,4),'d','filled');
                case 2
                    % FAC
                    subplot('Position',[0.1 0.03 0.4 0.4]); 
                    scatter(An(:,2),An(:,1),5,An(:,6),'d','filled');
                case 3
                    % SigmaH
                    subplot('Position',[0.55 0.5 0.4 0.4]);
                    scatter(An(:,2),An(:,1),5,An(:,5),'d','filled');
                case 4
                    % Precipitation
                    subplot('Position',[0.55 0.03 0.4 0.4]);
                    scatter(An(:,2),An(:,1),5,An(:,7),'d','filled');
            end;       
            axis equal tight off;
            axis([-pi/6 pi/6 -pi/6 pi/6]);
            if (ip==1)   
                prefix='Northern';
                if (hem=='s'),prefix='Southern';end;                
                text(0.85,0.70,[prefix,' hemisphere ionosphere plots at ',...
                    mstateFilename(16:17),':',mstateFilename(18:19),' on ',...
                    datestr([str2num(mstateFilename(7:10))...
                    str2num(mstateFilename(11:12))...
                    str2num(mstateFilename(13:14)) 0 0 0],'dd mmm yyyy')],...
                    'HorizontalAlignment','Center');               
            end;
            % Colormap - only once for one file
            if (ip==1),colormap(getColormap(256,'seismic'));end;
            % Once per subplot
            cb=colorbar;    
            switch ip
                case 1
                    % SigmaP
                    caxis([0,10]);
                    set(get(cb,'YLabel'),'String','\Sigma_P [{\Omega}^{-1}]',...
                        'Rotation',270,'VerticalAlignment','Bottom');   
                case 2
                    % FAC
                    caxis([-4*10^-8, 4*10^-8]);          
                    set(get(cb,'YLabel'),'String','FAC [A m^{-2}]',...
                        'Rotation',270,'VerticalAlignment','Bottom');
                case 3
                    % SigmaH
                    caxis([0,12]);
                    set(get(cb,'YLabel'),'String',...
                        '\Sigma_H [{\Omega}^{-1}]','Rotation',270,...
                        'VerticalAlignment','Bottom'); 
                case 4
                    % Precipitation
                    caxis([0,6*10^-4]);
                    set(get(cb,'YLabel'),'String',...
                        'Precipitation [W m^{-2}]','Rotation',270,....
                        'VerticalAlignment','Bottom')
            end;              
            hold on;                   
            % Convert amount to equivalent grid
            if (ip==2),plotE(An,2.5,hem);end;         
            % Plot electric potential contours 
            contour(X,Y,C,'c');                       
            % Plot polar cap
            if (isOCFile)
                if (hem=='n'),plot(ocNorthArray(:,2),ocNorthArray(:,1),'.k');end;
                if (hem=='s'),plot(ocSouthArray(:,2),ocSouthArray(:,1),'.k');end;
            end;                         
            % Coordinate network
            plotNetwork(hem);           
            % Delete the wrong contours around the plot
            rectangle('Position',[-0.6,-0.6,1.2,1.2],...
                'FaceColor','none','EdgeColor',[0.99 0.99 0.99],'Curvature',[1,1],...
                'LineWidth',17);   
            % Delete the wrong contours in the center of the plot
             rectangle('Position',[-0.035,-0.035,0.07,0.07],...
                 'FaceColor',[0.99 0.99 0.99],'EdgeColor',[0.99 0.99 0.99],...
                 'Curvature',[1,1],'LineWidth',1);            
            % End of plot
            hold off;
        end;

        % Save image
        prefix='north';
        if (hem=='s'),prefix='south';end;
        print(p,'-depsc2',[root_path,'images/',prefix,'IonoPlot-',...
            mstateFilename(7:21),'.eps']);
        % Closing the plot box
        close;              
     end;
end

