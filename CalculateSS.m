%% 计算应力应变
function Need_outcome = CalculateSS(n_elements, elems, U, Need_D, new_nodes)
    Need_outcome = NaN * zeros(n_elements, 3); % 储存所有单元对应节点的应力
    elem_node = NaN * zeros(3, 2);
    for e_dof = 1: n_elements
        n1 = elems(e_dof, 1);
        n2 = elems(e_dof, 2);
        n3 = elems(e_dof, 3);
        q_e = zeros(6, 1); % 储存节点对应的位移
        q_e(1, 1) = U(2*n1-1, 1);
        q_e(2, 1) = U(2*n1, 1);
        q_e(3, 1) = U(2*n2-1, 1);
        q_e(4, 1) = U(2*n2, 1);
        q_e(5, 1) = U(2*n3-1, 1);
        q_e(6, 1) = U(2*n3, 1);
        elem_node(1,:) = new_nodes(elems(e_dof, 1),:);
        elem_node(2,:) = new_nodes(elems(e_dof, 2),:);
        elem_node(3,:) = new_nodes(elems(e_dof, 3),:);
        x1 = elem_node(1, 1);
        y1 = elem_node(1, 2);
        x2 = elem_node(2, 1);
        y2 = elem_node(2, 2);
        x3 = elem_node(3, 1);
        y3 = elem_node(3, 2);
        area = (x1*(y2- y3)+ x2*(y3- y1)+ x3*(y1- y2))/2;
        B_stress = [
            y2-y3, 0, y3-y1, 0, y1-y2, 0;
            0, x3-x2, 0, x1-x3, 0, x2-x1;
            x3-x2, y2-y3, x1-x3, y3-y1, x2-x1, y1-y2;
            ]/(2* area);
        Need_outcome(e_dof, :) = (Need_D* B_stress* q_e)';
    end
end