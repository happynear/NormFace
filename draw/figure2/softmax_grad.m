function grad = softmax_grad(x,y,weight,i)
if nargin == 3
    i = 1;
end;
    ip = [x y] * weight;
    ip = ip - max(ip);
    ip = exp(ip);
    ip = ip / sum(ip);
    grad = ip(i);
end