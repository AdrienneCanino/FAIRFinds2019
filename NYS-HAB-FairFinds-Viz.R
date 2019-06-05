#This code is provided as example material for the presentation, Fair Finds, at LIbrary2.019 OpenData webconference. Presentation, code and visuals are by Adrienne Canino.
#The data for this example script were scraped from public PDFs of Harmful Algal Blooms, provided by New York State's Department of Environmental Conservation, in Spring of 2018.
#The goal of this R script is to visualize the dataset in several ways.

#First, read in the csv data from where you have saved your files. Check it out, somehow.
nysSUM <- read.csv("/Users/AdrienneC/Documents/tabula-extract-HAB-Summary.csv", header=TRUE)
head(nysSUM)
nysSUM$X2012
#Now, make the data tidy (reference: https://r4ds.had.co.nz/tidy-data.html )
install.packages('tidyverse')
library(tidyverse)
#Since the column names are not variables, but values, and the value is spread across these columns, I will 'gather' the data into tidy form.
?gather
NYShabs <- gather(data=nysSUM, key= "year", value = 'severity', c(3:8), na.rm=FALSE)
head(NYShabs)

#Try to create some summaries. For example, Every County in NYS has the waterbodies affected listed, with a severity ranking
?table
table(data= NYShabs$severity, row.names=NYShabs$County)
#It's not exactly clean, let's assume the first county only in water bodies that have multiple counties as their location, using a generic grepl expression I found that works for this. I will live with blanks.
?gsub
x <-as.character(NYShabs$County)
x
x2 <- gsub("(.*),.*", "\\1", x)
x <- as.factor(x2)
NYShabs$County <- x2
NYShabs$County <-as.factor(NYShabs$County)
head(NYShabs)

#Let's ddo a visualization, just to start let's compare counties.
#Sum for all years, by county
CountySum <- count(NYShabs, County)
CountySum

#Let's make a treemap of counties, sized largest for the most HABs, again the total for all 3 kinds.
library(treemapify)
ggplot(CountySum, aes(area=n, label=County))+geom_treemap()+geom_treemap_text()
