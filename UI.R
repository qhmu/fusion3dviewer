library(shiny)
library(shinydashboard)
library(bio3d)
library(r3dmol)
library(shinythemes)

# setwd("~/Documents/1_github/fusion3dviewerTest")
GFS = read.delim('www/fusions.list.tsv')
pdbSvgMergeDfNona = read.delim('pdbSvgMergeDfNona.csv', sep = ',')
GFS = GFS[GFS$Fusion %in% pdbSvgMergeDfNona$name,]

navbarPage("3D fusion viewer!",
           theme = shinytheme("flatly"),
           tabPanel("Home",
                    
                    
                    
                    navlistPanel(id = "navlist",
                                 widths = c(2, 7),
                                 tabPanel("Introduction", 
                                          
                                          # "This is the home page",
                                          h1("3D Gene Fusion Viewer"),
                                          h4(tags$hr()),
                                          
                                          imageOutput('logo', inline = T),
                                          
                                          
                                          h4(tags$hr()),
                                          
                                          
                                          h4('3D Gene Fusion Viewer is the online tool to view the gene fusions in the transcript and 3D protein view.'),
                                          h4("The funciton of the panels are listed as follows."),
                                          tags$ol(
                                            
                                            h3(tags$li('Introduction')),
                                            h4('It is the introduction and the summary of the gene fusion viewer. You could find the cohort and the collection of the gene fusions in this page. The basic guidance will also help you to utilize this tool to visulize the gene fusions.'),
                                            
                                            h3(tags$li('Fusions')),
                                            h4(tags$strong("MAIN TOOL HERE!")),
                                            h4('The main tools of the gene fusion viewer. You could explore all the collected gene fusions by the transcript view and the 3D protein shape view. For the transcript view, the transcripts of two genes and the fusion genes are visulized. For the 3D protein shape view, the 3D structure of the proteins are displayed with 3D viewer.'),
                                            
                                            h3(tags$li('Cases')),
                                            h4('The collected cased in our cohort. The clinical information of the patients is visualized here for you to explore.'),
                                            
                                            h3(tags$li('About')),
                                            h4('All questions and suggestions are welcomed. To contact to us, you need to turn to this tab to explore. The source codes of the gene fusion viewer are also available here.'),
                                            
                                          ),
                                          
                                          h4(tags$hr('The basic fusion information from Wikipedia:')),
                                          imageOutput('fusionWiki', inline = T)
                                          
                                          
                                          
                                          
                                          ),
                                 
                                 
                                 tabPanel("Fusions", 
                                          
                                          h4('Please select the fusion group and the sepecific fusion variant here:'),
                                          
                                          h4(selectInput(inputId = "fusion",
                                                      label = "Fusion group",
                                                      choices= unique(GFS$Group),
                                                      multiple = F,selected = 'FGFR3 fusions')),
                                          
                                          h4(selectInput("inSelect", "Select a specific fusion variant:",
                                                      multiple = FALSE,
                                                      choices = unique(GFS$Fusion[GFS$Group=='FGFR3 fusions']))),
                                          h2(tags$hr()),
                                          
                                          h4(tags$strong(tags$i('Visualized results'))),
                                          h5(tabsetPanel(
                                            id = "tabset",
                                            
                                            tabPanel("Transcript", 
                                                     h3('Transcript structure of the fusion genes'),
                                                     box(width = 12,align="center",imageOutput("plot_as_svg", width = "100%", height = "760px"))
                                            ),
                                            
                                            
                                            tabPanel("Protein", 
                                                     h3('Protein 3d structure of the fusion genes'),
                                                     box(title='', width = 4., solidHeader =TRUE,
                                                         textOutput("text1"),
                                                         r3dmolOutput('leftgen', width = "100%", height = "400px")),
                                                     box(title='', width = 4.,  solidHeader =TRUE,
                                                         textOutput("text2"),
                                                         r3dmolOutput('rightgen', width = "100%", height = "400px")),
                                                     box(title='', width = 4., solidHeader =TRUE,
                                                         textOutput("text3"),
                                                         r3dmolOutput('fusiongen', width = "100%", height = "400px"))
                                            ),
                                          ))
                                          
                                 ),
                                 tabPanel("Cases", 
                                          
                                          h1("Cases"),
                                          h4("This is the case panel")
                                          
                                          ),
                                 
                                 tabPanel("About", 
                                          
                                          
                                          
                                          tags$ul(
                                            
                                            h3(tags$li('Source codes')),
                                            h4('The source codes are in the GitHub repository as follows:'),
                                            
                                            h4(tags$ul(
                                                tags$li(tags$a(href="https://github.com/qhmu/fusion3dviewer", 'fusion3dviewer')),
                                                tags$li(tags$a(href="https://github.com/jligm-hash/fusion3dviewerTest/tree/jligm", 'fusion3dviewerTest')),
                                            )),
                                            
                                            
                                            h3(tags$li('Contact us')),
                                            h4('To contact us, please email Dr. Quanhua MU@HKUST at EMAIL_ADDRESS.')
                                          
                                          )
                                 )
                    )
                    
                    
                    
                    
                    
                    
                    
                    
                    
           )

)


