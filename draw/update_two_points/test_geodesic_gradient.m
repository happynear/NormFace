caffe.reset_all();
caffe.set_mode_gpu();
test_net = caffe.Net('normalize_layer.prototxt','train');
a = randn(1,2);
b = -a + randn(1,2) / 1000;
while true
norm_a = a / norm(a(:));
b = b / norm(b);

f = test_net.forward({reshape(a,[1,1,2,1])});

g = b - (norm_a*b')*norm_a;
g = g ./ norm(g(:));
g = g * acos(norm_a*b') *2;
tangent = norm_a+g;
grad = test_net.backward({reshape(g,[1, 1, 2, 1])});
g = reshape(grad{1},[1 2]);
update_a = a + g;
update_norm_a = update_a / norm(update_a(:));
disp([norm(g) norm(a)]);

figure(1);
theta=0:pi/50:2*pi;
x=cos(theta);
y=sin(theta);
plot(x,y,'g-','LineWidth', 2);
hold on;
plot([norm_a(1) 0],[norm_a(2) 0],'g-');
plot([b(1) 0],[b(2) 0],'g-');
plot(norm_a(1),norm_a(2),'r*');
plot([norm_a(1) tangent(1)],[norm_a(2) tangent(2)],'r-');
plot([norm_a(1) update_norm_a(1)],[norm_a(2) update_norm_a(2)],'b-');
plot(b(1),b(2),'b*');
plot(0,0,'o');
hold off;
axis([-2 2 -2 2]);
pause;
a = update_a;
end;