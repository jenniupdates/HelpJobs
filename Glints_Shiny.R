packages = c( 'formattable', 'ggplot2', 'tidyverse', 'dplyr', 'leaflet', 'packrat', 'rsconnect', 'shiny', 'DT', 'shinycssloaders', 'shinythemes', 'plotly', 'gridExtra', "RColorBrewer", 'highcharter')

for(p in packages){
  if(!require(p, character.only = T)){
    install.packages(p)
  }
  library(p, character.only = T)
}

# Loading data
latest_data = read_csv('data\\MyCareersFuture_04_03_2021.csv')
skills = read_csv('data\\Skills.csv')
skills = skills[order(-skills$Count),]

# CSS
button_color_css <- "
#DivCompClear, #FinderClear, #EnterTimes{
/* Change the background color of the update button
to blue. */
background: DodgerBlue;
/* Change the text size to 15 pixels. */
font-size: 15px;
}"


# UI
ui <- fluidPage(
  # Create Navbar 
  navbarPage("The Fresh Grad Helper", theme = shinytheme("lumen"),
             tabPanel("How many jobs are available to you?", fluid = TRUE, icon = icon("money-bill-alt"),
                      tags$style(button_color_css),
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Graduate Characteristics"),
                          fluidRow(column(6,
                                          selectInput(inputId = 'mode_chosen',
                                                             label = "Select mode:",
                                                             choices = c("Top 10 Skills", "Display chosen skill"), 
                                                             selected = "Top 10 Skills"))
                          ),
                          fluidRow(column(6,
                                          checkboxGroupInput(inputId = 'skills_chosen',
                                                            label = "Select skill(s):",
                                                            choices = c("Management"= "Management", "Leadership" = "Leadership", "Python"="Python", ".NET"=".NET")))
                      )),              
                      mainPanel(
                        withSpinner(plotOutput(outputId = "SalaryHelper"))
                      )
             )
             ),
             tabPanel("Salary Distribution Based on Industry", fluid = TRUE, icon = icon("comment-dollar"),
                      tags$style(button_color_css),
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Industry"),
                          fluidRow(column(6,
                                          checkboxGroupInput(inputId = 'industry_chosen',
                                                             label = "Select industry(ies):",
                                                             choices = c("Information Technology"= "Information Technology", "Accounting / Auditing / Taxation" = "Accounting / Auditing / Taxation")))
                          )),              
                        mainPanel(
                          withSpinner(plotOutput(outputId = "JobCategoryBoxPlot"))
                        )
                      )
             ),
             tabPanel("Where are the jobs located?", fluid = TRUE, icon = icon("map-marker-alt"),
                      tags$style(button_color_css),
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Where are the jobs?")),              
                        mainPanel(
                          withSpinner(leafletOutput(outputId = "MapPlot"))
                        )
                      )
             ),
             tabPanel("Months with the most number of jobs", fluid = TRUE, icon = icon("calendar"),
                      tags$style(button_color_css),
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Number of months to show"),
                          fluidRow(column(6,
                                          sliderInput(inputId = "MonthsShow",
                                                      label = "Select Months to Show",
                                                      min = 1,
                                                      max = 11,
                                                      value = 5,
                                                      width = "220px"),)
                          )),              
                        mainPanel(
                          withSpinner(highchartOutput(outputId = "JobMonthsPlot"))
                        )
                      )
             ),
             tabPanel("Companies that posts the most jobs", fluid = TRUE, icon = icon("acquisitions-incorporated"),
                      tags$style(button_color_css),
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Number of companies to show"),
                          fluidRow(column(6,
                                          sliderInput(inputId = "CompaniesShow",
                                                      label = "Select Companies to Show",
                                                      min = 1,
                                                      max = 7,
                                                      value = 7,
                                                      width = "220px"),)
                          )),              
                        mainPanel(
                          withSpinner(plotOutput(outputId = "CompanyPlot"))
                        )
                      )
             )
  )
)

