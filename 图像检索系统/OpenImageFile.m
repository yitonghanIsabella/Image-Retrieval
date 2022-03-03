function filePath = OpenImageFile(imgfilePath)
% 打开文件
% 输出参数：
% filePath——文件路径

if nargin < 1
    imgfilePath = fullfile(pwd);
end
[filename, pathname, ~] = uigetfile( ...
    { '*.bmp;*.jpg;*.tif;*.png;*.gif',...
    'Image Files (*.bmp;*.jpg;*.tif;*.png;*.gif)';
    '*.*',  'All Files (*.*)'}, ...
    'Select a File', ...
    imgfilePath);
filePath = 0;
if isequal(filename, 0) || isequal(pathname, 0)
    return;
end
filePath = fullfile(pathname, filename);
