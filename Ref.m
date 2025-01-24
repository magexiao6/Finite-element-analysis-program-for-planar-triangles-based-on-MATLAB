classdef Ref < handle
    properties % 类的属性
        value; % 可以代表任何类型的数据
    end
    methods % 类的方法
        function obj = Ref(value)
            obj.value = value;
        end
    end
end