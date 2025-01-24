%% 设置边界条件
function Setbound(K)
    boundaries = Readbound();
    for node = boundaries(:,1)'% boundaries第一列矩阵的转置
        K.value(node*2-1, :) = 0;
        K.value(node*2, :) = 0;
        K.value(:, node*2-1) = 0;
        K.value(:, node*2) = 0;
        K.value(node*2-1, node*2-1) = 1;
        K.value(node*2, node*2) = 1;
    end
end