function q = binwrite (fname,varargin)
% q = binwrite (fname,V)
%
% write a matlab array of arbitrary dimension to binary file
% uses big-endian architecture and double precision (8-byte) size
%
% fname: filename or path (string)
% V: array of arbitrary dimension (storage is independent of dimension
% sizes)


fid = fopen (fname, 'w', 'b');

if (length(varargin)==1)
 q=fwrite(fid,varargin{1},'real*8');
elseif (varargin{2}==8)
    q=fwrite(fid,varargin{1},'real*8');
elseif (varargin{2}==4)
    q=fwrite(fid,varargin{1},'real*4');
else
    error('use valid precision');
end
 
fclose(fid);

return