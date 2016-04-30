library(shiny)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(RColorBrewer)
library(shinythemes)



toPlot <- read.csv('toPlot.csv')
dataset <- toPlot

source('tweaks.R')

ft      <- c('0.0 Fmrs','0.1 Fmsr','0.2 Fmrs','0.3 Fmrs','0.4 Fmrs','0.5 Fmrs','0.6 Fmrs',
             '0.7 Fmsr','0.8 Fmrs','0.9 Fmrs','1.0 Fmrs','1.1 Fmrs','1.2 Fmrs',
             '1.3 Fmsr','1.4 Fmrs','1.5 Fmrs')

controls <- list(tags$div(align = 'left', 
                class = 'multicol', 
                checkboxGroupInput(inputId  = 'show_pond', 
                                   label    = "Seleccione Ponderador:", 
                                   choices  = ft,
                                   selected = ft,
                                   inline   = FALSE))) 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  theme = shinytheme("journal"),
  
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Dosis|Cabin:400,700');
                    
                    h1 {
                    font-family: 'Dosis';
                    font-weight: 450;
                    line-height: 1.4;
                    color: #4A6B8A  ;
                    }
                    
                    "))
    ),
  
  headerPanel("Dinamica de Capturas & Biomasa bajo escenarios de Frms"),
  
  # Application title
  #titlePanel("Dinamica de Capturas & Biomasa bajo escenarios de Frms"),
  
  hr(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      helpText("Esta aplicacion (app) ha sido creada unicamente 
                con fines de dar soporte al Comite de Manejo para la pesqueria de 
               merluza del sur en el marco de la reunion a realizar en Abril-2016. 
               Sugerencias y comentarios sobre esta app enviarlos a 
               Juan Carlos Quiroz"),
      helpText("juancarlos.quiroz@ifop.cl"),
      helpText(""),
      
       h4("Parametros Graficos"),
       
       br(),

       selectInput('x', 'Eje X:', names(dataset)[1:2]),
       selectInput('y', 'Eje Y:', names(dataset)[c(4,5,6)], names(dataset)[[6]]),
      fluidRow(
        column(6,
               selectInput('leyenda', 'Color:', names(dataset)[c(3)], names(dataset)[[3]])),
        column(5,
               numericInput("pbr", label = "PBR BDt/BDo:", value = 0.4))
        ),
       
       br(),       
       
       sliderInput('maxyear','Periodo Simulacion:', 
                   min=range(dataset$year)[1], max=range(dataset$year)[2],
                   value=range(dataset$year), 
                   step=1, round=0),
       
       br(),
      
      #tweaks,
      fluidRow(column(width = 8, controls)),

      
      br(),
       
       fluidRow(
         column(8,
                selectInput('facet_row', 'Encabezado Fila:',
                            c(Ninguno='.', names(dataset[sapply(dataset, is.factor)]))),
                selectInput('facet_col', 'Encabezado Columnas:',
                            c(Ninguno='.', names(dataset[sapply(dataset, is.factor)])))
         )
       )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       downloadButton(outputId = 'ppo', ' Obtener Grafico'),
       plotOutput(outputId = "distPlot", width = "100%")
       )
  )
 )
)
