intro-to-arrow.html: intro-to-arrow.Rmd.orig intro-to-arrow.Rmd
	cd ..; Rscript -e 'devtools::install(quick = TRUE)'
	Rscript -e 'knitr::knit("intro-to-arrow.Rmd.orig", "intro-to-arrow.Rmd")'
	cd ..; Rscript -e 'devtools::build_rmd("vignettes/intro-to-arrow.Rmd")'

cleana:
	rm -rf intro-to-arrow_cache

intro-to-geslaR.html: intro-to-geslaR.Rmd.orig intro-to-geslaR.Rmd
	cd ..; Rscript -e 'devtools::install(quick = TRUE)'
	Rscript -e 'knitr::knit("intro-to-geslaR.Rmd.orig",	"intro-to-geslaR.Rmd")'
	cd ..; Rscript -e 'devtools::build_rmd("vignettes/intro-to-geslaR.Rmd")'

cleanb:
	rm -rf intro-to-geslaR_cache

cleang:
	rm -rf gesla_dataset

cleanall:
	rm -rf intro-to-arrow_cache intro-to-geslaR_cache gesla_dataset
