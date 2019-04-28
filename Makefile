prom = wordpress_install_kickstart.sh
steps = steps/*
cat = cat

$(prom): $(steps)
	rm -f $(prom)
	for i in $(steps); do $(cat) $$i >> $(prom); echo '' >> $(prom); done
