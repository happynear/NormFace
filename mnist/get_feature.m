caffe.set_mode_gpu();
caffe.reset_all();
net = caffe.Net('lenet_train_test.prototxt','lenet_iter_25000.caffemodel','train');
batch_size = 128;
all_feature = zeros(batch_size*100,3);
all_label = zeros(batch_size*100,1);

for i=1:100
    f = net.forward({});
    data_blob = net.blobs('ip1').get_data();
    label_blob = net.blobs('label').get_data();
    if size(data_blob,1) == 1 && size(data_blob,2) == 1
        data_blob = reshape(data_blob,[size(data_blob,3) size(data_blob,4)]);
    end;
    all_feature((i-1)*batch_size+1:i*batch_size,:) = data_blob';
    all_label((i-1)*batch_size+1:i*batch_size) = label_blob;
end;
% weight = reshape(net.blobs('id_weight').get_data(), [2,10]);

cc = colormap(jet);
close(1);
figure(1);
hold on;
for l=0:9
    scatter3(all_feature(all_label==l,1), all_feature(all_label==l,2),all_feature(all_label==l,3), ones(sum(all_label==l),1)*5,'MarkerFaceColor',cc(l * 6 + 1,:),'MarkerEdgeColor',cc(l * 6 + 1,:));
end;
legend('0','1','2','3','4','5','6','7','8','9');
upper_bound = max(abs(all_feature(:))) * 1.2;

% for l=0:9
%     plot(weight(1,l+1) * upper_bound /2 , weight(2,l+1) * upper_bound / 2,'x','MarkerSize',10);
% end;
hold off;
axis([-upper_bound upper_bound -upper_bound upper_bound]);


% distance = pdist2(all_feature, weight');
