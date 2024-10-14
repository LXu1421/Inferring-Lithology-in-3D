T= figure('WindowState','maximized'); 
surf(UTME2,UTMN2,HDMM);
shading interp
view(2)
axis equal
axis xy;
axis tight;
colorbar;
title ('HDMM')
xlabel ('Easting (m)')
ylabel ('Northing (m)')
baseFileName = sprintf('figure_HDMM.png');
exportgraphics(T,baseFileName,'BackgroundColor','white');