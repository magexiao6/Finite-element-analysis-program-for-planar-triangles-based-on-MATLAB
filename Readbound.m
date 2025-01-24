%% 读取边界条件信息
function boundaries = Readbound
    Bound_file = fopen("Bound.txt", "r"); % 只读模式打开文件
    firstLine = fgetl(Bound_file); % 跳过第一行备注
    line = fgetl(Bound_file); % 读取第二行
    num_boundaries = str2double(line);
    boundaries = NaN * ones(num_boundaries, 3);
    for i = 1: num_boundaries
        line = fgetl(Bound_file);
        parts = strsplit(line); % 由于fgetl得到的line是字符串，所以分割开。
        boundaries(i, 1) = int64(str2double(parts{1})); % boundaries第一列为节点序号
        switch parts{2}
            case 'x'
                boundaries(i, 2) = 0;
            case 'y'
                boundaries(i, 3) = 0;
            case 'all'
                boundaries(i, 2) = 0;
                boundaries(i, 3) = 0;
        end
    end
    fclose(Bound_file);
end