# 
# fluidPage(
#   
#   
#   titlePanel("Gene fusion viewer"),
#   
#   navlistPanel(id = "navlist",
#                widths = c(2, 7),
#     tabPanel("Home", "This is the home page"),
#     tabPanel("Fusion", 
#              selectInput(inputId = "fusion",
#                          label = "Fusion group",
#                          choices= unique(GFS$Group),
#                          multiple = F,selected = 'FGFR3 fusions'),
#              
#              selectInput("inSelect", "Select a specific fusion variant:",
#                          multiple = FALSE,
#                          choices = unique(GFS$Fusion[GFS$Group=='FGFR3 fusions'])),
#              
#              tabsetPanel(
#                id = "tabset",
#                tabPanel("Transcript", 
#                         h2('Transcript structure of the fusion genes'),
#                         box(width = 12,align="center",imageOutput("plot_as_svg", width = "100%", height = "760px"))
#                         ),
#                tabPanel("Protein", 
#                         h2('Protein 3d structure of the fusion genes'),
#                         box(title='', width = 4., solidHeader =TRUE,
#                             textOutput("text1"),
#                             r3dmolOutput('leftgen', width = "100%", height = "400px")),
#                         box(title='', width = 4.,  solidHeader =TRUE,
#                             textOutput("text2"),
#                             r3dmolOutput('rightgen', width = "100%", height = "400px")),
#                         box(title='', width = 4., solidHeader =TRUE,
#                             textOutput("text3"),
#                             r3dmolOutput('fusiongen', width = "100%", height = "400px"))
#                         ),
#              )
#              
#              ),
#     tabPanel("Case", "This is the case panel"),
#     tabPanel("About", "This is the about panel")
#   )
#   
#   
# )










# # previous layout by dashboardPage
# dashboardPage(skin = "black",
#               dashboardHeader(title = "Gene fusion viewer"),
#               
#               dashboardSidebar(disable = F,
#                                menuItem("Fusions", tabName = "fusions", icon = icon("dna")),
#                                menuItem("Source code", icon = icon("file-code-o"), 
#                                         href = "https://github.com/qhmu/fusion3dviewer/")
#               ),
#               dashboardBody(
#                 
#                 
#                 
#                 
#                 tabItems(
#                   tabItem(tabName = "fusions",
#                           fluidRow(selectInput(inputId = "fusion",
#                                                label = "Fusion group",
#                                                choices= unique(GFS$Group),
#                                                multiple = F,selected = 'FGFR3 fusions'
#                           ),
#                           selectInput("inSelect", "Select a specific fusion variant:",
#                                       multiple = FALSE,
#                                       choices = unique(GFS$Fusion[GFS$Group=='FGFR3 fusions']))),
#                           
#                           # fluidRow(h2('Gene expression will go here'),
#                           #          box(width=6),
#                           #          box()),
#                           
#                           fluidRow(h2('Transcript structure of the fusion genes'),
#                                    box(width = 12,align="center",imageOutput("plot_as_svg", width = "100%", height = "760px") #img(src='BCR-NTRK2.svg', style="display: block; margin-left: auto; margin-right: auto;"
#                                    )),
#                           fluidRow(
#                             h2('Protein 3d structure of the fusion genes'),
#                             box(title='', width = 4., solidHeader =TRUE,#status="primary",
#                                 textOutput("text1"),
#                                 r3dmolOutput('leftgen', width = "100%", height = "400px")),
#                             box(title='', width = 4.,  solidHeader =TRUE,#status="primary",
#                                 textOutput("text2"),
#                                 r3dmolOutput('rightgen', width = "100%", height = "400px")),
#                             box(title='', width = 4., solidHeader =TRUE,#, status="primary"
#                                 textOutput("text3"),
#                                 r3dmolOutput('fusiongen', width = "100%", height = "400px"))
#                           )
#                   )
#                 )
#               )
# )