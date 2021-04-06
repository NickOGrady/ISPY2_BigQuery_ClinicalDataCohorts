# App that has check boxes for arm and other criteria
# displays patients in table
# Can download data
# App authorizes use through email

# Required Libraries
library(shiny)
library(shinyWidgets)

# Setting human readable on left
# BigQuery Column variables on right
myview = c("PID" = "'<<Study_ID column name from  BQ table>>'",
           "HER2" = "'<<HER2 column name from  BQ table>>'",
           "HR" = "<<Hormone_Receptor column name from BQ Table>>")

# Human readable on left,
# BigQuery SQL on right
# Leaving this variables as is, for example
# User will need to update for specific variables
mysubset =  c("HER2+" = "HER2 = '1'", 
              "HER2-" = "HER2 = '0'",
              "HR+" = "HR = '1'", 
              "HR-" = "HR = '0'", 
              "MP 1" = "MP = '1'", 
              "MP 0" = "MP = '0'", 
              "PCR 1" = "Admin_PCR = '1'", 
              "PCR 0" = "Admin_PCR = '0'", 
              "RCB 1" = "RCB_Class = 'I'", 
              "RCB 2" = "RCB_Class = 'II'", 
              "RCB 3" = "RCB_Class = 'III'")

# Drug Arm
myarm = c("DRUG_A" = "'<<Drug_A column name from  BQ table>>'",
          "DRUG_B" = "'<<Drug_B column name from BQ Table>>'",
          "DRUG_C" = "'<<Drug_C coumna name from BQ Table>>'")

# User Interface
ui <- fluidPage(
  
  titlePanel("Subset Lookup"),
  
  sidebarLayout(
    sidebarPanel(
      
      # User data to view
      pickerInput(
        inputId = "boxgroup1", 
        label = "What do you want to see?", 
        choices = myview, 
        options = list(
          `actions-box` = TRUE, 
          size = 10,
          `selected-text-format` = "count > 5"
        ), multiple = TRUE),
      
      # User defined subset          
      pickerInput(
        inputId = "boxgroup2", 
        label = "Select subset criteria", 
        choices = mysubset, 
        options = list(
          `actions-box` = TRUE, 
          size = 10,
          `selected-text-format` = "count > 5"
        ), multiple = TRUE), 
      
      # User defined arms
      pickerInput(
        inputId = "boxgroup3", 
        label = "Select desired arms", 
        choices = myarm, 
        options = list(
          `actions-box` = TRUE, 
          size = 10,
          `selected-text-format` = "count > 5"
        ), multiple = TRUE), 
      
      # Submit button
      # Displays number of results
      submitButton("Submit"), 
      downloadButton("downloadData", label =  "Download Data"),
      textOutput("checkresults")
    ),
    
    mainPanel( HTML(paste(h3("Query Results:"))),
               textOutput(outputId = "graphText"),
               tableOutput(outputId = "sqlresults"))
    
    
  ) # End sidebar layout
  
  
) # End UI fluid page
