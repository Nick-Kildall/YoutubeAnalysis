### Final Deliverable: Shiny Main
library("shiny")

### Sourcing UI and Server
source("app_ui.R")
source("app_server.R")

### Main Shiny Function
shinyApp(ui = ui, server = server)