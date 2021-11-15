## app.R ##
packages = c('DT', 'ggplot2', 'shinydashboard', 'tidyverse', 'dplyr', 'leaflet', 'packrat', 'rsconnect', 'shiny', 'shinycssloaders', 'shinythemes', 'plotly', 'gridExtra', "RColorBrewer", 'highcharter')

for(p in packages){
  if(!require(p, character.only = T)){
    install.packages(p)
  }
  library(p, character.only = T)
}



# Loading data
latest_data = read_csv('data\\MyCareersFuture_04_04_2021.csv')
skills = read_csv('data\\Skills.csv')
skills = skills[order(-skills$Count),]
glints_dataset = read_csv('data\\Glints_03_26_2021.csv')
ges_data = read_csv('data\\graduate-employment-survey-ntu-nus-sit-smu-suss-sutd.csv')

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "HelpJobs", titleWidth="187px"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home Dashboard", tabName ="home", icon=icon("home", lib='glyphicon')),
      menuItem("Skills vs Job", tabName = "jobs_skills", icon = icon("education", lib="glyphicon")),
      menuItem("Salary Distribution By Industry", tabName = "salary_dist", icon = icon("industry")),
      menuItem("Where are the jobs located?", tabName = "jobs_map", icon = icon("map-marker-alt")),
      menuItem("Month with most jobs", tabName= "jobs_month", icon=icon("calendar")),
      menuItem("Companies with most listings", tabName= "company_jobs", icon=icon("briefcase")),
      menuItem("Salary vs University", tabName= "salary_vs_industry", icon=icon("money-bill-alt")),
      menuItem("Glints vs MyCareersFuture", tabName= "glints_vs_mcf", icon=icon("industry")),
      menuItem("Data Exploration - Jobs", tabName= "data_exploration", icon=icon("acquisitions-incorporated")),
      menuItem("Data Exploration - Skills", tabName= "data_exploration2", icon=icon("map"))
    )
  ),
  ## Body content
  dashboardBody(
    tabItems(
      # Home tab
      tabItem(tabName = "home",
              includeMarkdown("home.Rmd")
      ),
      
      # First tab content
      tabItem(tabName = "jobs_skills",
              includeMarkdown("jobskill.Rmd"),
              fluidRow(
                box(width=8, withSpinner(plotOutput(outputId = "SalaryHelper"))),
                
                box(width=4,
                  title = "Select mode", background = "black", solidHeader = TRUE,
                  selectInput(inputId = 'mode_chosen',
                              label = "",
                              choices = c("Top 10 Skills", "Display chosen skill", "Programming Skills", "Business Development Skills"), 
                              selected = "Top 10 Skills")
                ),
                box(width=4,
                  title = "Select skill(s)", background = "maroon", solidHeader = TRUE,
                  selectInput(inputId = 'skills_chosen',
                                     multiple = TRUE,
                                     label = "",
                                     choices = c(".NET" = ".NET","Agile Methodologies" = "Agile Methodologies","C#" = "C#","Information Technology" = "Information Technology","Java" = "Java","JavaScript" = "JavaScript","Job Descriptions" = "Job Descriptions","Microsoft Technologies" = "Microsoft Technologies","Software Development" = "Software Development","SQL" = "SQL","Web Services" = "Web Services","XML" = "XML","Plan" = "Plan","Agile Development" = "Agile Development","C++" = "C++","MySQL" = "MySQL","OOAD" = "OOAD","Software developing" = "Software developing","Change" = "Change","Content Delivery" = "Content Delivery","Customer Service" = "Customer Service","Driving" = "Driving","Driving License" = "Driving License","Logistics" = "Logistics","Maintenance" = "Maintenance","Punctual" = "Punctual","Service Delivery" = "Service Delivery","Account Management" = "Account Management","Budgets" = "Budgets","Business Development" = "Business Development","Event Planning" = "Event Planning","Management" = "Management","Marketing" = "Marketing","Marketing Strategy" = "Marketing Strategy","New Business Development" = "New Business Development","Sales" = "Sales","Sales Management" = "Sales Management","Social Media" = "Social Media","Workshops" = "Workshops","Evaluating" = "Evaluating","Technical knowledge" = "Technical knowledge","Analytical Skills" = "Analytical Skills","Commitment to Customer Service" = "Commitment to Customer Service","Complaint Management" = "Complaint Management","Flexibility" = "Flexibility","Front Office" = "Front Office","Hospitality" = "Hospitality","Hospitality Industry" = "Hospitality Industry","Hotels" = "Hotels","Opera" = "Opera","Outstanding Customer Service" = "Outstanding Customer Service","Receptionist Duties" = "Receptionist Duties","Supervising" = "Supervising","Clean Rooms" = "Clean Rooms","Compliance" = "Compliance","Continuous Improvement" = "Continuous Improvement","Kaizen" = "Kaizen","Machine Tools" = "Machine Tools","Manufacturing" = "Manufacturing","Production" = "Production","Quality" = "Quality","Advertising" = "Advertising","Corporate Communications" = "Corporate Communications","Event Management" = "Event Management","Marketing Communications" = "Marketing Communications","Media Relations" = "Media Relations","Online Marketing" = "Online Marketing","Public Relations" = "Public Relations","Social Media Marketing" = "Social Media Marketing","Strategic Communications" = "Strategic Communications","Team Management" = "Team Management","Fax 2 Email" = "Fax 2 Email","Costing" = "Costing","Hygiene" = "Hygiene","Inventory" = "Inventory","Languages" = "Languages","Initiative" = "Initiative","Administrative Support" = "Administrative Support","Business Operations" = "Business Operations","Data Entry" = "Data Entry","English" = "English","Microsoft Excel" = "Microsoft Excel","Microsoft Office" = "Microsoft Office","Microsoft Word" = "Microsoft Word","PowerPoint" = "PowerPoint","Teamwork" = "Teamwork","Time Management" = "Time Management","Cooking" = "Cooking","Food" = "Food","Restaurants" = "Restaurants","Search" = "Search","Component Based Development" = "Component Based Development","Bartending" = "Bartending","Customer Satisfaction" = "Customer Satisfaction","Leadership" = "Leadership","Team Building" = "Team Building","Business Strategy" = "Business Strategy","Customer Experience" = "Customer Experience","Government" = "Government","Policy" = "Policy","Program Management" = "Program Management","Strategic Planning" = "Strategic Planning","Strategy" = "Strategy","On time" = "On time","Sales strategy" = "Sales strategy","Performance" = "Performance","Channel Management" = "Channel Management","E-payments" = "E-payments","Electronic Payments" = "Electronic Payments","Integration" = "Integration","Mobile Payments" = "Mobile Payments","Online Payments" = "Online Payments","Operation" = "Operation","Payment Gateways" = "Payment Gateways","Payment Services" = "Payment Services","Payment Solutions" = "Payment Solutions","Payment Systems" = "Payment Systems","Payments" = "Payments","Tourism" = "Tourism","EcoSYSTEMS" = "EcoSYSTEMS","Corporate Finance" = "Corporate Finance","Financial Analysis" = "Financial Analysis","Human Resources" = "Human Resources","Interpersonal Skills" = "Interpersonal Skills","Mobile" = "Mobile","Organisational Skills" = "Organisational Skills","Organized Multi-tasker" = "Organized Multi-tasker","Ability to work creatively" = "Ability to work creatively","RAPID" = "RAPID","B2B Marketing" = "B2B Marketing","Brand Awareness" = "Brand Awareness","Digital Marketing" = "Digital Marketing","Press Relations" = "Press Relations","Startups" = "Startups","Strategic Marketing" = "Strategic Marketing","Generate leads" = "Generate leads","Cross-functional Team Leadership" = "Cross-functional Team Leadership","Design Engineering" = "Design Engineering","Development" = "Development","Product Development" = "Product Development","Product Management" = "Product Management","Project Management" = "Project Management","Quality Control" = "Quality Control","Analytics" = "Analytics","Applied Mathematics" = "Applied Mathematics","CSS" = "CSS","Data" = "Data","Data Visualization" = "Data Visualization","KPI" = "KPI","Linux" = "Linux","Programming" = "Programming","Statistics" = "Statistics","Acting" = "Acting","Integrity" = "Integrity","New Media Strategy" = "New Media Strategy","Data analyses" = "Data analyses","Big Data" = "Big Data","Core Java" = "Core Java","CSS JavaScript" = "CSS JavaScript","Data Center" = "Data Center","Data Mining" = "Data Mining","JavaSE" = "JavaSE","DNS" = "DNS","Linux Kernel" = "Linux Kernel","Linux Server" = "Linux Server","MS operating system" = "MS operating system","Intellectual Property Classificatioin" = "Intellectual Property Classificatioin","C/C++" = "C/C++","Python" = "Python","SQL Server" = "SQL Server","Control" = "Control","Allergy" = "Allergy","Food Preparation" = "Food Preparation","Specifications" = "Specifications","Determined" = "Determined","Law" = "Law","Inventory Management" = "Inventory Management","Operations Management" = "Operations Management","Process Improvement" = "Process Improvement","Training" = "Training","HRM" = "HRM","Enterprise Technology Sales" = "Enterprise Technology Sales","Food & Beverage" = "Food & Beverage","Lead Generation" = "Lead Generation","Online Lead Generation" = "Online Lead Generation","Sales Presentation Skills" = "Sales Presentation Skills","JavaFX" = "JavaFX","Processing" = "Processing","Active Directory" = "Active Directory","Active Directory Experience" = "Active Directory Experience","Proxy" = "Proxy","Sop" = "Sop","Windows Azure" = "Windows Azure","CM" = "CM","Configuration Management" = "Configuration Management","ADFS" = "ADFS","Accounting" = "Accounting","Business Process" = "Business Process","Finance" = "Finance","Fusion" = "Fusion","Oracle" = "Oracle","Process Design" = "Process Design","SSC" = "SSC","Account Servicing" = "Account Servicing","B2B Sales" = "B2B Sales","IT Sales" = "IT Sales","Salary" = "Salary","Strong presentation skills" = "Strong presentation skills","Banquets" = "Banquets","Catering" = "Catering","Culinary Skills" = "Culinary Skills","Fine Dining" = "Fine Dining","Menu Development" = "Menu Development","Oracle Fusion" = "Oracle Fusion","Bistro" = "Bistro","Cloud" = "Cloud","Cloud Computing" = "Cloud Computing","Cloud Security" = "Cloud Security","Data Centre" = "Data Centre","Methodologies" = "Methodologies","Committed to Customer Satisfaction" = "Committed to Customer Satisfaction","Computer Hardware Installation" = "Computer Hardware Installation","Software Testing" = "Software Testing","Stakeholder Management" = "Stakeholder Management","Technical Support" = "Technical Support","Cost Management" = "Cost Management","High Availability" = "High Availability","Service Level Agreement" = "Service Level Agreement","TCP/IP" = "TCP/IP","Bash Scripting" = "Bash Scripting","HTTP protocol" = "HTTP protocol","OS experience" = "OS experience","CISSP" = "CISSP","Computer Security" = "Computer Security","Information Security" = "Information Security","Information Security Management" = "Information Security Management","Network Security" = "Network Security","Penetration Testing" = "Penetration Testing","Security" = "Security","Vulnerability Assessment" = "Vulnerability Assessment","Vulnerability Management" = "Vulnerability Management","Risk Mgmt" = "Risk Mgmt","Testing Techniques" = "Testing Techniques","Cross Selling" = "Cross Selling","Data Analysis" = "Data Analysis","Key Account Management" = "Key Account Management","Senior Stakeholder Management" = "Senior Stakeholder Management","Administration" = "Administration","Direct Sales" = "Direct Sales","Microsoft PowerPoint" = "Microsoft PowerPoint","Term Life Insurance" = "Term Life Insurance","Administration work" = "Administration work","Electronics" = "Electronics","Housekeeping" = "Housekeeping","Retail" = "Retail","Retail Branding" = "Retail Branding","Retail Buying" = "Retail Buying","Retail Category Management" = "Retail Category Management","Retail Industry" = "Retail Industry","Retail Management" = "Retail Management","Retail Marketing" = "Retail Marketing","Retail Sales" = "Retail Sales","Retail Sales Experience" = "Retail Sales Experience","Store Operations" = "Store Operations","Visual Merchandising" = "Visual Merchandising","Achieving sales targets" = "Achieving sales targets","Association Management" = "Association Management","Communications" = "Communications","Dynamic" = "Dynamic","Collaboration" = "Collaboration","Highly responsible" = "Highly responsible","Interpersonal Communication Abilities" = "Interpersonal Communication Abilities","Interpersonal Skill" = "Interpersonal Skill","Team Player" = "Team Player","Works Well in a Team" = "Works Well in a Team","Communication" = "Communication","Designer Jewelry" = "Designer Jewelry","Diamond Grading" = "Diamond Grading","Diamond Jewelry" = "Diamond Jewelry","Diamonds" = "Diamonds","Fashion Jewelry" = "Fashion Jewelry","Fashion Retail" = "Fashion Retail","Handmade Jewelry" = "Handmade Jewelry","Jewelry" = "Jewelry","Jewelry Design" = "Jewelry Design","Microsoft Dynamics" = "Microsoft Dynamics","Rough Diamonds" = "Rough Diamonds","Multi-tasker" = "Multi-tasker","Logistics Management" = "Logistics Management","Purchasing" = "Purchasing","Cold Calling" = "Cold Calling","Customer Relationship Management" = "Customer Relationship Management","Events Coordination" = "Events Coordination","Pricing Negotiation" = "Pricing Negotiation","Quotations" = "Quotations","Sales Support" = "Sales Support","Setting up meetings" = "Setting up meetings","Engineering" = "Engineering","Mechanical" = "Mechanical","Product Lifecycle Management" = "Product Lifecycle Management","Product Placement" = "Product Placement","SMT" = "SMT","Test Engineering" = "Test Engineering","Testing" = "Testing","Mechatronics Engineering" = "Mechatronics Engineering","Analysis" = "Analysis","Cash Receipts" = "Cash Receipts","Cashiering" = "Cashiering","Phone Etiquette" = "Phone Etiquette","Telephone Reception" = "Telephone Reception","Vendor Management" = "Vendor Management","Bilingual" = "Bilingual","Change Management" = "Change Management","Microsoft .NET" = "Microsoft .NET","Aftersales" = "Aftersales","Contract Management" = "Contract Management","Contract Negotiation" = "Contract Negotiation","Contract Review" = "Contract Review","Contractual Agreements" = "Contractual Agreements","Legal" = "Legal","Legal Documents" = "Legal Documents","Legal Writing" = "Legal Writing","Risk Analysis" = "Risk Analysis","Salesforce" = "Salesforce","Tailoring" = "Tailoring","Objective" = "Objective","Managing sales team" = "Managing sales team","Accounts Payable" = "Accounts Payable","Accounts Receivable" = "Accounts Receivable","Bookkeeping" = "Bookkeeping","Financial Reporting" = "Financial Reporting","Financial Statements" = "Financial Statements"))
                ),
                valueBoxOutput("approvalBox")
              ),
      ),
      tabItem(tabName = "salary_dist",
              includeMarkdown("salarydist.Rmd"),
              fluidRow(
                box(width=8, withSpinner(plotOutput(outputId = "IndustryPlot"))),
                box(width=4,
                  title = "Filter by Industry", background = "black", solidHeader = TRUE,
                  selectInput(inputId = 'industry_chosen',
                                     multiple = TRUE,
                                     label = "",
                                      selected = "Information Technology",
                                     choices = c("Information Technology" = "Information Technology","Logistics / Supply Chain" = "Logistics / Supply Chain","Advertising / Media" = "Advertising / Media","Customer Service" = "Customer Service","Manufacturing" = "Manufacturing","F&B" 
                                                 = "F&B","Accounting / Auditing / Taxation" = "Accounting / Auditing / Taxation","Marketing / Public Relations" = "Marketing / Public Relations","Sales / Retail" = "Sales / Retail","Events 
/ Promotions" = "Events / Promotions","Building and Construction" = "Building and Construction","Engineering" = "Engineering","Banking and Finance" = "Banking and Finance","General Management" = "General Management","Consulting" = "Consulting","Entertainment" = "Entertainment","Architecture / Interior Design" = "Architecture / Interior Design","Education and Training" = "Education and Training","Medical / Therapy Services" = "Medical / Therapy Services","Healthcare / Pharmaceutical" = "Healthcare / Pharmaceutical","Professional Services" = "Professional Services","Wholesale Trade" = "Wholesale Trade","Personal Care / Beauty" = "Personal Care / Beauty","Design" = "Design","Human Resources" = "Human Resources","Legal" = "Legal","Sciences / Laboratory / R&D" = "Sciences / Laboratory / R&D","Repair and Maintenance" = "Repair and Maintenance","Environment / Health" = "Environment / Health","Social Services" = "Social Services","Travel / Tourism" = "Travel / Tourism","Hospitality" = "Hospitality","Telecommunications" = "Telecommunications","Purchasing / Merchandising" = "Purchasing / Merchandising","Insurance" = "Insurance","Real Estate / Property Management" = "Real Estate / Property Management","Security and Investigation" = "Security and Investigation",
                                                 "Risk Management" = "Risk Management","Public / Civil Service" = "Public / Civil Service"))
                ),
              ),
      ),
      tabItem(tabName = "jobs_map",
              includeMarkdown("map.Rmd"),
              fluidRow(
                box(width=8,withSpinner(leafletOutput(outputId = "LeafletJobsMap"))),
                box(width=4,
                  title = "Filter by Industries", background = "black", solidHeader = TRUE,
                  selectInput(inputId = 'industry_chosen_2',
                                     label = "",
                                     choices = c("Information Technology" = "Information Technology","Logistics / Supply Chain" = "Logistics / Supply Chain","Advertising / Media" = "Advertising / Media","Customer Service" = "Customer Service","Manufacturing" = "Manufacturing","F&B" 
                                                 = "F&B","Accounting / Auditing / Taxation" = "Accounting / Auditing / Taxation","Marketing / Public Relations" = "Marketing / Public Relations","Sales / Retail" = "Sales / Retail","Events 
/ Promotions" = "Events / Promotions","Building and Construction" = "Building and Construction","Engineering" = "Engineering","Banking and Finance" = "Banking and Finance","General Management" = "General Management","Consulting" = "Consulting","Entertainment" = "Entertainment","Architecture / Interior Design" = "Architecture / Interior Design","Education and Training" = "Education and Training","Medical / Therapy Services" = "Medical / Therapy Services","Healthcare / Pharmaceutical" = "Healthcare / Pharmaceutical","Professional Services" = "Professional Services","Wholesale Trade" = "Wholesale Trade","Personal Care / Beauty" = "Personal Care / Beauty","Design" = "Design","Human Resources" = "Human Resources","Legal" = "Legal","Sciences / Laboratory / R&D" = "Sciences / Laboratory / R&D","Repair and Maintenance" = "Repair and Maintenance","Environment / Health" = "Environment / Health","Social Services" = "Social Services","Travel / Tourism" = "Travel / Tourism","Hospitality" = "Hospitality","Telecommunications" = "Telecommunications","Purchasing / Merchandising" = "Purchasing / Merchandising","Insurance" = "Insurance","Real Estate / Property Management" = "Real Estate / Property Management","Security and Investigation" = "Security and Investigation",
                                                 "Risk Management" = "Risk Management","Public / Civil Service" = "Public / Civil Service"))
                ),
                valueBoxOutput("approvalBox3")
              ),
      ),
      tabItem(tabName = "glints_vs_mcf",
              includeMarkdown("salarydist.Rmd"),
              fluidRow(
                box(width=8, withSpinner(plotOutput(outputId = "IndustryPlot_MCF"))),
                box(width=4,
                    title = "Filter by Industry", background = "black", solidHeader = TRUE,
                    selectInput(inputId = 'industry_chosen_3',
                                multiple = TRUE,
                                label = "",
                                selected = "Engineering",
                                choices = c("Information Technology" = "Information Technology","Logistics / Supply Chain" = "Logistics / Supply Chain","Advertising / Media" = "Advertising / Media","Customer Service" = "Customer Service","Manufacturing" = "Manufacturing","F&B" 
                                            = "F&B","Accounting / Auditing / Taxation" = "Accounting / Auditing / Taxation","Marketing / Public Relations" = "Marketing / Public Relations","Sales / Retail" = "Sales / Retail","Events 
/ Promotions" = "Events / Promotions","Building and Construction" = "Building and Construction","Engineering" = "Engineering","Banking and Finance" = "Banking and Finance","General Management" = "General Management","Consulting" = "Consulting","Entertainment" = "Entertainment","Architecture / Interior Design" = "Architecture / Interior Design","Education and Training" = "Education and Training","Medical / Therapy Services" = "Medical / Therapy Services","Healthcare / Pharmaceutical" = "Healthcare / Pharmaceutical","Professional Services" = "Professional Services","Wholesale Trade" = "Wholesale Trade","Personal Care / Beauty" = "Personal Care / Beauty","Design" = "Design","Human Resources" = "Human Resources","Legal" = "Legal","Sciences / Laboratory / R&D" = "Sciences / Laboratory / R&D","Repair and Maintenance" = "Repair and Maintenance","Environment / Health" = "Environment / Health","Social Services" = "Social Services","Travel / Tourism" = "Travel / Tourism","Hospitality" = "Hospitality","Telecommunications" = "Telecommunications","Purchasing / Merchandising" = "Purchasing / Merchandising","Insurance" = "Insurance","Real Estate / Property Management" = "Real Estate / Property Management","Security and Investigation" = "Security and Investigation",
                                            "Risk Management" = "Risk Management","Public / Civil Service" = "Public / Civil Service"))
                ),
                box(width=8, withSpinner(plotOutput(outputId = "IndustryPlot_Glints")))
              ),
      ),
      tabItem(tabName = "jobs_month",
              includeMarkdown("jobdemand.Rmd"),
              fluidRow(
                #line chart graph here --> outputID = JobMonthsLine
              ),
              fluidRow(
                box(width=8,withSpinner(plotlyOutput(outputId = "JobMonthsLine"))),
                box(width=4,
                    title = "Filter by Industries", background = "black", solidHeader = TRUE,
                    selectInput(inputId = 'industry_chosen_4',
                                label = "",
                                choices = c("Information Technology" = "Information Technology","Logistics / Supply Chain" = "Logistics / Supply Chain","Advertising / Media" = "Advertising / Media","Customer Service" = "Customer Service","Manufacturing" = "Manufacturing","F&B" 
                                            = "F&B","Accounting / Auditing / Taxation" = "Accounting / Auditing / Taxation","Marketing / Public Relations" = "Marketing / Public Relations","Sales / Retail" = "Sales / Retail","Events 
/ Promotions" = "Events / Promotions","Building and Construction" = "Building and Construction","Engineering" = "Engineering","Banking and Finance" = "Banking and Finance","General Management" = "General Management","Consulting" = "Consulting","Entertainment" = "Entertainment","Architecture / Interior Design" = "Architecture / Interior Design","Education and Training" = "Education and Training","Medical / Therapy Services" = "Medical / Therapy Services","Healthcare / Pharmaceutical" = "Healthcare / Pharmaceutical","Professional Services" = "Professional Services","Wholesale Trade" = "Wholesale Trade","Personal Care / Beauty" = "Personal Care / Beauty","Design" = "Design","Human Resources" = "Human Resources","Legal" = "Legal","Sciences / Laboratory / R&D" = "Sciences / Laboratory / R&D","Repair and Maintenance" = "Repair and Maintenance","Environment / Health" = "Environment / Health","Social Services" = "Social Services","Travel / Tourism" = "Travel / Tourism","Hospitality" = "Hospitality","Telecommunications" = "Telecommunications","Purchasing / Merchandising" = "Purchasing / Merchandising","Insurance" = "Insurance","Real Estate / Property Management" = "Real Estate / Property Management","Security and Investigation" = "Security and Investigation",
                                            "Risk Management" = "Risk Management","Public / Civil Service" = "Public / Civil Service"))
                ),
                valueBoxOutput("approvalBox4")
              )
      ),
      tabItem(tabName = "company_jobs",
              includeMarkdown("companyjobs.rmd"),
              fluidRow(
                box(width=8,withSpinner(plotOutput(outputId = "CompanyPlot"))),
                box(width=4,
                  title = "Companies to display", background = "black", solidHeader = TRUE,
                  sliderInput(inputId = "CompaniesShow",
                              label = "",
                              min = 1,
                              max = 10,
                              value = 5,
                              width = "520px")),
                valueBoxOutput("approvalBox5")
              ),
      ),
      tabItem(tabName = "salary_vs_industry",
              includeMarkdown("salaryind.Rmd"),
              fluidRow(
                box(width=8,withSpinner(plotOutput(outputId = "SalaryIndustryPlot"))),
                box(width=4,
                  title = "Select degree", background = "black", solidHeader = TRUE,
                  selectInput(inputId = 'degree_chosen',
                              label = "",
                              choices = c("Accountancy and Business" = "Accountancy and Business","Accountancy (3-yr direct Honours Programme)" = "Accountancy (3-yr direct Honours Programme)","Business (3-yr direct Honours Programme)" = "Business (3-yr direct Honours Programme)","Business and Computing" = "Business and Computing","Aerospace Engineering" = "Aerospace Engineering","Bioengineering" = "Bioengineering","Chemical and Biomolecular Engineering" = "Chemical and Biomolecular Engineering","Computer Engineering" = "Computer Engineering","Civil Engineering" = "Civil Engineering","Computer Science" = "Computer Science","Electrical and Electronic Engineering" = "Electrical and Electronic Engineering","Environmental Engineering" = "Environmental Engineering","Information Engineering and Media" = "Information Engineering and Media","Materials Engineering" = "Materials Engineering","Mechanical Engineering" = "Mechanical Engineering","Maritime Studies" = "Maritime Studies","Art" = "Art","Design & Media" = "Design & Media","Chinese" = "Chinese","Communication Studies" = "Communication Studies","Economics" = "Economics","English" = "English","Linguistics and Multilingual Studies" = "Linguistics and Multilingual Studies","Psychology" = "Psychology","Sociology" = "Sociology","Biomedical Sciences **" = "Biomedical Sciences **","Biomedical Sciences (Traditional Chinese Medicine) #" = "Biomedical Sciences (Traditional Chinese Medicine) #","Biological Sciences" = "Biological Sciences","Chemistry & Biological Chemistry" = "Chemistry & Biological Chemistry","Mathematics & Economics **" = "Mathematics & Economics **","Mathematical Science" = "Mathematical Science","Physics / Applied Physics" = "Physics / Applied Physics","Sports Science and Management" = "Sports Science and Management","Science (with Education)" = "Science (with Education)","Arts (with Education)" = "Arts (with Education)","Bachelor of Arts" = "Bachelor of Arts","Bachelor of Arts (Hons)" = "Bachelor of Arts (Hons)","Bachelor of Social Sciences" = "Bachelor of Social Sciences","Bachelor of Business Administration" = "Bachelor of Business Administration","Bachelor of Business Administration (Hons)" = "Bachelor of Business Administration (Hons)","Bachelor of Business Administration (Accountancy)" = "Bachelor of Business Administration (Accountancy)","Bachelor of Business Administration (Accountancy) (Hons)" = "Bachelor of Business Administration (Accountancy) (Hons)","Bachelor of Computing (Communications and Media)" = "Bachelor of Computing (Communications and Media)","Bachelor of Computing (Computational Biology) **" = "Bachelor of Computing (Computational Biology) **","Bachelor of Computing (Computer Engineering) **" = "Bachelor of Computing (Computer Engineering) **","Bachelor of Computing (Computer Science)" = "Bachelor of Computing (Computer Science)","Bachelor of Computing (Electronic Commerce)" = "Bachelor of Computing (Electronic Commerce)","Bachelor of Computing (Information Systems)" = "Bachelor of Computing (Information Systems)","Bachelor of Dental Surgery" = "Bachelor of Dental Surgery","Bachelor of Arts (Architecture) ** #" = "Bachelor of Arts (Architecture) ** #","Bachelor of Arts (Industrial Design)" = "Bachelor of Arts (Industrial Design)","Bachelor of Science (Project and Facilities Management)" = "Bachelor of Science (Project and Facilities Management)","Bachelor of Science (Real Estate)" = "Bachelor of Science (Real Estate)","Bachelor of Engineering (Bioengineering)" = "Bachelor of Engineering (Bioengineering)","Bachelor of Engineering (Chemical Engineering)" = "Bachelor of Engineering (Chemical Engineering)","Bachelor of Engineering (Civil Engineering)" = "Bachelor of Engineering (Civil Engineering)","Bachelor of Engineering (Computer Engineering)" = "Bachelor of Engineering (Computer Engineering)","Bachelor of Engineering (Electrical Engineering)" = "Bachelor of Engineering (Electrical Engineering)","Bachelor of Engineering (Engineering Science)" = "Bachelor of Engineering (Engineering Science)","Bachelor of Engineering (Environmental Engineering)" = "Bachelor of Engineering (Environmental Engineering)","Bachelor of Engineering (Industrial and Systems Engineering)" = "Bachelor of Engineering (Industrial and Systems Engineering)","Bachelor of Engineering (Materials Science and Engineering)" = "Bachelor of Engineering (Materials Science and Engineering)","Bachelor of Engineering (Mechanical Engineering)" = "Bachelor of Engineering (Mechanical Engineering)","Bachelor of Laws (LLB) (Hons) #" = "Bachelor of Laws (LLB) (Hons) #","Bachelor of Medicine and Bachelor of Surgery (MBBS) #" = "Bachelor of Medicine and Bachelor of Surgery (MBBS) #","Bachelor of Science (Nursing)" = "Bachelor of Science (Nursing)","Bachelor of Science (Nursing) (Hons)" = "Bachelor of Science (Nursing) (Hons)","Bachelor of Music **" = "Bachelor of Music **","Bachelor of Applied Science **" = "Bachelor of Applied Science **","Bachelor of Applied Science (Hons)" = "Bachelor of Applied Science (Hons)","Bachelor of Science" = "Bachelor of Science","Bachelor of Science (Hons)" = "Bachelor of Science (Hons)","Bachelor of Science (Computational Biology) **" = "Bachelor of Science (Computational Biology) **","Bachelor of Science (Pharmacy) (Hons) #" = "Bachelor of Science (Pharmacy) (Hons) #","Accountancy (4-years programme)" = "Accountancy (4-years programme)","Accountancy (4-years programme) Cum Laude and above" = "Accountancy (4-years programme) Cum Laude and above","Business Management (4-years programme)" = "Business Management (4-years programme)","Business Management (4-years programme) Cum Laude and above" = "Business Management (4-years programme) Cum Laude and above","Economics (4-years programme)" = "Economics (4-years programme)","Economics (4-years programme) Cum Laude and above" = "Economics (4-years programme) Cum Laude and above","Information Systems Management (4-years programme)" = "Information Systems Management (4-years programme)","Information Systems Management (4-years programme) Cum Laude and above" = "Information Systems Management (4-years programme) Cum Laude and above","Social Sciences (4-years programme)" = "Social Sciences (4-years programme)","Social Sciences (4-years programme) Cum Laude and above" = "Social Sciences (4-years programme) Cum Laude and above","Law (4-years programme) #" = "Law (4-years programme) #","Law (4-years programme) Cum Laude and above #" = "Law (4-years programme) Cum Laude and above #","Biomedical Science **" = "Biomedical Science **","Biomedical Science (Traditional Chinese Medicine) #" = "Biomedical Science (Traditional Chinese Medicine) #","Mathematics & Economics" = "Mathematics & Economics","Bachelor of Arts (Architecture) #" = "Bachelor of Arts (Architecture) #","Bachelor of Engineering (Biomedical Engineering) ^^" = "Bachelor of Engineering (Biomedical Engineering) ^^","Bachelor of Medicine and Bachelor of Surgery #" = "Bachelor of Medicine and Bachelor of Surgery #","Accountancy (4-year programme)" = "Accountancy (4-year programme)","Accountancy (4-year programme) Cum Laude and above" = "Accountancy (4-year programme) Cum Laude and above","Business Management (4-year programme)" = "Business Management (4-year programme)","Business Management (4-year programme) Cum Laude and above" = "Business Management (4-year programme) Cum Laude and above","Economics (4-year programme)" = "Economics (4-year programme)","Economics (4-year programme) Cum Laude and above" = "Economics (4-year programme) Cum Laude and above","Information Systems Management (4-year programme)" = "Information Systems Management (4-year programme)","Information Systems Management (4-year programme) Cum Laude and above" = "Information Systems Management (4-year programme) Cum Laude and above","Social Sciences (4-year programme)" = "Social Sciences (4-year programme)","Social Sciences (4-year programme) Cum Laude and above" = "Social Sciences (4-year programme) Cum Laude and above","Law (4-year programme) #" = "Law (4-year programme) #","Law (4-year programme) Cum Laude and above #" = "Law (4-year programme) Cum Laude and above #","Bachelor of Arts in Game Design" = "Bachelor of Arts in Game Design","Bachelor of Fine Arts in Digital Arts & Animation" = "Bachelor of Fine Arts in Digital Arts & Animation","Bachelor of Science in Computer Science & Game Design" = "Bachelor of Science in Computer Science & Game Design","Bachelor of Science in Computer Science in Real-Time Interactive Simulation" = "Bachelor of Science in Computer Science in Real-Time Interactive Simulation","Bachelor of Arts with Honours in Communication Design" = "Bachelor of Arts with Honours in Communication Design","Bachelor of Arts with Honours in Interior Design" = "Bachelor of Arts with Honours in Interior Design","Bachelor of Engineering with Honours in Chemical Engineering" = "Bachelor of Engineering with Honours in Chemical Engineering","Bachelor of Engineering with Honours in Marine Engineering" = "Bachelor of Engineering with Honours in Marine Engineering","Bachelor of Engineering with Honours in Mechanical Design & Manufacturing Engineering" = "Bachelor of Engineering with Honours in Mechanical Design & Manufacturing Engineering","Bachelor of Engineering with Honours in Naval Architecture" = "Bachelor of Engineering with Honours in Naval Architecture","Bachelor of Engineering with Honours in Offshore Engineering" = "Bachelor of Engineering with Honours in Offshore Engineering","Bachelor of Science with Honours in Food & Human Nutrition" = "Bachelor of Science with Honours in Food & Human Nutrition","Bachelor of Science in Chemical Engineering" = "Bachelor of Science in Chemical Engineering","Bachelor of Science in Electrical Engineering & Information Technology" = "Bachelor of Science in Electrical Engineering & Information Technology","Bachelor of Professional Studies in Culinary Arts Management" = "Bachelor of Professional Studies in Culinary Arts Management","Bachelor in Science (Occupational Therapy)" = "Bachelor in Science (Occupational Therapy)","Bachelor in Science (Physiotherapy)" = "Bachelor in Science (Physiotherapy)","Bachelor of Engineering with Honours in Aeronautical Engineering" = "Bachelor of Engineering with Honours in Aeronautical Engineering","Bachelor of Engineering with Honours in Aerospace Systems" = "Bachelor of Engineering with Honours in Aerospace Systems","Bachelor of Engineering with Honours in Mechanical Design Engineering" = "Bachelor of Engineering with Honours in Mechanical Design Engineering","Bachelor of Engineering with Honours in Mechatronics" = "Bachelor of Engineering with Honours in Mechatronics","Bachelor of Science with Honours in Nursing Practice" = "Bachelor of Science with Honours in Nursing Practice","Bachelor of Science (Major in Hospitality Management)" = "Bachelor of Science (Major in Hospitality Management)","Bachelor of Science in Early Childhood Education" = "Bachelor of Science in Early Childhood Education","Aerospace Engineering and Economics **" = "Aerospace Engineering and Economics **","Business and Computer Engineering **" = "Business and Computer Engineering **","Chemical And Biomolecular Engineering" = "Chemical And Biomolecular Engineering","Chemical And Biomolecular Engineering and Economics **" = "Chemical And Biomolecular Engineering and Economics **","Electrical And Electronic Engineering" = "Electrical And Electronic Engineering","Environmental Engineering and Economics **" = "Environmental Engineering and Economics **","Information Engineering And Media" = "Information Engineering And Media","Information Engineering And Media and Economics **" = "Information Engineering And Media and Economics **","Mechanical Engineering and Economics **" = "Mechanical Engineering and Economics **","Linguistics And Multilingual Studies" = "Linguistics And Multilingual Studies","Bachelor of Engineering (Biomedical Engineering)" = "Bachelor of Engineering (Biomedical Engineering)","Bachelor of Laws (L.L.B) (Hons) #" = "Bachelor of Laws (L.L.B) (Hons) #","Bachelor of Music" = "Bachelor of Music","Bachelor of Environmental Studies" = "Bachelor of Environmental Studies","Accountancy" = "Accountancy","Accountancy Cum Laude and above" = "Accountancy Cum Laude and above","Business Management" = "Business Management","Business Management Cum Laude and above" = "Business Management Cum Laude and above","Economics Cum Laude and above" = "Economics Cum Laude and above","Information Systems Management" = "Information Systems Management","Information Systems Management Cum Laude and above" = "Information Systems Management Cum Laude and above","Social Sciences" = "Social Sciences","Social Sciences Cum Laude and above" = "Social Sciences Cum Laude and above","Law #" = "Law #","Law Cum Laude and above #" = "Law Cum Laude and above #","Bachelor of Engineering (Engineering Product Development)" = "Bachelor of Engineering (Engineering Product Development)","Bachelor of Engineering (Engineering Systems and Design)" = "Bachelor of Engineering (Engineering Systems and Design)","Bachelor of Engineering (Information Systems Technology and Design)" = "Bachelor of Engineering (Information Systems Technology and Design)","Bachelor of Science (Architecture and Sustainable Design) ###" = "Bachelor of Science (Architecture and Sustainable Design) ###","Bachelor of Arts in Game Design **" = "Bachelor of Arts in Game Design **","Bachelor of Science in Computer Science & Game Design **" = "Bachelor of Science in Computer Science & Game Design **","Bachelor of Engineering with Honours in Electrical Power Engineering" = "Bachelor of Engineering with Honours in Electrical Power Engineering","Bachelor in Science (Diagnostic Radiography)" = "Bachelor in Science (Diagnostic Radiography)","Bachelor in Science (Radiation Therapy) **" = "Bachelor in Science (Radiation Therapy) **","Bachelor of Science with Honours in Computing Science" = "Bachelor of Science with Honours in Computing Science","Business" = "Business","Materials Engineering and Economics **" = "Materials Engineering and Economics **","History" = "History","Public Policy And Global Affairs **" = "Public Policy And Global Affairs **","Biomedical Sciences & Chinese Medicine #" = "Biomedical Sciences & Chinese Medicine #","Mathematical Sciences" = "Mathematical Sciences","Bachelor of Engineering (Materials Science And Engineering)" = "Bachelor of Engineering (Materials Science And Engineering)","Bachelor of Science (Pharmacy)(Hons) #" = "Bachelor of Science (Pharmacy)(Hons) #","Bachelor of Computing (Communications And Media) **" = "Bachelor of Computing (Communications And Media) **","Bachelor of Computing (Electronic Commerce) **" = "Bachelor of Computing (Electronic Commerce) **","Bachelor of Medicine and Bachelor Of Surgery #" = "Bachelor of Medicine and Bachelor Of Surgery #","Bachelor of Arts with Honours in Criminology and Security" = "Bachelor of Arts with Honours in Criminology and Security","Bachelor of Science (Architecture and Sustainable Design) #" = "Bachelor of Science (Architecture and Sustainable Design) #","Bachelor of Accountancy (Hons)" = "Bachelor of Accountancy (Hons)","Double Degree in Bachelor of Accountancy (Hons) and Bachelor of Business (Hons)" = "Double Degree in Bachelor of Accountancy (Hons) and Bachelor of Business (Hons)","Bachelor of Business (Hons)" = "Bachelor of Business (Hons)","Double Degree in Bachelor of Business (Hons) and Bachelor of Engineering (Hons) (Computer Science)" = "Double Degree in Bachelor of Business (Hons) and Bachelor of Engineering (Hons) (Computer Science)","Bachelor of Engineering (Hons) (Aerospace Engineering)" = "Bachelor of Engineering (Hons) (Aerospace Engineering)","Double Degree in Bachelor of Engineering (Hons) (Aerospace Engineering) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering (Hons) (Aerospace Engineering) and Bachelor of Arts (Hons) in Economics **","Bachelor of Engineering (Hons) (Bioengineering)" = "Bachelor of Engineering (Hons) (Bioengineering)","Bachelor of Engineering  (Hons) (Chemical And Biomolecular Engineering)" = "Bachelor of Engineering  (Hons) (Chemical And Biomolecular Engineering)","Double Degree in Bachelor of Engineering  (Hons) (Chemical And Biomolecular Engineering) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering  (Hons) (Chemical And Biomolecular Engineering) and Bachelor of Arts (Hons) in Economics **","Bachelor of Engineering (Hons) (Civil Engineering)" = "Bachelor of Engineering (Hons) (Civil Engineering)","Double Degree in Bachelor of Engineering (Hons) (Civil Engineering) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering (Hons) (Civil Engineering) and Bachelor of Arts (Hons) in Economics **","Bachelor of Engineering (Hons) (Computer Engineering)" = "Bachelor of Engineering (Hons) (Computer Engineering)","Bachelor of Engineering (Hons) (Computer Science)" = "Bachelor of Engineering (Hons) (Computer Science)","Double Degree in Bachelor of Business (Hons) and Bachelor of Engineering (Hons) (Computer Engineering) **" = "Double Degree in Bachelor of Business (Hons) and Bachelor of Engineering (Hons) (Computer Engineering) **","Bachelor of Engineering (Hons) (Electrical & Electronic Engineering)" = "Bachelor of Engineering (Hons) (Electrical & Electronic Engineering)","Bachelor of Engineering (Hons) (Environmental Engineering)" = "Bachelor of Engineering (Hons) (Environmental Engineering)","Bachelor of Engineering (Hons) (Information Engineering & Media)" = "Bachelor of Engineering (Hons) (Information Engineering & Media)","Double Degree in Bachelor of Engineering (Hons) (Information Engineering & Media) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering (Hons) (Information Engineering & Media) and Bachelor of Arts (Hons) in Economics **","Bachelor of Science (Hons) (Maritime Studies)" = "Bachelor of Science (Hons) (Maritime Studies)","Bachelor of Engineering (Hons) (Materials Engineering)" = "Bachelor of Engineering (Hons) (Materials Engineering)","Double Degree in Bachelor of Engineering (Hons) (Materials Engineering) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering (Hons) (Materials Engineering) and Bachelor of Arts (Hons) in Economics **","Bachelor of Engineering (Hons) (Mechanical Engineering)" = "Bachelor of Engineering (Hons) (Mechanical Engineering)","Double Degree in Bachelor of Engineering (Hons) (Mechanical Engineering) and Bachelor of Arts (Hons) in Economics **" = "Double Degree in Bachelor of Engineering (Hons) (Mechanical Engineering) and Bachelor of Arts (Hons) in Economics **","Bachelor of Fine Arts (Hons)" = "Bachelor of Fine Arts (Hons)","Bachelor of Arts (Hons) in Chinese" = "Bachelor of Arts (Hons) in Chinese","Bachelor of Communication Studies (Hons)" = "Bachelor of Communication Studies (Hons)","Bachelor of Arts (Hons) in Economics" = "Bachelor of Arts (Hons) in Economics","Bachelor of Arts (Hons) in English" = "Bachelor of Arts (Hons) in English","Bachelor of Arts (Hons) in History" = "Bachelor of Arts (Hons) in History","Bachelor of Arts (Hons) in Linguistics And Multilingual Studies" = "Bachelor of Arts (Hons) in Linguistics And Multilingual Studies","Bachelor of Arts (Hons) in Philosophy **" = "Bachelor of Arts (Hons) in Philosophy **","Bachelor of Arts (Hons) in Psychology" = "Bachelor of Arts (Hons) in Psychology","Bachelor of Arts (Hons) in Public Policy And Global Affairs" = "Bachelor of Arts (Hons) in Public Policy And Global Affairs","Bachelor of Arts (Hons) in Sociology" = "Bachelor of Arts (Hons) in Sociology","Double Degree in Bachelor of Science (Hons) in Biomedical Sciences and Bachelor of Medicine (Chinese Medicine) #" = "Double Degree in Bachelor of Science (Hons) in Biomedical Sciences and Bachelor of Medicine (Chinese Medicine) #","Bachelor of Science (Hons) in Biological Sciences" = "Bachelor of Science (Hons) in Biological Sciences","Bachelor of Science (Hons) in Chemistry & Biological Chemistry" = "Bachelor of Science (Hons) in Chemistry & Biological Chemistry","Bachelor of Science (Hons) in Mathematical Sciences" = "Bachelor of Science (Hons) in Mathematical Sciences","Bachelor of Science (Hons) in Mathematics & Economics" = "Bachelor of Science (Hons) in Mathematics & Economics","Bachelor of Science (Hons) in Physics/Applied Physics" = "Bachelor of Science (Hons) in Physics/Applied Physics","Bachelor of Science (Hons) (Sport Science & Management)" = "Bachelor of Science (Hons) (Sport Science & Management)","Bachelor of Arts (Hons) (Education)" = "Bachelor of Arts (Hons) (Education)","Bachelor of Science (Hons) (Education)" = "Bachelor of Science (Hons) (Education)","Bachelor of Laws #" = "Bachelor of Laws #","Bachelor of Science (Pharmacy) #" = "Bachelor of Science (Pharmacy) #","Bachelor of Computing (Information Security) **" = "Bachelor of Computing (Information Security) **","Bachelor of Science (Business Analytics)" = "Bachelor of Science (Business Analytics)","Bachelor of Medicine And Bachelor Of Surgery #" = "Bachelor of Medicine And Bachelor Of Surgery #","Bachelor of Arts with Honours" = "Bachelor of Arts with Honours","Bachelor of Science with Honours" = "Bachelor of Science with Honours","Bachelor of Arts in Game Design ^" = "Bachelor of Arts in Game Design ^","Bachelor of Fine Arts in Digital Arts & Animation ^" = "Bachelor of Fine Arts in Digital Arts & Animation ^","Bachelor of Science in Computer Science & Game Design ^" = "Bachelor of Science in Computer Science & Game Design ^","Bachelor of Engineering with Honours in Marine Engineering ^" = "Bachelor of Engineering with Honours in Marine Engineering ^","Bachelor of Engineering with Honours in Naval Architecture ^" = "Bachelor of Engineering with Honours in Naval Architecture ^","Bachelor of Engineering with Honours in Offshore Engineering ^" = "Bachelor of Engineering with Honours in Offshore Engineering ^","Bachelor in Science (Diagnostic Radiography) **" = "Bachelor in Science (Diagnostic Radiography) **","Bachelor of Accountancy with Honours" = "Bachelor of Accountancy with Honours","Bachelor of Hospitality Business with Honours ^" = "Bachelor of Hospitality Business with Honours ^","Business and Computing ^" = "Business and Computing ^","Chemical & Biomolecular Engineering" = "Chemical & Biomolecular Engineering","Chemical & Biomolecular Engineering and Economics **" = "Chemical & Biomolecular Engineering and Economics **","Computer Engineering and Economics **" = "Computer Engineering and Economics **","Electrical & Electronic Engineering" = "Electrical & Electronic Engineering","Information Engineering & Media" = "Information Engineering & Media","Linguistics & Multilingual Studies" = "Linguistics & Multilingual Studies","Philosophy" = "Philosophy","Public Policy and Global Affairs" = "Public Policy and Global Affairs","Biomedical Sciences & Chinese Medicine # ^" = "Biomedical Sciences & Chinese Medicine # ^","Environmental Earth Systems Science ^" = "Environmental Earth Systems Science ^","Physics & Applied Physics" = "Physics & Applied Physics","Arts (With Education)" = "Arts (With Education)","Science (With Education)" = "Science (With Education)","Sport Science and Management" = "Sport Science and Management","Medicine ##" = "Medicine ##","Bachelor of Engineering (Engineering Science) **" = "Bachelor of Engineering (Engineering Science) **","Bachelor of Business Administration (Accountancy) ^" = "Bachelor of Business Administration (Accountancy) ^","Bachelor of Computing (Communications and Media) **" = "Bachelor of Computing (Communications and Media) **","Bachelor of Arts (Architecture) # **" = "Bachelor of Arts (Architecture) # **","Bachelor of Medicine and Bachelor of Surgery # **" = "Bachelor of Medicine and Bachelor of Surgery # **","Bachelor of Science with Honours ^" = "Bachelor of Science with Honours ^","Bachelor of Fine Arts in Digital Art and Animation" = "Bachelor of Fine Arts in Digital Art and Animation","Bachelor of Science in Computer Science and Game Design ^" = "Bachelor of Science in Computer Science and Game Design ^","Bachelor of Engineering with Honours in Mechanical Design and Manufacturing Engineering" = "Bachelor of Engineering with Honours in Mechanical Design and Manufacturing Engineering","Bachelor of Science with Honours in Food and Human Nutrition" = "Bachelor of Science with Honours in Food and Human Nutrition","Bachelor of Engineering with Honours in Information & Communications Technology (Information Security) ^" = "Bachelor of Engineering with Honours in Information & Communications Technology (Information Security) ^","Bachelor of Engineering with Honours in Information & Communications Technology (Software Engineering)" = "Bachelor of Engineering with Honours in Information & Communications Technology (Software Engineering)","Bachelor of Engineering with Honours in Sustainable Infrastructure Engineering (Land)" = "Bachelor of Engineering with Honours in Sustainable Infrastructure Engineering (Land)","Bachelor of Hospitality Business with Honours" = "Bachelor of Hospitality Business with Honours","Bachelor of Science with Honours in Nursing" = "Bachelor of Science with Honours in Nursing","Bachelor in Science (Diagnostic Radiography) ^" = "Bachelor in Science (Diagnostic Radiography) ^","Bachelor of Business Administration in Food Business Management" = "Bachelor of Business Administration in Food Business Management","Accountancy (Cum Laude and above)" = "Accountancy (Cum Laude and above)","Business Management (Cum Laude and above)" = "Business Management (Cum Laude and above)","Economics (Cum Laude and above)" = "Economics (Cum Laude and above)","Information Systems" = "Information Systems","Information Systems (Cum Laude and above)" = "Information Systems (Cum Laude and above)","Social Sciences (Cum Laude and above)" = "Social Sciences (Cum Laude and above)","Law (Cum Laude and above) #" = "Law (Cum Laude and above) #","Bachelor of Accountancy" = "Bachelor of Accountancy","Bachelor of Science in Finance" = "Bachelor of Science in Finance","Bachelor of Science in Marketing" = "Bachelor of Science in Marketing"))
                ),
                box(width=4,
                  title = "Select school", background = "maroon", solidHeader = TRUE,
                  selectInput(inputId = 'school_chosen',
                              label = "",
                              choices = c("Nanyang Technological University" = "Nanyang Technological University","National University of Singapore" = "National University of Singapore","Singapore Management University" = "Singapore Management University","Singapore Institute of Technology" = "Singapore Institute of Technology","Singapore University of Technology and Design" = "Singapore University of Technology and Design","Singapore University of Social Sciences" = "Singapore University of Social Sciences"))
                )
              ),
      ),
      tabItem(tabName = "data_exploration",
              includeMarkdown("jobtable.Rmd"),
              fluidRow(
                box(width=12, withSpinner(DT::dataTableOutput(outputId = "DatasetPlot"))),
              ),
      ),
      tabItem(tabName = "data_exploration2",
              includeMarkdown("skilltable.Rmd"),
              fluidRow(
                box(width=12, withSpinner(DT::dataTableOutput(outputId = "DatasetPlot2"))),
              ),
      )
    )
  )
)

