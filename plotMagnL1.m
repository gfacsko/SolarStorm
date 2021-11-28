function [ error ] = plotMagnL1( simDir, mstateFilename, step, dump )
%plotMagnl1 Plots the magnetosphere and the IP shock from the L1 point
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
 
    error=0; 
    % RE radius in m
    RE=6380000;
    root_path='/home/facskog/Projectek/Matlab/SolarStorm/';  
    sim_path=['/home/facskog/GUMICS4/',simDir,'/'];
   
    % Circle
    angle=2*pi*(0:15:360)/360;
    r=3.7;
    
    % Boundaries
    xMin=-20;
    xMax=240;
    yMin=-60; %64
    yMax=60; %64
    zMin=yMin;
    zMax=yMax;
    % The leap on the plots
    gridStep=20;
   
    % Getting time from mstateFilename  
    year=str2num(mstateFilename(7:10));
    month=str2num(mstateFilename(11:12));
    day=str2num(mstateFilename(13:14));
    hour=str2num(mstateFilename(16:17));
    minute=str2num(mstateFilename(18:19));
    tStart=datenum(year,month,day,hour,minute,0);        

     % Dump XY, XZ, YZ
    if (dump)
        [status,result]=unix(['/home/facskog/gumics/hcvis/hcintpol -n -v n,P,beta ',...
            sim_path,mstateFilename,' < ',...
            root_path,'pointfiles/xyPointfile-SolarStorm-',...
                num2str(step),'RE.dat',' > ',root_path,...
                'data/xyDump-',mstateFilename(7:21),'.dat']);         
        [status,result]=unix(['/home/facskog/gumics/hcvis/hcintpol -n -v n,P,beta ',...
            sim_path,mstateFilename,' < ',...
            root_path,'pointfiles/xzPointfile-SolarStorm-',...
                num2str(step),'RE.dat',' > ',root_path,...
                'data/xzDump-',mstateFilename(7:21),'.dat']);    
%         [status,result]=unix(['/home/facskog/gumics/hcvis/hcintpol -n -v n,P,beta ',...
%                 sim_path,mstateFilename,' < ',...
%                 root_path,'pointfiles/yzPointfile-SolarStorm-1RE.dat',' > ',...
%                 root_path,'data/yzDump-',mstateFilename(7:21),'.dat']);
    end;       

      
    % Load XY file
    Nxy=40401; 
    Axy=zeros(Nxy,6);  
    xyDumpFilename=[root_path,'data/xyDump-',mstateFilename(7:21),'.dat'];
    Axy=load(xyDumpFilename);
    % Do not execute for empty files
    if (numel(Axy)>0)
        Axy(:,1:3)=Axy(:,1:3)/RE;
        Axy(:,4)=Axy(:,4)/10^6;
        Axy(:,5)=log(Axy(:,5)*10^12);       
    end;
    
    % Load xz file
    Nxz=Nxy; 
    Axz=zeros(Nxz,6);     
    xzDumpFilename=[root_path,'data/xzDump-',mstateFilename(7:21),'.dat'];
    Axz=load(xzDumpFilename);
    % Do not execute for empty files
    if (numel(Axz)>0)        
        Axz(:,1:3)=Axz(:,1:3)/RE;
        Axz(:,4)=Axz(:,4)/10^6;
        Axz(:,5)=log(Axz(:,5)*10^12);
    end;
    
%     % Load yz file
%     Nyz=Nxy; 
%     Ayz=zeros(Nyz,6);  
%     yzDumpFilename=[root_path,'data/yzDump-',mstateFilename(7:21),'.dat'];
%     Ayz=load(yzDumpFilename);
%     % Do not execute for empty files
%     if (numel(Ayz)>0)       
%         Ayz(:,1:3)=Ayz(:,1:3)/RE;
%         Ayz(:,4)=log(Ayz(:,4)/10^6);
%         Ayz(:,5)=log(Ayz(:,5)*10^12);
%     end;

    % Do not execute for empty files
