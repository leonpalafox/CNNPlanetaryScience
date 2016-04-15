function net = getNetwork(pixel_size, numb_classes)

f=1/100 ;
net.layers = {} ;
switch pixel_size
    case 8
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(4,4,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(2,2,6,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
    case 16
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(4,4,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,6,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;

    case 20
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(4,4,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(4,4,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(2,2,15,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;

    case 32
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(5,5,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(4,4,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(5,5,15,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;

    case 40
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(5,5,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,15,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;

    case 52
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(5,5,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(9,9,15,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
    case 100
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(5,5,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(21,21,15,numb_classes, 'single'),...
                                   'biases', zeros(1,numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
    case 200
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(10,10,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(15,15,1,6, 'single'), ...
                                   'biases', zeros(1, 6, 'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(6,6,6,15, 'single'),...
                                   'biases', zeros(1,15,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'pool', ...
                                   'method', 'max', ...
                                   'pool', [2 2], ...
                                   'stride', 2, ...
                                   'pad', 0) ;                       
        net.layers{end+1} = struct('type', 'relu') ;  
        net.layers{end+1} = struct('type', 'conv', ...
                                   'filters', f*randn(17,17,15,numb_classes, 'single'),...
                                   'biases', zeros(1, numb_classes,'single'), ...
                                   'stride', 1, ...
                                   'pad', 0) ;
        net.layers{end+1} = struct('type', 'softmaxloss') ;
end