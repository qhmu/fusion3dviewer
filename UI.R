library(shiny)
library(shinydashboard)
library(bio3d)
library(r3dmol)

dashboardPage(skin = "black",
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