function dbg( varargin )
%DBG Print debug output.
%   Prints debug output to console only if showDebug is defined. Use the
%   same arguments that you would use for fprintf functions.

global showDebug;

if showDebug
   fprintf(varargin{:});
end

end