server <- function(input, output) {
  programming_skills <- c("Python", ".NET", "MySQL", "Java", "C#", "C++", "C", "CSS")
  bd_skills <- c("Account Management", "Business Development", "Marketing Strategy", "Sales Management", "Corporate Communications", "Business Operations", "Business Strategy", "Sales Strategy", "Business Process", "Sales Support")
  output$SalaryHelper <- renderPlot({
    ifelse(input$mode_chosen == 'Top 10 Skills', 
           skills_df <- skills %>%
             filter(Skill != "Job Descriptions") %>%
             filter(Skill != "equipment") %>%
             filter(Skill != "designed") %>%
             filter(Skill != "system"), 
           ifelse(input$mode_chosen == "Display chosen skill",            skills_df <- skills %>%
                    filter(Skill %in% unlist(input$skills_chosen))
                  ,
                  ifelse(input$mode_chosen == "Programming Skills",                   skills_df <- skills %>%
                           filter(Skill %in% unlist(programming_skills)),
                         skills_df <- skills %>%
                           filter(Skill %in% unlist(bd_skills)))
)
)
    
    if (input$mode_chosen == "Display chosen skill") {
      shiny::validate(
        need(input$skills_chosen, "Input a value first!")
      )
    }
    shiny::validate(
      need(input$mode_chosen, "Input a value first!")
    )
    ggplot(data=head(skills_df,10), aes(x=reorder(Skill, Count), y=Count)) + geom_bar(stat="identity") + geom_text(aes(label=Count), position=position_dodge(width=0.9), vjust=-0.25) + theme_classic() + xlab('Skills') + ylab('Count of Jobs that wants this skill')
    
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      "Most wanted skill", "Management: 5746 records", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$IndustryPlot <- renderPlot({
    shiny::validate(
      need(input$industry_chosen, "Input a value first!")
    )
    
    career_data <- latest_data %>% select(Company, `Job Category`, `Adjusted Salary`)
    
    career_data <- career_data %>% 
      rename(Company = Company, Category = `Job Category`, Salary = `Adjusted Salary`) %>%
      filter(Category %in% unlist(input$industry_chosen))
    
    ggplot(career_data, aes(x=Salary, y = reorder(Category, Salary, median, order = TRUE))) + geom_boxplot() + theme_classic() + ylab('Category') + xlab('Salary')
    
  })
  
  output$SalaryIndustryPlot <- renderPlot({
    shiny::validate(
      need(input$degree_chosen, "Input a value first!")
    )
    
    shiny::validate(
      need(input$school_chosen, "Input a value first!")
    )
    
    df <- data.frame(ges_data)
    df$gross_monthly_mean <- as.numeric(as.character(df$gross_monthly_mean))
    df$gross_monthly_median <- as.numeric(as.character(df$gross_monthly_median))
    
    remove_na_df <- na.omit(df) 
    remove_na_df
    
    ges_mutated <- subset(remove_na_df[,c('year', 'university', 'degree', 'gross_monthly_mean', 'gross_monthly_median')])  %>%
      group_by(degree, university) %>%
      summarise_at(.vars = vars(gross_monthly_mean, gross_monthly_median),
                   .funs = c(mean="mean"))
    
    ges_mutated <- data.frame(ges_mutated)
    
    chosen_degree = subset(ges_mutated, ges_mutated$degree == input$degree_chosen & ges_mutated$university == input$school_chosen)
    
    new_df <- subset(ges_mutated[,c('university', 'gross_monthly_mean_mean', 'gross_monthly_median_mean')]) %>% 
      group_by(university) %>%
      summarise_at(.vars = vars(gross_monthly_mean_mean, gross_monthly_median_mean),
                   .funs = c(mean="mean"))
    
    new_df <- data.frame(new_df)
    
    new_df <- new_df %>%
      add_row(university = "Chosen Degree", gross_monthly_mean_mean_mean = chosen_degree$gross_monthly_mean_mean, gross_monthly_median_mean_mean = chosen_degree$gross_monthly_mean_mean)
    
    new_df$university <- ifelse(new_df$university == "Singapore Management University", "SMU", 
                                ifelse(new_df$university == "Singapore Institute of Technology", "SIT",
                                       ifelse(new_df$university == "Singapore University of Social Sciences", "SUSS",
                                              ifelse(new_df$university == "Singapore University of Technology and Design", "SUTD",
                                                     ifelse(new_df$university == "National University of Singapore", "NUS",
                                                            ifelse(new_df$university == "Nanyang Technological University", "NTU", "Chosen Degree"))))))

    new_df$gross_monthly_mean_mean_mean <- as.numeric(as.character(new_df$gross_monthly_mean_mean_mean))
    new_df$gross_monthly_median_mean_mean <- as.numeric(as.character(new_df$gross_monthly_median_mean_mean))
    
    check_sum <- subset(new_df, new_df$university == 'Chosen Degree')
    ggplot(new_df, aes(y=gross_monthly_median_mean_mean, x=reorder(university, gross_monthly_median_mean_mean), fill=university))+scale_fill_brewer(palette = "BrBG")+ geom_bar(stat="identity") + xlab('Universities vs Chosen Degree') + ylab('Gross Median Monthly Salary in $') + theme_classic() + guides(fill=guide_legend(title='Universities vs Chosen Degree')) + labs(title = "University Monthly Median Salary vs Chosen Degree Average Monthly Median Salary",
                                                                                                                                                                                                                                                                                                                                             caption = "Data Source: Data.gov.sg") + theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$LeafletJobsMap <- renderLeaflet({
    
    shiny::validate(
      need(input$industry_chosen_2, "Input a value first!")
    )
    
    career_loc <- latest_data %>% 
      select(Company, `Job Category`, Lat, Lng) %>%
      filter(`Job Category` %in% unlist(input$industry_chosen_2))
      
    
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(data =career_loc , lng = ~Lng , lat = ~Lat , radius = 5 , clusterOptions = markerClusterOptions())
    
  })
  
  output$approvalBox3 <- renderValueBox({
    valueBox(
      "Area with the most jobs", "Downtown: 10390 jobs", icon = icon("map"),
      color = "green"
    )
  })
  
  output$JobMonthsLine <- renderPlotly({
    
    shiny::validate(
      need(input$industry_chosen_4, "Input a value first!")
    )
    
    
    df5 <- latest_data %>% select(Company, `Job Category`,`Created At`) %>%
      dplyr::rename(company = Company, category = `Job Category`,created = `Created At`)
    as.Date(df5$created, format = "%Y%m/%d")
    df5$created2 <- as.Date(as.POSIXct(df5$created,format='%Y/%m/%d %H:%M:%S'),format='%m/%d/%Y')
    
    df_by_date <- df5 %>% group_by(created2, category) %>% summarise(added_today = n()) %>%
      ungroup()  %>% group_by(category) %>% mutate(total_number_of_content = cumsum(added_today)) %>%
      filter(category %in% unlist(input$industry_chosen_4))
    
    
    
    
    p <- plot_ly(df_by_date, x = ~created2) %>%
      add_lines(y = ~added_today, name = "Job") %>%
      layout(
        title = "Jobs",
        xaxis = list(
          rangeselector = list(
            buttons = list(
              list(
                count = 3,
                label = "3 mo",
                step = "month",
                stepmode = "backward"),
              list(
                count = 6,
                label = "6 mo",
                step = "month",
                stepmode = "backward"),
              list(
                count = 1,
                label = "1 yr",
                step = "year",
                stepmode = "backward"),
              list(
                count = 1,
                label = "YTD",
                step = "year",
                stepmode = "todate"),
              list(step = "all"))),

          rangeslider = list(type = "date")),

        yaxis = list(title = "count"))
    p

  })
  
  


  output$approvalBox4 <- renderValueBox({
    valueBox(
      "Month with the most jobs", "March 2021: 14702 jobs", icon = icon("calendar"),
      color = "blue"
    )
  })
  
  output$IndustryPlot_MCF <- renderPlot({
    shiny::validate(
      need(input$industry_chosen_3, "Input a value first!")
    )
    
    career_data <- latest_data %>% select(Company, `Job Category`, `Adjusted Salary`)
    
    career_data <- career_data %>% 
      rename(Company = Company, Category = `Job Category`, Salary = `Adjusted Salary`) %>%
      filter(Category %in% unlist(input$industry_chosen_3))
    
    ggplot(career_data, aes(x=Salary, y = reorder(Category, Salary, median, order = TRUE))) + geom_boxplot() + theme_classic() + ylab('Category') + xlab('Salary') + ggtitle("MyCareersFuture Dataset")
    
  })
  
  output$IndustryPlot_Glints <- renderPlot({
    shiny::validate(
      need(input$industry_chosen_3, "Input a value first!")
    )
    
    career_data <- glints_dataset %>% select(Company, `Job Category`, `Adjusted Salary`)
    
    career_data <- career_data %>% 
      rename(Company = Company, Category = `Job Category`, Salary = `Adjusted Salary`) %>%
      filter(Category %in% unlist(input$industry_chosen_3))
    
    ggplot(career_data, aes(x=Salary, y = reorder(Category, Salary, median, order = TRUE))) + geom_boxplot() + theme_classic() + ylab('Category') + xlab('Salary') + ggtitle("Glints Dataset")
    
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
      slice(0:15)
    
    (by_coy)
    
    by_coy$shortCoy = str_wrap(by_coy$Company, width = 15)
    
    by_coy2 = head(by_coy, input$CompaniesShow)
    
    
    ggplot(data=by_coy2, aes(x=(reorder(shortCoy,-n)), y=n)) +
      geom_bar(stat="identity", aes(fill = as.factor(n)),show.legend = FALSE)+
      theme_classic()+
      scale_fill_brewer(palette = "BrBG")+
      labs(x = "Company", y = "Counts") + 
      ggtitle("Top Companies with Most Jobs") + 
      theme(axis.title.x = element_text(size = 15),
            axis.title.y = element_text(size = 15),
            plot.title = element_text(size = 15, hjust = 0.5),
            axis.text.x = element_text(size = 15))
    
  })
  output$approvalBox5 <- renderValueBox({
    valueBox(
      "Top Company", "A*STAR RESEARCH ENTITIES", icon = icon("job"),
      color = "green"
    )
  })
  
  output$DatasetPlot <- DT::renderDataTable({
    DT::datatable(data=latest_data)
  })
  
  output$DatasetPlot2 <- DT::renderDataTable({
    DT::datatable(data=skills)
  })

}

shinyApp(ui, server)