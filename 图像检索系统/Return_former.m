function formerm = Return_former(Hu_vec, Color_vec, H)
% ͼ�����
Hu_vecs = cat(1, H.Hu_vec);
Color_vecs = cat(1, H.Color_vec);
% �ֱ����Hu����ɫ�ľ������
Hu_vec = repmat(Hu_vec, size(Hu_vecs, 1), 1);
Color_vec = repmat(Color_vec, size(Color_vecs, 1), 1);
dis_hu = sum((Hu_vec-Hu_vecs).^2, 2);
dis_color = sum((Color_vec-Color_vecs).^2, 2);
% ��������Ȩ����
rate = 0.5;
formerm = rate*mat2gray(dis_hu) + (1-rate)*mat2gray(dis_color);
end

