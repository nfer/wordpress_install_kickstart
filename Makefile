BUILT_TIME = $(shell date +"%Y-%M-%d %H:%M:%S")
prom = wordpress_install_kickstart.sh
steps = steps/*
cat = cat

$(prom): $(steps)
	rm -f $(prom)
	echo "#!/bin/bash" >> $(prom);
	echo "# built at "$(BUILT_TIME) >> $(prom)
	echo "" >> $(prom)
	for i in $(steps); do $(cat) $$i >> $(prom); echo '' >> $(prom); done
