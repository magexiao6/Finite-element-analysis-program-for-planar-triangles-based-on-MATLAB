function AssembleK(K_e, K, location)
    num_nodes = length(location); % 组成一个小单元的节点数量
    for j = 1: num_nodes
        for k = 1: num_nodes
            dim1 = location(j);
            dim2 = location(k);
            K.value(2*dim1-1:2*dim1, 2*dim2-1:2*dim2) = ...
                K.value(2*dim1-1:2*dim1, 2*dim2-1:2*dim2) ...
                + K_e(2*j-1:2*j, 2*k-1:2*k);
        end
    end
end