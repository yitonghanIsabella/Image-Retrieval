function filePath = OpenImageFile(imgfilePath)
% ���ļ�
% ���������
% filePath�����ļ�·��

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
