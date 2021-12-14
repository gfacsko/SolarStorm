function [ error ] = plotQuickLook_launch( simDir, strRestart )
%plotQuickLook_launch Read the mstate files and generate plots
%  Enters the target directory, list the available mstate files and
%  creates quicklook plots. 
% 
%  strRestart: Restart from here the generation
%
%   Developed by Gabor Facsko (facsko.gabor@wigner.hu)
%   Wigner Research Centre for Physics, 2012-2021
%
% ------------------------------------------------------------------------
%
    error=0;
    tRestart=datenum(strRestart,'yyyymmdd_HHMM');
    % Data path
    sim_path=['/home/facskog/GUMICS4/',simDir,'/'];  
    root_path='/home/facskog/Projectek/Matlab/SolarStorm/';
    
    % Footprint reading initalisation
    strDate='99999999';           
        
    % mstate/istate File list
    [status,result] = unix(['ls -lR ',sim_path,'mstate*.hc']);
    nBegin=strfind(result,sim_path);
    strBegin=result(nBegin(1)+74:nBegin(1)+88);
    tBegin=datenum([str2num(strBegin(1:4)) str2num(strBegin(5:6))...
        str2num(strBegin(7:8)) str2num(strBegin(10:11))...
        str2num(strBegin(12:13)) 0]);        
    nTime=strfind(result,'mstate');           
    
    % Process files
    for it=1:numel(nTime)
        strTime=result(nTime(it)+6:nTime(it)+20)
        t=datenum([str2num(strTime(1:4)) str2num(strTime(5:6))...
            str2num(strTime(7:8)) str2num(strTime(10:11))...
            str2num(strTime(12:13)) 0]);                                                                                    
        % Restart if the script collapses               
        if ((t>tBegin) && (t>tRestart))
            isDump=1;
            % Logging indicator            
            fileStr=result(nTime(it):nTime(it)+23);
            plotMagnL1(simDir,result(nTime(it):nTime(it)+23),1,true);
            plotIonoOC(simDir,result(nTime(it):nTime(it)+23));
             % Compres eps files
             unix(['gzip -f ',root_path,'images/*nMagnPlot-*.eps ']);
             unix(['gzip -f ',root_path,'images/[ns]*IonoPlot-',...
                 fileStr(7:numel(fileStr)-3),'.eps ']);                   
             % Delete data files
             unix(['rm ',root_path,'data/*Dump-',...
                 fileStr(7:numel(fileStr)-3),'.dat']);
        end;
    end;         
end

