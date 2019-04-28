prom = wordpress_install_kickstart.sh
steps = steps/*
cat = cat

$(prom): $(steps)
	$(cat) -s $(steps) > $(prom)
