%% 网格密度
num_seeds = 8; % 网格密度参数（n阶正方形）
side_len = 100/ num_seeds;
n_nodes = (num_seeds+1) ^2; % 节点数量
n_elements = 2*(num_seeds^2); % 单元数量

%% 写入节点和单元信息
WriteInformation(num_seeds, side_len)

%% 绘图
% 导入信息
nodes = load('location of nodes.txt');
nodesx = nodes(:,2); % 第一列所有节点为x坐标 (1,:)表示第一行所有
nodesy = nodes(:,3); % 节点y坐标
elems = load('location of elems.txt');
plot(nodesx, nodesy, '.')
hold on

% 节点标号
for i = 1 : n_nodes
    text(nodesx(i), nodesy(i), num2str(i))
end

% 单元标号（计算质心坐标）
for i = 1 : n_elements
    elemx = (nodesx(elems(i,1)) + nodesx(elems(i,2)) + nodesx(elems(i,3)))/3;
    elemy = (nodesy(elems(i,1)) + nodesy(elems(i,2)) + nodesy(elems(i,3)))/3;
    text(elemx, elemy, num2str(i))
end

% 绘制网格
% 创建一个三角形网格，包括节点和单元
% TR = triangulation(T,x,y)
% T是一个m*n的矩阵，m代表三角形数量，n代表顶点数；后面的两个代表顶点的坐标
triang = triangulation(elems, nodesx, nodesy);
triplot(triang, '-xb');
axis equal;
hold on

%% 定义刚度矩阵和力、读取文件中的边界条件
E = 2000e6; % 弹性模量（Pa）
Mu = 0.3;
Force = 2e7; % 外力（N）
K = Ref(zeros(2*n_nodes, 2*n_nodes));
F = Ref(zeros(2*n_nodes, 1));
% 定义材料弹性矩阵
D = (E/(1-Mu^2))*[
    1.0, Mu, 0.0;
    Mu, 1.0, 0.0;
    0.0, 0.0, 0.5*(1.0-Mu);
    ];
D_strain = (E/(1+Mu)/(1-2*Mu))*[
    1.0-Mu, Mu, 0.0;
    Mu, 1.0-Mu, 0.0;
    0.0, 0.0, (1.2*Mu)/2;
    ];
% 读取边界条件文件
Readbound

%% 计算局部刚度矩阵并组装
% 如果需要在主程序中调用函数中的多个变量，可以[变量1，变量2，...] = 函数名()
CalculateK(nodes, n_elements, elems, D, K);
% 更改力的方向大小
F.value(89) = -Force; 

%% 设置边界条件
Setbound(K)

%% 求节点位移
% 变形后节点位置
U = Nodedisplacement(K, F);
new_nodes = nodes(:,end-1: end);
nodes_end = new_nodes;
size_nodes = size(new_nodes);
for dof = 1: size_nodes(1)
    % 变形后的x位置
    nodes_end(dof, 1) = nodes_end(dof, 1) + U(2*dof-1)*1000;
    % 变形后的y位置
    nodes_end(dof, 2) = nodes_end(dof, 2) + U(2*dof)*1000;
end

%% 位移后的结构可视化
% 绘制位移后的节点
plot(nodes_end(:,1), nodes_end(:,2), 'ro'); % 使用红色圆圈表示位移后的节点
% 绘制位移后的三角形网格
triang_deformed = triangulation(elems, nodes_end(:,1), nodes_end(:,2));
triplot(triang_deformed, '--or');
axis equal;
title('结构位移图');
xlabel('X（mm）');
ylabel('Y（mm）');
hold off;

%% 应力应变计算绘图
%计算应力
stress = CalculateSS(n_elements, elems, U, D, new_nodes);
% 绘图
Painting(stress(:, 1), n_elements, elems, nodes_end)
Painting(stress(:, 2), n_elements, elems, nodes_end)
Painting(stress(:, 3), n_elements, elems, nodes_end)

% 计算应变
strain = CalculateSS(n_elements, elems, U, D_strain, new_nodes);
% 绘图
Painting(strain(:, 1), n_elements, elems, nodes_end)
Painting(strain(:, 2), n_elements, elems, nodes_end)
Painting(strain(:, 3), n_elements, elems, nodes_end)
