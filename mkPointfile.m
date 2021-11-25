function [ error ] = mkPointfile( step, degree, projectName )
%mkPointfile Create pointfiles for simulation plots   
%   All units are in Earth radius and the density is ploted. This script
%   creates the pointfiles foor hcintpol. 
%
%   step  : resolution in RE
%   degree: resolution in degree
%
%   Developed by Gabor Facsko (facsko.gabor@wigner.hu)
%   Wigner Research Centre for Physics, Budapest, 2021
%
% ------------------------------------------------------------------------
%
    error=0;
    xmin=-20;%-30.;
    xmax=240;%20.;
    x0=-64;%31;%-10.;
    ymin=-64;%-64;%-25.;
    ymax=64;%64;%25.;
    y0=0.;
    zmin=ymin;
    zmax=ymax;
    z0=y0;
    % Earth radius in m
    RE=6378000;
    % path
    root_path=['/home/facskog/Projectek/Matlab/',projectName,...
        '/pointfiles/'];
       
     % XY Quicklook plot
     fid=fopen([root_path,'xyPointfile-',projectName,'-',num2str(step),...
         'RE.dat'], 'w');                
     for x=xmin:step:xmax
         for y=ymin:step:ymax            
             fprintf(fid,'%i\t%10i\t%10i\n',x*RE,y*RE,z0);
         end;
     end;
     fclose(fid);
     
     % XZ Quicklook plot
     fid=fopen([root_path,'xzPointfile-',projectName,'-',num2str(step),...
         'RE.dat'], 'w');                
     for x=xmin:step:xmax
         for z=zmin:step:zmax            
             fprintf(fid,'%i\t%10i\t%10i\n',x*RE,y0,z*RE);
         end;
     end;
     fclose(fid);
     
%     % YZ Quicklook plot
%     fid=fopen([root_path,'yzPointfile-',projectName,'-',num2str(step),...
%         'RE.dat'], 'w');   
%     for x=xmin:step:xmax
%         for y=ymin:step:ymax
%             for z=zmin:step:zmax            
%                 fprintf(fid,'%i\t%10i\t%10i\n',x*RE,y*RE,z*RE);
%             end;
%         end;
%     end;
%     fclose(fid);
    
%     % Ionospheric plot - North
%     fid=fopen([root_path,'nPointfile-',projectName,'-',...
%         num2str(degree),'.dat'], 'w');
%     for long=0:degree:360
%         for lat=55:degree:88
%             fprintf(fid,'%i\t%10i\n',lat,long);
%         end;
%     end;
%     fclose(fid);
    
%     % Ionospheric plot - South
%     fid=fopen([root_path,'sPointfile-',projectName,'-',...
%         num2str(degree),'.dat'], 'w');
%     for long=0:step:360
%         for lat=-88:step:-55            
%             fprintf(fid,'%i\t%10i\n',lat,long);
%         end;
%     end;
%     fclose(fid);
end

