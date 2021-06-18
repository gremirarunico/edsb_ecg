function plotTemplate(templateMatrix, tit)
% disegno del template
figure('Name',tit,'NumberTitle','off');
title(tit);
hold on
for i = 1:size(templateMatrix, 1)
    plot(templateMatrix(i,:));
end
plot(mean(templateMatrix), 'k', 'LineWidth',5);
plot(mean(templateMatrix)+3*sqrt(var(templateMatrix)), 'r', 'LineWidth',5);
plot(mean(templateMatrix)-3*sqrt(var(templateMatrix)), 'r', 'LineWidth',5);

tmpSize = size(templateMatrix);

xline((tmpSize(2)-1)/2+1);
end

