function plot_eventid(eventid,comp,isoutput)

is_overwrite = 0;
setup_parameters;

if ~exist('isoutput','var')
	isoutput = 0;
end
filename = fullfile(gsdfpath,'eikonal',[eventid,'_eikonal_',comp,'.mat']);
if ~exist(filename,'file')
	disp(['Cannot find:',filename])
	return;
end
load(filename);
filename = fullfile(gsdfpath,'helmholtz',[eventid,'_helmholtz_',comp,'.mat']);
if ~exist(filename,'file')
	disp(['Cannot find:',filename])
	return;
end
load(filename);
load seiscmap
r = 0.08;
latlim = [25 50];
lonlim = [-125 -65];

for ip=1:length(eventphv)
	img_filename = fullfile('htmls','event_files','pics',[eventid,'_',comp,'_',num2str(ip),'.png'])
	if exist(img_filename,'file') && ~is_overwrite
		disp(['Exist: ',img_filename,',skip!']);
		continue;
	end
real_azi=angle(eventphv(ip).GVx + eventphv(ip).GVy.*sqrt(-1));
real_azi = rad2deg(real_azi)+360-180;
[dist azi] = distance(helmholtz(ip).xi,helmholtz(ip).yi,eventphv(ip).evla,eventphv(ip).evlo);
azi = azi-180;
azi_diff = real_azi - azi;
ind = find(azi_diff>180);
azi_diff(ind) = azi_diff(ind)-360;
sparse_ind = 1:20:length(dist(:));
plot_azi = azi + azi_diff*3;
azix = cosd(plot_azi);
aziy = sind(plot_azi);

Nx = 2; Ny = 2;
sidegap = 0.05; topgap = 0.03; botgap = 0.10; vgap = 0.05; hgap = 0.08;
cbar_bot = 0.04;

width = (1 - vgap*(Nx-1)-2*sidegap)/Nx;
height = (1 - topgap - botgap - (Ny-1)*hgap)/Ny;

figure(33)
clf
set(gcf,'color',[1 1 1])
set(gcf,'position',[137   398   900   500]);
ifig = 1;
ix = ceil(ifig/2);
iy = ifig - 2*(ix-1);
left = sidegap + (iy-1)*(vgap+width);
bot = botgap + (ix-1)*(hgap+height);
subplot('position',[left,bot,width,height]);
drawusa
surfacem(helmholtz(ip).xi,helmholtz(ip).yi,helmholtz(ip).GV)
colormap(seiscmap);
meanphv = nanmean(helmholtz(ip).GV(:));
if ~isnan(meanphv)
	caxis([meanphv*(1-r) meanphv*(1+r)]);
end
cbar_axis = colorbar();
set(get(cbar_axis,'xlabel'),'String', 'km/s');
title('Apparent Phase Velocity','fontsize',18)


%figure(34)
%clf
ifig = 2;
ix = ceil(ifig/2);
iy = ifig - 2*(ix-1);
left = sidegap + (iy-1)*(vgap+width);
bot = botgap + (ix-1)*(hgap+height);
subplot('position',[left,bot,width,height]);
drawusa
surfacem(helmholtz(ip).xi,helmholtz(ip).yi,helmholtz(ip).GV_cor)
colormap(seiscmap);
if ~isnan(meanphv)
	caxis([meanphv*(1-r) meanphv*(1+r)]);
end
cbar_axis = colorbar();
set(get(cbar_axis,'xlabel'),'String', 'km/s');
title('Structural Phase Velocity','fontsize',18)

ifig = 3;
ix = ceil(ifig/2);
iy = ifig - 2*(ix-1);
left = sidegap + (iy-1)*(vgap+width);
bot = botgap + (ix-1)*(hgap+height);
subplot('position',[left,bot,width,height]);
drawusa
ampmap = helmholtz(ip).ampmap';
ampmap(find(isnan(helmholtz(ip).GV))) = NaN;
surfacem(helmholtz(ip).xi,helmholtz(ip).yi,ampmap)
% quiverm(helmholtz(ip).xi(sparse_ind),helmholtz(ip).yi(sparse_ind),azix(sparse_ind),aziy(sparse_ind),'k');
colormap(seiscmap);
cbar_axis = colorbar();
set(get(cbar_axis,'xlabel'),'String', 'm');
title('Amplitude','fontsize',18)

ifig = 4;
ix = ceil(ifig/2);
iy = ifig - 2*(ix-1);
left = sidegap + (iy-1)*(vgap+width);
bot = botgap + (ix-1)*(hgap+height);
subplot('position',[left,bot,width,height]);
drawusa
surfacem(helmholtz(ip).xi,helmholtz(ip).yi,azi_diff)
quiverm(helmholtz(ip).xi(sparse_ind),helmholtz(ip).yi(sparse_ind),azix(sparse_ind),aziy(sparse_ind),'k');
colormap(seiscmap);
cbar_axis = colorbar();
set(get(cbar_axis,'xlabel'),'String', 'degree');
title('Propagation Direction Anomaly','fontsize',18)

if isoutput
	if ~exist('htmls/event_files/pics','dir')
		mkdir('htmls/event_files/pics')
	end
	export_fig(img_filename,'-png','-m2');
end

end % end of ip loop
