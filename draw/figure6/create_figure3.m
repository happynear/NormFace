close all;
num = 100;
bias = 0.3;
% margin = 0.5;
class1 = randn(num,3)/4;
class1_bias = bsxfun(@plus, class1, [-bias, 0, bias]);
class2 = randn(num,3)/4;
class2_bias = bsxfun(@plus, class2, [bias, 0, bias]);

net = caffe.Net('normalize_layer.prototxt','train');
f = net.forward({reshape([class1_bias; class2_bias]',[1,1,3,num*2]),reshape([zeros(1,num) ones(1,num)],[1,1,1,num*2])});

all_norm = squeeze(net.blobs('norm1').get_data())';
c1_norm = all_norm(1:num,:);
c2_norm = all_norm(num+1:end,:);

c1_center = mean(c1_norm);
c1_center = c1_center ./ norm(c1_center);
c2_center = mean(c2_norm);
c2_center = c2_center ./ norm(c2_center);

figure(1);
hold on;
scatter3(c1_norm(:,1),c1_norm(:,2),c1_norm(:,3),200,'r.');
scatter3(c2_norm(:,1),c2_norm(:,2),c2_norm(:,3),200,'b.');
% plot3(c1_center(1),c1_center(2),c1_center(3),'r.','MarkerSize',40);
% plot3(c2_center(1),c2_center(2),c2_center(3),'b.','MarkerSize',40);
plot3(c1_center(1),c1_center(2),c1_center(3),'ro','MarkerSize',10, 'LineWidth',5);
plot3(c2_center(1),c2_center(2),c2_center(3),'bo','MarkerSize',10, 'LineWidth',5);

w = [c1_center;c2_center];
net.layers('id_weight').params(1).set_data(w');

for i=1:1000
    f = net.forward({reshape([class1_bias; class2_bias]',[1,1,3,num*2]),reshape([zeros(1,num) ones(1,num)],[1,1,1,num*2])});
    w2 = net.layers('id_weight').params(1).get_data()';
    assert(sum(abs(w(:)-w2(:))) < 0.001);
    w = w2;
    g = net.backward({[1], [1;1]});
    gw1 = net.layers('id_weight').params(1).get_diff()';
    
    w = w - 0.00001*gw1;
    net.layers('id_weight').params(1).set_data(w');
end;
w = squeeze(net.blobs('id_weight_normalize').get_data())';
w_norm = squeeze(net.blobs('id_weight_normalize').get_data())';
plot3(w_norm(1,1),w_norm(1,2),w_norm(1,3),'rx','MarkerSize',20, 'LineWidth',5);
plot3(w_norm(2,1),w_norm(2,2),w_norm(2,3),'bx','MarkerSize',20, 'LineWidth',5);

direct_point = reshape(g{1},[3, num*2])';
update_point = [c1_norm; c2_norm] - 10 * direct_point;
update_point = bsxfun(@rdivide, update_point, sqrt(sum(update_point.^2,2)));
arrow3([c1_norm; c2_norm],update_point, 'k-0.5', 0.5,1,0.1); 
xlabel('dimension 1');
ylabel('dimension 2');
zlabel('dimension 3');
hold off;
box on;
