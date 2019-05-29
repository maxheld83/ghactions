FROM repo

LABEL "name"="Rscript-byod"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Rscript"
LABEL "com.github.actions.description"="Run Rscript inside repo/Dockerfile"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
