%% 计算局部刚度矩阵并组装
function B_stress = CalculateK(nodes, n_elements, elems, D, K)
    elem_node = zeros(3, 2);
    new_nodes = nodes(:,end-1: end); % 取nodes的后两列
    for i = 1: n_elements
        elem_node(1,:) = new_nodes(elems(i, 1),:);
        elem_node(2,:) = new_nodes(elems(i, 2),:);
        elem_node(3,:) = new_nodes(elems(i, 3),:);
        x1 = elem_node(1, 1);
        y1 = elem_node(1, 2);
        x2 = elem_node(2, 1);
        y2 = elem_node(2, 2);
        x3 = elem_node(3, 1);
        y3 = elem_node(3, 2);
        % 计算雅可比矩阵和行列式
        J = [x1- x3, y1- y3;
            x2- x3, y2- y3;];
        det_J = det(J);
        % 计算形函数的导数矩阵
        B = [
            y2-y3, 0, y3-y1, 0, y1-y2, 0;
            0, x3-x2, 0, x1-x3, 0, x2-x1;
            x3-x2, y2-y3, x1-x3, y3-y1, x2-x1, y1-y2;
            ]/det_J;
        % 计算面积
        area = (x1*(y2- y3)+ x2*(y3- y1)+ x3*(y1- y2))/2;
        % 计算应力所需的B_stress
        B_stress = [
            y2-y3, 0, y3-y1, 0, y1-y2, 0;
            0, x3-x2, 0, x1-x3, 0, x2-x1;
            x3-x2, y2-y3, x1-x3, y3-y1, x2-x1, y1-y2;
            ]/(2* area);
        % 计算局部刚度矩阵
        K_e = B'* D* B* area;
        % 组装全局刚度矩阵K
        AssembleK(K_e, K, elems(i, :))
    end
end