function db_file = GetDatabaseVec(database_foldername)
clc;
pic_name_list = ls(fullfile(database_foldername, '*.jpg'));
H = [];
for i = 1 : size(pic_name_list, 1)
    picture_name = fullfile(database_foldername, strtrim(pic_name_list(i, :)));
    [~, ~, ext] = fileparts(picture_name);
    if isequal(ext, '.') || isequal(ext, '..')
        continue;
    end
    [Img, map] = imread(picture_name);
    if ~isempty(map)
        Img = ind2rgb(Img, map);
    end
    % Hu不变矩特征
    Hu_vec = Get_Hu_vec(Img);
    % 颜色量化特征
    Color_vec = Get_Color_vec(Img);
    [~, name, ext] = fileparts(picture_name);
    h.Hu_vec = Hu_vec;
    h.Color_vec = Color_vec;
    h.filename = sprintf('%s/%s%s', database_foldername, name, ext);
    H = [H h];
end
save(fullfile(database_foldername, 'H.mat'), 'H');
db_file = fullfile(database_foldername, 'H.mat');