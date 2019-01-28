FROM foo:bar

LABEL "com.github.actions.name"="Render RMarkdown"
LABEL "com.github.actions.description"="Run 'rmarkdown::render_site() on project.'"
LABEL "com.github.actions.icon"="edit-3"
LABEL "com.github.actions.color"="red"

LABEL "repository"="http://github.com/maxheld83/ghactions"
LABEL "homepage"="http://www.maxheld.de/ghactions"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"

ENTRYPOINT ["Rscript", "-e", "rmarkdown::render_site()"]
