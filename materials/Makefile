default: targets

targets:
	Rscript -e "targets::tar_make()"

clean:
	rm -rf _freeze
	rm -rf *_cache
	rm -rf *_files
	Rscript -e "targets::tar_destroy()"
