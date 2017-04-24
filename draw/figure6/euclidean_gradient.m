caffe.reset_all();
caffe.set_mode_cpu();
test_net = caffe.Net('normalize_layer.prototxt','train');
a = randn(1,1,2,1);
angle = 0:0.01:pi;
euclidean = zeros(size(angle));
gradient = zeros(size(angle));
p=1;
for angle = 0:0.01:pi
b = reshape(a,[1 2]) * [cos(angle) -sin(angle);sin(angle) cos(angle)];
% b = randn(1,1,2,1);%-a;%[a(2) -a(1)];%randn(1,1,2,1);
% a = a + randn(1,1,2,1) / 10;
b = b ./ norm(b(:));
f = test_net.forward({a});


norm_a = squeeze(f{1});
euclidean(p) = norm(b(:) - norm_a(:));
% g = test_net.backward({reshape(b(:) - norm_a(:),[1, 1, 2, 1])});
g = test_net.backward({reshape(b(:),[1, 1, 2, 1])});
gradient(p) = norm(g{1}(:));
updated_a = [a(1) + g{1}(1), a(2) + g{1}(2)];
norm_updated_a = updated_a / norm(updated_a);
figure(1);
theta=0:pi/50:2*pi;
x=cos(theta);
y=sin(theta);
plot(x,y,'g-','LineWidth', 2);
hold on;
plot(norm_a(1),norm_a(2),'r*');
plot(norm_updated_a(1),norm_updated_a(2),'y');
plot([norm_a(1) norm_updated_a(1)],[norm_a(2) norm_updated_a(2)],'r-');
plot(b(1),b(2),'b*');
% plot(g{1}(1), g{1}(2), 'g.');

hold off;
axis([-1 1 -1 1]*2);
axis square; 
% pause
p=p+1;
end;
figure(2);
plot(euclidean, gradient);
figure(3);
x = 0:0.01:4;
y = sqrt(4 - (2-x).^2) / 2;
plot(x,y);