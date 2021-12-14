function [ error ] = plotIonoOC( simDir, mstateFilename)
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
        % Figure in the background   
        p = figure('visible','off');      
        subplot('Position',[0.1 0.05 0.8 0.8]);
        axis equal tight off;
        axis([-pi/6 pi/6 -pi/6 pi/6]);
        prefix='Northern';
        if (hem=='s'),prefix='Southern';end;                
        text(0.075,0.7,[prefix,' hemisphere ionosphere plot at ',...
            mstateFilename(16:17),':',mstateFilename(18:19),' on ',...
            datestr([str2num(mstateFilename(7:10))...
            str2num(mstateFilename(11:12))...
            str2num(mstateFilename(13:14)) 0 0 0],'dd mmm yyyy')],...
            'HorizontalAlignment','Center');                          
        
        hold on;        
        
        % Plot polar cap
        if (isOCFile)
            if (hem=='n')
                plot(ocNorthArray(:,2),ocNorthArray(:,1),'.r');
            end;
            if (hem=='s')
                plot(ocSouthArray(:,2),ocSouthArray(:,1),'.r');
            end;
        end;    
        
        % Coordinate network
        plotNetwork(hem);              
        % End of plot
        hold off;

        % Save image
        prefix='north';
        if (hem=='s'),prefix='south';end;
        print(p,'-depsc2',[root_path,'images/',prefix,'IonoPlot-',...
            mstateFilename(7:21),'.eps']);
        % Closing the plot box
        close;              
      end;
end

