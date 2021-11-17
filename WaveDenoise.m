xnn= cell2mat(results); %Getting the noisy data timestamp
xn=xnn(:,3); %Getting the data comlumn
xden=wden(xn,'sqtwolog','s','mln',4,'sym8'); %denoise the data
h1=plot([xn xden]);
legend('orig','Den');