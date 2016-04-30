
library(shiny)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(RColorBrewer)

myColors1 = colorRampPalette(palette(rainbow(16)))(16) 


  
toPlot <- read.csv('toPlot.csv')
toPlot$captura <- toPlot$captura/1000
toPlot$biomasa <- toPlot$biomasa/1000


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  datati <- reactive({
    if (input$y == 'reduccion')
      filter(toPlot, year >= input$maxyear[1], year <= input$maxyear[2], 
             reduccion <= input$pbr + 0.03, ponderador %in% input$show_pond)
    else
      filter(toPlot, year >= input$maxyear[1], year <= input$maxyear[2],
             ponderador %in% input$show_pond)
  })
  
  plotInput <- function(){
    h <- ggplot(datati(), aes_string(x=input$x, y=input$y)) 
    h <- h + geom_point(size=3) + geom_line(size=1) 
    h <- h + aes_string(color= input$leyenda)
    
    if (input$y == 'reduccion' & input$x == 'recuperacion'){
      h <- h + geom_hline(yintercept=c(0.38, 0.4), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=0.2, y=0.386, label='95% BDrms', color='black', alpha=1/3)
      h <- h + geom_text(x=0.2, y=0.406, label='100% BDrms', color='black', alpha=1/3)
      h <- h + xlab("\nPeriodo de Recuperacion [desde Enero 2015]") + 
        ggtitle ("Recuperacion Biomasa Desovante") + ylab ("Proporcion [BD/Bo]\n") }

    if (input$y == 'reduccion' & input$x == 'year'){
      h <- h + geom_hline(yintercept=c(0.38, 0.4), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=2016, y=0.386, label='95% BDrms', color='black', alpha=1/3)
      h <- h + geom_text(x=2016, y=0.406, label='100% BDrms', color='black', alpha=1/3)
      h <- h + xlab("\nTiempo") + 
        ggtitle ("Recuperacion Biomasa Desovante") + ylab ("Proporcion [BD/Bo]\n") }     
    
    if (input$y == 'biomasa' & input$x == 'recuperacion'){
      h <- h + geom_hline(yintercept=c(172), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=0.2, y=173, label='BD rms', color='black', alpha=1/3)
      h <- h + xlab("\nPeriodo de Recuperacion [desde Enero 2015]") + 
        ggtitle ("Biomasa Desovante") + ylab ("Toneladas [miles]\n") }
    
    if (input$y == 'biomasa' & input$x == 'year'){
      h <- h + geom_hline(yintercept=c(172), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=2016, y=173, label='BD rms', color='black', alpha=1/3)
      h <- h + xlab("\nTiempo") + 
        ggtitle ("Biomasa Desovante") + ylab ("Toneladas [miles]\n") }   
    
    if (input$y == 'captura' & input$x == 'recuperacion'){
      h <- h + geom_hline(yintercept=c(24), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=0.2, y=24.5, label='BD rms', color='black', alpha=1/3)
      h <- h + xlab("\nPeriodo de Recuperacion [desde Enero 2015]") + 
        ggtitle ("Captura Esperada") + ylab ("Toneladas [miles]\n") 
      h <- h + scale_y_continuous(breaks=seq(0,26,4))}
    
    if (input$y == 'captura' & input$x == 'year'){
      h <- h + geom_hline(yintercept=c(24), colour="black", alpha=1/4, size=3 )
      h <- h + geom_text(x=2016, y=24.5, label='BD rms', color='black', alpha=1/3)
      h <- h + xlab("\nTiempo") + 
        ggtitle ("Captura Esperada") + ylab ("Toneladas [miles]\n")  
      h <- h + scale_y_continuous(breaks=seq(0,26,4))}     
    
      
    h <- h +  theme(axis.text.x = element_text(angle = 90, vjust = 0.2))  + theme_wsj() 
    h <- h + theme(axis.title=element_text(size=14), legend.title=element_blank())  
    h <- h + scale_colour_manual(values = myColors1)
    h <- h + theme(panel.background = element_rect(fill = 'white', colour = 'red'),
                   plot.background = element_rect(fill="white"),
                   legend.background = element_rect(fill="white"),
                   legend.key = element_rect(fill="white"),
                   legend.key.width = unit(1.5,"cm"), legend.key.height = unit(0.8,"cm"))
  }
  
  output$distPlot <- renderPlot({
    print(plotInput())
  }, height = 650, width = 850)
  
  output$ppo = downloadHandler(
    filename = function() { paste(input$y, '.pdf', sep='') },
    content = function(file) {
      ggsave(file, plot = plotInput(), device = "pdf", width = 14, height = 10, dpi = 400)
    }
  )
  
})
