## Deploy Shiny Application to shinyapps.io

This GitHub action deploys a shiny website to the [shinyapps.io](http://shinyapps.io) hosted service via [rsconnect](https://github.com/rstudio/rsconnect).

## Secrets

- `SHINYAPPSIO_TOKEN`
- `SHINYAPPSIO_SECRET`

Read the [shinyapps.io documentation](https://shiny.rstudio.com/articles/shinyapps.html#configure) to learn how you can retrieve these from the service.


## Environment Variables

None.


## Arguments

None.


## Example Usage

```
action "Deploy shiny app" {
  uses = "r-lib/ghactions/actions/shinyapps-io@master"
  secrets = [
    "SHINYAPPSIO_TOKEN",
    "SHINYAPPSIO_SECRET"
  ]
}
```
