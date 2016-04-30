# tweaks, a list object to set up multicols for checkboxGroupInput
tweaks <- list(tags$head(tags$style(HTML("
                                 .multicol { 
                                 height: 150px;
                                 -webkit-column-count: 5; /* Chrome, Safari, Opera */ 
                                 -moz-column-count: 5;    /* Firefox */ 
                                 column-count: 5; 
                                 -moz-column-fill: auto;
                                 -column-fill: auto;
                                 } 
                                 ")) 
  ))
