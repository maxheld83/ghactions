FROM maxheld83/base

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
