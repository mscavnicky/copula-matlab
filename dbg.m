function dbg( method, level, msg, varargin )
%DBG Print debug output.
%   Prints debug output to console only if showDebug is defined. Use the
%   same arguments that you would use for fprintf functions.

global logLevel;

if logLevel >= level
   fprintf('%s [%s]: ', datestr(now, 'HH:MM:SS'), method);
   fprintf(msg, varargin{:});
   
   if ~strcmp(msg(end-1:end), '\n')
       fprintf('\n');
   end      
end

end

