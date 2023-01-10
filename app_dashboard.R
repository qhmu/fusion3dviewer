## app.R ##
library(shiny)
library(shinydashboard)
library(bio3d)
library(r3dmol)

# setwd("~/Documents/1_github/fusion3dviewerTest")

GFS = read.delim('www/fusions.list.tsv')

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "Gene fusion viewer"),
  dashboardSidebar(disable = F,
    menuItem("Fusions", tabName = "fusions", icon = icon("dna")),
    menuItem("Source code", icon = icon("file-code-o"), 
             href = "https://github.com/qhmu/fusion3dviewer/")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "fusions",
        fluidRow(selectInput(inputId = "fusion",
                             label = "Fusion group",
                             choices= unique(GFS$Group),
                             multiple = F,selected = 'FGFR3 fusions'
                              ),
                 selectInput("inSelect", "Select a specific fusion variant:",
                             multiple = FALSE,
                             choices = unique(GFS$Fusion[GFS$Group=='FGFR3 fusions']))),
        
        # fluidRow(h2('Gene expression will go here'),
        #          box(width=6),
        #          box()),
        
        fluidRow(h2('Transcript structure of the fusion genes'),
                 box(width = 12,align="center",imageOutput("plot_as_svg", width = "100%", height = "760px") #img(src='BCR-NTRK2.svg', style="display: block; margin-left: auto; margin-right: auto;"
                     )),
        fluidRow(
          h2('Protein 3d structure of the fusion genes'),
          box(title='', width = 4., solidHeader =TRUE,#status="primary",
              textOutput("text1"),
              r3dmolOutput('leftgen', width = "100%", height = "400px")),
          box(title='', width = 4.,  solidHeader =TRUE,#status="primary",
              textOutput("text2"),
              r3dmolOutput('rightgen', width = "100%", height = "400px")),
          box(title='', width = 4., solidHeader =TRUE,#, status="primary"
              textOutput("text3"),
              r3dmolOutput('fusiongen', width = "100%", height = "400px"))
          )
    )
  )
)
)

server <- function(input, output, clientData, session) {
  observe({
    # Change values for input$inSelect
    s_options = unique(GFS$Fusion[GFS$Group==input$fusion])
    updateSelectInput(session, "inSelect",
                      label = "Suboption",
                      choices = s_options)
  })
  
  output$text1 = renderText(sub("\\.pdb","",basename(GFS$LeftPDB[GFS$Fusion==input$inSelect])))
  output$leftgen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(GFS$LeftPDB[GFS$Fusion==input$inSelect]) %>% 
      m_set_style(m_style_cartoon("blue")) %>% 
      m_zoom_to()# %>% 
      #m_button_set_style(m_style_cartoon("blue"), label = "Cartoon") %>% 
      #m_button_set_style(m_style_stick(), label = "Stick") %>% 
      #m_button_set_style(m_style_sphere(), label = "Sphere")%>% 
      #m_spin(speed = 0.4)
    
    viewer
  })
  
  output$text2 = renderText(sub("\\.pdb","",basename(GFS$RightPDB[GFS$Fusion==input$inSelect])))
  output$rightgen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(GFS$RightPDB[GFS$Fusion==input$inSelect]) %>% 
      m_set_style(m_style_cartoon("red")) %>% 
      m_zoom_to() #%>% 
      #m_button_set_style(m_style_cartoon("red"), label = "Cartoon") %>% 
      #m_button_set_style(m_style_stick(), label = "Stick") %>% 
      #m_button_set_style(m_style_sphere(), label = "Sphere")%>% 
      #m_spin(speed = 0.4)
    
    viewer
  })
  
  output$text3 = renderText(input$inSelect)
  output$fusiongen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(GFS$FusionPDB[GFS$Fusion==input$inSelect]) %>% 
      m_set_style(
        style = m_style_cartoon(
          colorfunc = paste("function(atom) {return atom.resi >",GFS$LeftBrkpt[GFS$Fusion==input$inSelect], "? 'red' : 'blue';}")
      )) %>% 
      m_zoom_to() 
    
    viewer
  })
  
  output$plot_as_svg <- renderImage({
    outfile = gsub("pdb",'svg',GFS$FusionPDB[GFS$Fusion==input$inSelect])
    library(XML)
    tmp = xmlToList(xmlParse(outfile))
    w = as.numeric(tmp$.attrs[1])
    h = as.numeric(tmp$.attrs[2])#/96
    list(src = normalizePath(outfile),
         contentType = 'image/svg+xml',
         width = w, height = h,
         alt = "My Histogram")
  })
  
}

shinyApp(ui, server)
