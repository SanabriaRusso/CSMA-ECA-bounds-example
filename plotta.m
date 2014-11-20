function plotta(nodes, CWmin, load)

	x = 1:nodes;
	y = x;
    z = x;

    for i = x
        [y(i), f(i), z(i), j(i), jj(i), jjj(i)] = eca_hys_fs(i,CWmin,load);
    end


	%Figure handler
	h = figure(1);
	plot(y/1e6, 'r', 'LineWidth', 2); hold on;
    plot(z/1e6, 'b', 'LineWidth', 2);
    plot(f/1e6, 'k', 'LineWidth', 2); hold off;
	grid on;
	title('Average aggregated throughput CSMA/ECA+Hys+FS');
	xlabel('Contenders (N)');
	ylabel('Throughput (Mbps)');
	set(gca(),'ytick',(0:5:y(nodes)), 'xtick',(0:nodes/10:nodes));	
    legend('CSMA/ECA + Hys + FS', 'CSMA/ECA + Hys + Max Agg', 'CSMA/ECA (max. Stage and max. Ag.)', 'Location', 'best');

    t = datestr(now);

	filename = ['throughput-' t '.eps'];

	saveas(h, filename, 'epsc2');

    
    
    g = figure(2);
    plot(j, 'r', 'LineWidth', 2); hold on;
    plot(jj, 'k', 'LineWidth', 2);
    plot(jjj, 'b', 'LineWidth', 2); hold off;
    grid on;
    title('JFI');
    xlabel('Contenders (N)');
	ylabel('JFI');
    set(gca(),'ytick',(0:0.1:1), 'xtick',(0:nodes/10:nodes));	
    legend('CSMA/ECA + Hys + FS', 'CSMA/ECA (max. Stage and max. Ag.)', 'CSMA/ECA + Hys + Max Agg', 'Location', 'best');
    
	t = datestr(now);

	filename = ['JFI-' t '.eps'];

	saveas(g, filename, 'epsc2');


end
