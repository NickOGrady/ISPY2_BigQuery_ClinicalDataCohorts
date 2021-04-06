# App that has check boxes for arm and other criteria
# displays patients in table
# Can download data
# App authorizes use through email


# Required libraries
library(bigrquery)

server <- function(input, output) {
  
  # Input Checks ------------------------------------------------------------
  output$sqlresults =renderTable({
    if (length(input$boxgroup1)<1) {
      paste0("Please select desired data") }
    else if (length(input$boxgroup2)<1) {
      paste0("Please select subset features") }
    else if (length(input$boxgroup3)<1) {
      paste0("Please select arm")}
    # Everything else is for code after selection
    else {
      paste0("")
      df = globdata()
      df[1:15,]
    }
  })
  
  # If inputs acceptable
  # Display number of search results
  output$checkresults = renderText({
    if (all(c(length(input$boxgroup1)>=1,length(input$boxgroup2)>=1, length(input$boxgroup3)>=1))) {
      
      paste0("Search resulted in ", nrow(globdata()), " rows. Displaying top 15. Download for full results")
    }
  })
  
  # Download button, data from globdata()
  output$downloadData <- downloadHandler(
    filename = function(){"myfile.csv"},
    content = function(file) { write.csv(globdata(), file, 
                                         row.names = FALSE)})
  
  # Function for building results table
  globdata = reactive({
    
    # User needs to enter project name
    project = "<<Google Cloud Project ID>>"
    
    
    # BigQuery select statement
    mylist3 = input$boxgroup1
    selectwhat = ""
    if (length(mylist3) < 1){
      selectwhat = "PID"
    } else {
      for (i in 1:length(mylist3)) {
        if (i != length(mylist3)){
          selectwhat = paste0(selectwhat, mylist3[i], ", ")
        }else {
          selectwhat = paste0(selectwhat, mylist3[i])
        }
      }
    }
    # User will need to enter clinical data table
    mysql = paste0("SELECT ", selectwhat, " FROM `<<project_name.clinical_data_table>>` WHERE ")
    
    # Add subset features
    # Update needed here to handle if same subset is checked
    # e.g. Change from HR=0 AND HR=1 to HR in (0,1)
    mylist = input$boxgroup2
    addthis <- ""
    for (i in 1:length(mylist)) {
      
      addthis <- paste0(addthis, mylist[i])
      if (i != length(mylist)) {
        addthis <- paste0(addthis, " AND ")
      }
    }
    
    # Add Arm data
    mylist2 = input$boxgroup3
    addthis2 <- ""
    for (i in 1:length(mylist2)) {
      addthis2 <- paste0(addthis2, mylist2[i])
      if (i != length(mylist2)) {
        addthis2 <- paste0(addthis2, ", ")
      }
    }
    addthis2 <- paste0(" AND ARM IN (", addthis2, ")")
    
    # Combine parts into one BigQuery SQl search
    sql = paste0(mysql, addthis, addthis2)
    tb = bq_project_query(project, sql)
    df = bq_table_download(tb)
    if (nrow(df) < 1) {
      paste0("Query returned no results.  Please try new criteria")
    } else {
      return(df)
    }
  }) # End Globdata Reactive
  
} # End Server
