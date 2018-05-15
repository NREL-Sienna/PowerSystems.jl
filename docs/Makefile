BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

html:
	julia make.jl

github: html
	-git branch -D gh-pages
	-git push origin --delete gh-pages
	ghp-import -n -b gh-pages -m "Update documentation" ./build
	git checkout gh-pages
	git push --set-upstream origin gh-pages
	git checkout ${BRANCH}

all: github