server <- function(input, output, session) {
  
  output$SalaryHelper <- renderPlot({
    ifelse(input$mode_chosen == 'Top 10 Skills', 
           skills_df <- skills %>%
             filter(Skill != "Job Descriptions") %>%
             filter(Skill != "equipment") %>%
             filter(Skill != "designed") %>%
             filter(Skill != "system"), 
           skills_df <- skills %>%
             filter(Skill %in% unlist(input$skills_chosen)))
  
    if (input$mode_chosen == "Display chosen skill") {
      shiny::validate(
        need(input$skills_chosen, "Input a value first!")
      )
    }
    shiny::validate(
      need(input$mode_chosen, "Input a value first!")
    )
    ggplot(data=head(skills_df,15), aes(x=reorder(Skill, Count), y=Count)) + geom_bar(stat="identity") + geom_text(aes(label=Count), position=position_dodge(width=0.9), vjust=-0.25) + theme_classic() + ylim(0, 3000) + xlab('Skills') + ylab('Count of Jobs that wants this skill')
    
  })
  
  output$JobCategoryBoxPlot <- renderPlot({
    shiny::validate(
      need(input$industry_chosen, "Input a value first!")
    )
    
    career_data <- latest_data %>% select(Company, `Job Category`, `Adjusted Salary`)
    
    career_data <- career_data %>% 
      rename(Company = Company, Category = `Job Category`, Salary = `Adjusted Salary`) %>%
      filter(Category %in% unlist(input$industry_chosen))
    
    ggplot(career_data, aes(x=Salary, y = reorder(Category, Salary, median, order = TRUE))) + geom_boxplot() + theme_classic()
    
  })
  
  output$MapPlot <- renderLeaflet({

    career_loc <- latest_data %>% 
      select(Company, Lat, Lng)
    
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(data =career_loc , lng = ~Lng , lat = ~Lat , radius = 5 , clusterOptions = markerClusterOptions())
    
  })
  
  output$JobMonthsPlot <- renderHighchart({
    shiny::validate(
      need(input$MonthsShow, "Input a value first!")
    )
    
    df5 <- latest_data %>%
      mutate(month = format(`Created At`, "%m"), year = format(`Created At`, "%Y")) %>%
      group_by(month, year) %>%
      count(month)
    
    colnames(df5)[1] <- "Year"
    colnames(df5)[2] <- "Month"
    colnames(df5)[3] <- "Count"
    
    df5$MonthYear <- paste(df5$Month, df5$Year)
    
    df5 <- df5[,c("MonthYear","Count")]
    names <- c('YearMonth', 'Count')
    colnames(df5) <- names
    df5 = df5[
      with(df5, order(df5$YearMonth)),
    ]
    
    df5 = head(df5, input$MonthsShow)
    df5 %>%
      hchart('column', hcaes(x = YearMonth, y = Count))
  })
  
  output$CompanyPlot <- renderPlot({
    shiny::validate(
      need(input$CompaniesShow, "Input a value first!")
    )
    
    by_coy <- latest_data %>% 
      group_by(Company) %>% 
      summarise(n = n()) %>% 
      arrange(desc(n)) %>% 
      filter(Company != "THE SUPREME HR ADVISORY PTE. LTD.") %>% 
      filter(Company != "TALENT TRADER GROUP PTE. LTD.") %>% 
      filter(Company != "STAFFONDEMAND PTE. LTD.") %>% 
      filter(Company != "RECRUIT EXPRESS PTE LTD") %>%
      filter(Company != "RECRUIT EXPERT PTE. LTD.") %>%
      filter(Company != "ABER CARE PTE. LTD.") %>%
      filter(Company != "SNAPHUNT PTE. LTD.")%>% 
      filter(Company != "PEOPLE PROFILERS PTE. LTD.") %>% 
      filter(Company != "ABOVE HR PTE. LTD.") %>% 
      filter(Company != "CORESTAFF PTE. LTD.") %>% 
      filter(Company != "CAPITA PTE. LTD.") %>% 
      filter(Company != "MANPOWER STAFFING SERVICES (SINGAPORE) PTE LTD") %>% 
      filter(Company != "OUR RECRUITERS LLP") %>% 
      filter(Company != "ACTIVE MANPOWER RESOURCES PTE. LTD.") %>% 
      filter(Company != "ADECCO PERSONNEL PTE LTD") %>% 
      filter(Company != "RANDSTAD PTE. LIMITED") %>% 
      slice(0:10)
    
    (by_coy)
    
    by_coy$shortCoy = str_wrap(by_coy$Company, width = 10)
    
    by_coy2 = head(by_coy, input$CompaniesShow)
    
    
    ggplot(data=by_coy2, aes(x=(reorder(shortCoy,-n)), y=n)) +
      geom_bar(stat="identity", aes(fill = as.factor(n)),show.legend = FALSE)+
      theme_classic()+
      scale_fill_brewer(palette = "BrBG")+
      labs(x = "Company", y = "Counts") + 
      ggtitle("Top Companies with Most Jobs") + 
      theme(axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20),
            plot.title = element_text(size = 20, hjust = 0.5),
            axis.text.x = element_text(size = 20))
    
  })
}

shinyApp(ui=ui, server = server)