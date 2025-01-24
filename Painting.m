%% 绘制应力应变图
function Painting(parameter, n_elements, elems, nodes_end)
    figure
    axis equal;
    colormap('jet')
    clim([min(parameter), max(parameter)])
    for e_dof = 1: n_elements
        a1 = elems(e_dof, 1);
        a2 = elems(e_dof, 2);
        a3 = elems(e_dof, 3);
        % 根据上面索引到的节点号在nodes_end中取位移后的位置
        e_nodes = NaN * zeros(3, 2);
        e_nodes(1, :) = nodes_end(a1, :);
        e_nodes(2, :) = nodes_end(a2, :);
        e_nodes(3, :) = nodes_end(a3, :);
        % 绘图
        patch(e_nodes(:,1), e_nodes(:,2), ...
            [parameter(e_dof, 1); parameter(e_dof, 1); parameter(e_dof, 1)], ...
            'FaceAlpha', 0.9, 'EdgeColor', 'none')
        colorbar
    end
end