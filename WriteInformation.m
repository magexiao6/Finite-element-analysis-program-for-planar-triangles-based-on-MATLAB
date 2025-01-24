%%根据网格密度把节点和单元信息写入txt文件
function WriteInformation(num_seeds, side_len)
    %写入节点坐标
    file_nodes = fopen("location of nodes.txt", "w");
    no_node = 1; % 节点序号
    for row = 1: num_seeds+1
        for column = 1: num_seeds+1
            x = (column - 1)* side_len; % 写入x与y坐标
            y = (num_seeds - row + 1)* side_len;
            fprintf(file_nodes, "%d, %f, %f\n", no_node, x, y);
            no_node = no_node + 1;
        end
    end
    % 写入单元坐标
    file_elems = fopen("location of elems.txt", "w");
    no_node = 1;
    for row = 1: num_seeds
        for column = 1: num_seeds
            fprintf(file_elems, "%d, %d, %d\n",  ...
                no_node+column-1, num_seeds+column+no_node, num_seeds+column+no_node+1); % 下三角形
            fprintf(file_elems, "%d, %d, %d\n",  ...
                no_node+column-1, num_seeds+column+no_node+1, no_node+column ); % 上三角形
        end
        no_node = no_node + num_seeds + 1;
    end
end