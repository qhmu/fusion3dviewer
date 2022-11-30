## app.R ##
library(shiny)
library(shinydashboard)
library(bio3d)
library(r3dmol)

GFS = data.frame(left=c('FGFR3','CCDC6'),
                 right = c('CGNL1','RET'),
                 fusion=c('FGFR3--CGNL1','CCDC6--RET'),
                 file = c('FGFR3_CGNL1.pdb','CCDC6RET_fusion.pdb'))

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "Gene fusion viewer"),
  dashboardSidebar(disable = F,
    menuItem("Overview", tabName = "patients", icon = icon(name='user-plus')),
    menuItem("Fusions", tabName = "fusions", icon = icon("dna")),
    menuItem("Source code", icon = icon("file-code-o"), 
             href = "https://github.com/qhmu/fusion3dviewer/")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "patients",h2("The overall landscape will go here.")),
      tabItem(tabName = "fusions",
        fluidRow(selectInput(inputId = "fusion",
                             label = "Please input name of a fusion:",
                             choices=c('FGFR3--CGNL1','CCDC6--RET'),
                             multiple = F,selected = 'FGFR3--CGNL1'
                              ),
                 selectInput("inSelect", "Select input:",
                             multiple = FALSE,
                             choices = c('FGFR3--TACC3','FGFR3--CGNL1'))),
        fluidRow(h2('Gene expression will go here'),
                 box(width=6),
                 box()),
        fluidRow(
          h2('3D structure of the proteins'),
          box(title='', width = 3., solidHeader =TRUE,#status="primary",
              textOutput("text1"),
              r3dmolOutput('leftgen', width = "100%", height = "400px")),
          box(title='', width = 3.,  solidHeader =TRUE,#status="primary",
              textOutput("text2"),
              r3dmolOutput('rightgen', width = "100%", height = "400px")),
          box(title='', width = 3., solidHeader =TRUE,#, status="primary"
              textOutput("text3"),
              r3dmolOutput('fusiongen', width = "100%", height = "400px")),
          box(title="", width = 3., solidHeader =TRUE,#, status="primary"
              textOutput("text4"),
              r3dmolOutput('alignment', width = "100%", height = "400px"))
          )
    )
  )
)
)

server <- function(input, output, clientData, session) {
  observe({
    fus <- input$fusion
    # Change values for input$inSelect
    s_options = paste(fus,1:5)
    updateSelectInput(session, "inSelect",
                      label = "Suboption",
                      choices = s_options)
  })
  
  output$text1 = renderText(GFS$left[GFS$fusion==input$fusion])
  output$leftgen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(paste0('www/',GFS$left[GFS$fusion==input$fusion],'_wt.pdb')) %>% 
      m_set_style(m_style_cartoon("blue")) %>% 
      m_zoom_to()# %>% 
      #m_button_set_style(m_style_cartoon("blue"), label = "Cartoon") %>% 
      #m_button_set_style(m_style_stick(), label = "Stick") %>% 
      #m_button_set_style(m_style_sphere(), label = "Sphere")%>% 
      #m_spin(speed = 0.4)
    
    viewer
  })
  
  output$text2 = renderText(GFS$right[GFS$fusion==input$fusion])
  output$rightgen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(paste0('www/',GFS$right[GFS$fusion==input$fusion],'_wt.pdb')) %>% 
      m_set_style(m_style_cartoon("red")) %>% 
      m_zoom_to() #%>% 
      #m_button_set_style(m_style_cartoon("red"), label = "Cartoon") %>% 
      #m_button_set_style(m_style_stick(), label = "Stick") %>% 
      #m_button_set_style(m_style_sphere(), label = "Sphere")%>% 
      #m_spin(speed = 0.4)
    
    viewer
  })
  
  output$text3 = renderText(input$fusion)
  output$fusiongen <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(paste0('www/',GFS$file[GFS$fusion==input$fusion])) %>% 
      m_set_style(
        style = m_style_cartoon(
          colorfunc = "
        function(atom) {
          return atom.resi > 300 ? 'red' : 'blue';
        }"
      )) %>% 
      m_zoom_to() 
    
    viewer
  })
  
  output$text4 = renderText("Alignment")
  output$alignment <- renderR3dmol({
    viewer <- r3dmol() %>% 
      m_add_model(data = 'www/alignment.pdb') %>% 
      m_set_style( style = m_style_cartoon(color = "white")) %>% 
      m_set_style( sel = m_sel(chain = "A"), 
                   style = m_style_cartoon(color = "green")) %>% 
      m_set_style( sel = m_sel(chain = "B"), 
                   style = m_style_cartoon(color = "cyan")) %>% 
      m_set_style( sel = m_sel(chain = "C"), 
                   style = m_style_cartoon(color = "magenta")) %>%
      m_zoom_to() 
    
    viewer
  })
}

shinyApp(ui, server)