%    if (numel(Axy)*numel(Axz)*numel(Ayz)>0)
    if (numel(Axy)*numel(Axz)>0)
        % Figure in the background   
        p = figure('visible','off');   
           
        % XY plot ------------------------------------------------------------
               
        % Color bar with text, appropriate colourrange                               
        subplot('Position',[0.9 0.15 0.05 0.75]);     
        colormap(getColormap(1024,'jet'));
        cb=colorbar;
        caxis([round(min(Axz(:,4))/5)*5,round(max(Axz(:,4))/5)*5]); 
        set(get(cb,'YLabel'),'String','\rho [{cm}^{-3}]',...
             'Rotation',270,'VerticalAlignment','Bottom'); 
        axis off;
        
        % Plot XY -------------------------------------------------------
        %subplot('Position',[0.1 0.75 0.7 0.2]);        
        subplot('Position',[0.1 0.55 0.8 0.4]);                  
       % set(get(cb,'YLabel'),'String','log(\rho) [{cm}^{-3}]',...
          %  'Rotation',270,'VerticalAlignment','Bottom'); 
        % Plot the appropriate quantity
        scatter(Axy(:,1),Axy(:,2),2,Axy(:,4),'s','filled');
        set(gca,'XTick',xMin:gridStep:xMax);    
        set(gca,'YTick',yMin:gridStep:yMax);
      %  xlabel('X_{GSE} [R_{E}]');
        datetick('x',' ');
        ylabel('Y_{GSE} [R_{E}]');   
        axis([xMin xMax yMin yMax]);           
        hold on;
        % Circle
        plot(r*sin(angle),r*cos(angle),'-w');   
        % Grid (the grid command is overplotted)
        for ix=xMin+gridStep:gridStep:xMax-gridStep
            plot([ix,ix],[yMin,yMax],'-.w');
        end;
        for iy=yMin+gridStep:gridStep:yMax-gridStep
            plot([xMin,xMax],[iy,iy],'-.w');
        end;
        % Information
        %text(10,40,'XY plane, Z=0 R_{E}');
        
        % XZ plot ---------------------------------------------------------
                       
        % Colormap   
       % colormap(getColormap(256,'jet')); 
        % Appropriate colourrange            
       % caxis([0, round(max(Axz(:,4)))]); 
        % Colorbar with text
      %  cb=colorbar;   
      
        subplot('Position',[0.1 0.1 0.8 0.4]);        
        % Plot the appropriate quantity
        scatter(Axz(:,1),Axz(:,3),2,Axz(:,4),'s','filled');          
        set(gca,'XTick',xMin:gridStep:xMax);    
        set(gca,'YTick',zMin:gridStep:zMax);          
        xlabel('X_{GSE} [R_{E}]');
        ylabel('Z_{GSE} [R_{E}]');                 
        axis([xMin xMax zMin zMax]);        
        hold on;
        % Circle
        plot(r*sin(angle),r*cos(angle),'-w'); 
        % Grid (the grid command is overplotted)
        for ix=xMin+gridStep:gridStep:xMax-step
            plot([ix,ix],[zMin,zMax],'-.w');
        end;
        for iz=zMin+gridStep:gridStep:zMax-step
            plot([xMin,xMax],[iz,iz],'-.w');
        end;
        % Information
        %text(10,40,'XZ plane, Y=0 R_E');        
                 
        % YZ plot -------------------------------------------------------------

%             % Plot YZ 
%             subplot('Position',[0.55 0.1 0.4 0.4]);
%             % Plot the appropriate quantity
%             scatter(Ayz(:,2),Ayz(:,3),2,Ayz(:,4+i-1),'s','filled');          
%             set(gca,'XTick',yMin:step:yMax);    
%             set(gca,'YTick',zMin:step:zMax);  
%             axis equal tight;
%             xlabel('Y_{GSE} [R_{E}]');
%             axis([yMin yMax zMin zMax]); 
%             % Appropriate colourrange        
%             cb=colorbar;
%             colormap(getColormap(256,'jet'));
%             switch i
%                 case 1
%                     caxis([-4, 4]);
%                     set(get(cb,'YLabel'),'String','Log(density) [cm^{-3}]',...
%                         'Rotation',270,'VerticalAlignment','Bottom');     
%                 case 2
%                     caxis([-2, 8]);
%                     set(get(cb,'YLabel'),'String','Log(pressure) [pPa]',...
%                         'Rotation',270,'VerticalAlignment','Bottom');     
%                 case 3
%                     caxis([0, 6]);
%                     set(get(cb,'YLabel'),'String','\beta',...
%                         'Rotation',270,'VerticalAlignment','Bottom');  
%             end;        
        %    hold on;
            % Circle
        %    plot(r*sin(angle),r*cos(angle),'--k');   
%             % Grid (the grid command is overplotted)
%             plot([-20,-20],[-25,25],'--k');
%             plot([-10,-10],[-25,25],'--k');
%             plot([0,0],[-25,25],'--k');
%             plot([10,10],[-25,25],'--k');
%             plot([20,20],[-25,25],'--k');
%             plot([-25,25],[-20,-20],'--k');
%             plot([-25,25],[-10,-10],'--k');
%             plot([-25,25],[0,0],'--k');
%             plot([-25,25],[10,10],'--k');  
%             plot([-25,25],[20,20],'--k');  
%            text(-23,22,'YZ plane, X=-10 R_{E}');     
    end;
    hold on;           
        
    prefix='n';              

    print(p,'-depsc2',[root_path,'images/',prefix,'MagnPlot-',...
        mstateFilename(7:21),'.eps']); 

    % Closing the plot box
    close;        
end

