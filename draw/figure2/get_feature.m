caffe.set_mode_gpu();
caffe.reset_all();
net = caffe.Net('lenet_NCA_nonorm.prototxt','lenet_iter_20000.caffemodel','train');
batch_size = 128;
all_feature = zeros(batch_size*100,2);
all_label = zeros(batch_size*100,1);

for i=1:100
    f = net.forward({});
    data_blob = net.blobs('ip1_dr').get_data();
    label_blob = net.blobs('label').get_data();
    if size(data_blob,1) == 1 && size(data_blob,2) == 1
        data_blob = reshape(data_blob,[size(data_blob,3) size(data_blob,4)]);
    end;
    all_feature((i-1)*batch_size+1:i*batch_size,:) = data_blob';
    all_label((i-1)*batch_size+1:i*batch_size) = label_blob;
end;
weight = reshape(net.blobs('id_weight').get_data(), [2,10]);
all_feature_norm = bsxfun(@rdivide, all_feature, sqrt(sum(all_feature.^2,2)));
upper_bound = max(abs(all_feature(:))) * 1.2;

cc = colormap(jet);
close(1);
figure(1);
hold on;
resolution = 1000;
grad_image = zeros(resolution+1,resolution+1);
for x = -upper_bound:upper_bound / resolution:upper_bound
    for y = -upper_bound:upper_bound / resolution:upper_bound
        grad_image(round((x + upper_bound) / (upper_bound / resolution) + 1), round((y + upper_bound) / (upper_bound / resolution) + 1)) = softmax_grad(x, y, weight,7);
    end;
end;
% contourf(-upper_bound:upper_bound / 100:upper_bound, -upper_bound:upper_bound / 100:upper_bound, grad_image,'LineStyle','none');
imagesc('XData',-upper_bound:upper_bound / resolution:upper_bound,'YData',-upper_bound:upper_bound / resolution:upper_bound,'CData',grad_image);
colormap(parula);
colorbar;
caxis('auto');

% for i=1:size(all_feature,1)
%     all_feature(i,:) = all_feature(i,:) ./ norm(all_feature(i,:)) * upper_bound;
% end;

for l=0:9
    scatter(all_feature(all_label==l,1), all_feature(all_label==l,2),ones(sum(all_label==l),1)*5,'MarkerFaceColor',cc(l * 6 + 1,:),'MarkerEdgeColor',cc(l * 6 + 1,:));
end;
legend('0','1','2','3','4','5','6','7','8','9');
% upper_bound = max(abs(all_feature(:))) * 1.2;

% for l=0:9
%     plot(weight(1,l+1) * upper_bound /2 , weight(2,l+1) * upper_bound / 2,'x','MarkerSize',10);
% end;


axis([-upper_bound upper_bound -upper_bound upper_bound]);
box on;
hold off;
