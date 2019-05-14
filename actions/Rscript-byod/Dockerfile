FROM repo:latest

LABEL "com.github.actions.name"="Rscript"
LABEL "com.github.actions.description"="Run Rscript inside repo/Dockerfile"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-hub/ghactions"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
