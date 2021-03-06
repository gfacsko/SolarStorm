function [ map ] = getColormap( Ncolor, select )
%getColormap Create a colormap
%   Create a colormap, the extention of the defaults "jet" (prism)
%   colormap.
%
%   Ncolor: Resolution
%   select: 'jet' or 'seismic'
%   map   : Colormap
%
%   Developed by Gabor Facsko (gabor.facsko@fmi.fi), 2012
%   Finnish Meteorologycal Institute, Helsinki
%----------------------------------------------------------------------
%
    % Jet
    if (strfind(select,'jet')==1)
        % RGB map defition
        R=(1:Ncolor);
        G=(1:Ncolor);
        B=(1:Ncolor); 
        for i=1:Ncolor        
            % Red
            if (i<3/8*Ncolor),R(i)=0;end;
            if (i>=3/8*Ncolor && i<=5/8*Ncolor),R(i)=(i-3/8*Ncolor)/(Ncolor/4);end;
            if (i>=5/8*Ncolor && i<=7/8*Ncolor),R(i)=1;end; 
            if (i>=7/8*Ncolor),R(i)=1-(i-7/8*Ncolor)/(Ncolor/4);end;     
            % Green
            if (i<1/8*Ncolor||i>=7/8*Ncolor),G(i)=0;end;
            if (i>=1/8*Ncolor && i<=3/8*Ncolor),G(i)=(i-1/8*Ncolor)/(Ncolor/4);end;
            if (i>=3/8*Ncolor && i<=5/8*Ncolor),G(i)=1;end; 
            if (i>=5/8*Ncolor && i<=7/8*Ncolor),G(i)=1-(i-5/8*Ncolor)/(Ncolor/4);end;     
            % Blue
            if (i<1/8*Ncolor),B(i)=(i+1/8*Ncolor)/(Ncolor/4);end;
            if (i>=1/8*Ncolor && i<=3/8*Ncolor),B(i)=1;end; 
            if (i>=3/8*Ncolor && i<=5/8*Ncolor),B(i)=1-(i-3/8*Ncolor)/(Ncolor/4);end;     
            if (i>=5/8*Ncolor),B(i)=0;end;   
        end;         
        map=[R;G;B];
        map=transpose(map);
    end;
    % Seismic
    if (strfind(select,'seismic')==1)
        R = [0 1 1];
        G = [0 1 0];
        B = [1 1 0];

        R=interp1([1/Ncolor .5 1]*Ncolor,R,1:Ncolor);
        G=interp1([1/Ncolor .5 1]*Ncolor,G,1:Ncolor);
        B=interp1([1/Ncolor .5 1]*Ncolor,B,1:Ncolor);       
              
        map = [ R' G' B' ];
        
%         r = zeros(256,1); 
%         g = r; 
%         b = r;
%         r(1:128) = [25 25 7 9 10 11 10 14 15 17 18 20 21 22 23 24 24 25 25 26 26 27 27 27 27 28 28 28 28 28 27 27 27 27 26 26 25 25 24 24 23 22 22 21 20 19 18 17 16 15 14 12 11 10 8 7 5 3 3 1 0 0 4 8 12 17 21 25 29 34 38 42 46 51 55 59 63 68 72 76 80 84 89 93 97 101 106 110 114 118 123 127 131 135 140 144 148 152 157 161 165 169 174 178 182 186 191 195 199 203 208 212 216 220 225 229 233 237 242 246 250 255 255 255 255 255 255 255]./256;
%         r(129:256) = [255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 251 249 247 242 240 238 236 233 229 227 224 222 220 215 213 211 207 204 202 199 196 194 191 188 186 183 180 178 175 172 170 167 164 162 159 156 154 151 148 146 143 140 138 135 132 130 127 124 122 119 116 114 111 108 106 103 100 98 95 92 90 87 84 0]./256; 
%         g(1:128) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 3 9 15 21 27 33 39 44 50 55 61 66 72 77 82 87 93 98 103 108 112 117 122 127 131 136 140 145 149 153 158 162 166 170 174 178 181 185 189 193 196 200 203 207 210 213 216 220 223 226 229 231 234 237 240 242 245 247 250 251 254 252 249 247 244 242 239]./256; 
%         g(129:256) = [236 233 230 227 224 221 218 215 212 209 206 202 199 196 192 189 185 182 178 174 171 167 163 159 155 152 148 144 139 135 131 127 123 118 114 110 105 101 96 91 87 82 77 73 68 63 59 55 51 48 44 40 37 33 29 26 22 18 14 11 7 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]./256; 
%         b(1:128) = [86 86 26 29 33 37 40 44 47 51 55 58 62 66 69 73 76 80 84 87 91 95 98 102 105 109 113 116 120 124 127 131 134 138 142 145 149 153 156 160 163 167 171 174 178 182 186 195 199 203 207 212 220 224 228 232 237 245 249 253 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 254 251 247 243 240 236 232]./256;
%         b(129:256) = [229 225 221 218 214 210 206 203 199 195 192 188 184 181 177 173 170 166 162 158 155 151 147 144 140 136 133 129 125 122 118 114 110 107 103 99 96 92 88 85 81 77 74 70 66 62 78 75 72 69 66 64 61 58 55 53 50 47 44 42 39 36 34 34 34 35 35 35 35 35 35 35 35 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 35 35 35 35 35 35 35 35 34 34 34 34 34 33 33 33 32 32 32 32 31 31 31 30 30 29 29 29 28 28 27 27 26 26 25 25 24 24 23 0]./256; 
%     
%         x = (1:256)/256.0;
%         r = sin(0.5*pi*x).*sin(x*pi).^0.2;
%         g = (1/sqrt(2))*sin(x*pi);
%         b = cos(0.5*pi*x).*sin(x*pi).^0.2;      
%         map = transpose([r;g;b]);          
    end;
end

