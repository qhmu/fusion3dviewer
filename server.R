library(shiny)
library(shinydashboard)
library(bio3d)
library(r3dmol)
library(shinythemes)

GFS = read.delim('www/fusions.list.tsv')

function(input, output, clientData, session) {
  
  
  # render the image
  
  output$logo = renderImage({
    list(src = "./img/logo.png",
         alt = "logo")}, deleteFile=FALSE)
  
  output$fusionWiki = renderImage({
    list(src = "./img/geneFusionWiki.png",
         alt = "fusionWiki")}, deleteFile=FALSE)
  
  
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
