function make_year_html(year);

setup_parameters;
yearstr = num2str(year);
helm_files = dir(fullfile(gsdfpath,'helmholtz',[yearstr,'*_helmholtz_',component,'.mat']));

% generate html list
if ~exist('htmls','dir')
	mkdir('htmls');
end
fp = fopen(fullfile('htmls',[yearstr,'_eventlist_',component,'.html']),'w');

fprintf(fp,'<html>\n');
fprintf(fp,'<body>\n');

fprintf(fp,'<p>\n');
for ie = 1:length(helm_files)
	eventid = helm_files(ie).name(1:12);
	fprintf(fp,'<a href="./event_files/%s_%s.html">%s</a><br>\n',eventid,component,eventid);
end
fprintf(fp,'</p>\n');

fprintf(fp,'<p>\n');
fprintf(fp,'</p>\n');

fprintf(fp,'</body>\n');
fprintf(fp,'</html>\n');

fclose(fp);

% make event html
for ie = 1:length(helm_files)
	eventid = helm_files(ie).name(1:12);
	disp(eventid);
	makehtml_eventid(eventid,component);
end


