function vec = get_color_vec(image)
% 获取hsv空间矩阵
hsv = rgb2hsv(image);
h = hsv(:,:,1);
s = hsv(:,:,2);
v = hsv(:,:,3);
% 将h变换为角度空间
h = h*360;
H = zeros(size(h));
S = zeros(size(s));
V = zeros(size(v));
% H进行8级量化
H(h<=20 | h>315) = 0;
H(h<=40 & h>20) = 1;
H(h<=75 & h>40) = 2;
H(h<=155 & h>75) = 3;
H(h<=190 & h>155) = 4;
H(h<=271 & h>190) = 5;
H(h<=295 & h>271) = 6;
H(h<=315 & h>295) = 7;
% S进行3级量化
S(s<=0.2 & s>0) = 0;
S(s<=0.7 & s>0.2) = 1;
S(s<=1.0 & s>0.7) = 2;
% V进行3级量化
V(v<=0.2 & v>0) = 0;
V(v<=0.7 & v>0.2) = 1;
V(v<=1.0 & v>0.7) = 2;
% 加权整合,范围[0，71]
L = 9*H + 3*S + V;
W = zeros(size(L));
% L进行12级量化
W(L<6 & L>=0) = 0;
W(L<12 & L>=6) = 1;
W(L<18 & L>=12) = 2;
W(L<24 & L>=18) = 3;
W(L<30 & L>=24) = 4;
W(L<36 & L>=30) = 5;
W(L<42 & L>=36) = 6;
W(L<48 & L>=42) = 7;
W(L<54 & L>=48) = 8;
W(L<60 & L>=54) = 9;
W(L<66 & L>=60) = 10;
W(L<72 & L>=66) = 11;
vec = zeros(1, 12);
for i = 0 : 11
    % 统计直方图
    Wi = find(W==i);
    vec(i+1) = numel(Wi);
end
% 归一化处理
vec = vec ./ sum(vec);
