s = size(hkh_2);
schools= [5,19,49,80,126,155,182,220,245,265];
for i=1:10
    window_size = 30;
    simple = tsmovavg(hkh_2(schools(i),:),'s',window_size);
    exp = tsmovavg(hkh_2(schools(i),:),'e',window_size);
    tri = tsmovavg(hkh_2(schools(i),:),'t',window_size);
    X = 1:214;
    h=figure;
    seven_day_plot = zeros(214);
    count = 1;
    for k = 1:214
        if (mod(k,31) == 1)
            avg = 0;
        end
        if (mod(k,30) == 0)
            avg = avg/30;
            monthly(count) = avg;
            count=count+1;
            for t = (k -29):k
                seven_day_plot(t) = avg;
            end
        end          
        avg = avg + hkh_2(schools(i),k);
    end
    plot(X, simple, X, exp, X,tri,X,seven_day_plot);
    saveas(h,strcat('hkh_2/school',int2str(i),'.jpg'));
    csvwrite(strcat('hkh_2/simple_school',int2str(i),'.csv'),simple);
    csvwrite(strcat('hkh_2/exp_school',int2str(i),'.csv'),exp);
    csvwrite(strcat('hkh_2/tri_school',int2str(i),'.csv'),tri);
    err_simple = 0.0;
    err_exp = 0.0;
    err_tri = 0.0;
    for j = window_size:s(2)
        err_simple = err_simple + (simple(1,j)- hkh_2(schools(i),j))*(simple(1,j)- hkh_2(schools(i),j));
        err_exp = err_exp + (exp(1,j)- hkh_2(schools(i),j))*(exp(1,j)- hkh_2(schools(i),j));
        err_tri = err_tri + (tri(1,j)- hkh_2(schools(i),j))*(tri(1,j)- hkh_2(schools(i),j));
    end
    err_simple = err_simple/(s(2)-window_size);
    err_exp = err_exp/(s(2)-window_size);
    err_tri = err_tri/(s(2)-window_size);
    error(i,1) = err_simple;
    error(i,2) = err_exp;
    error(i,3) = err_tri;
    month(i,:) = monthly;
end
