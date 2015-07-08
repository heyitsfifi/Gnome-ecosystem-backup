#
# This R function merges two tables and returns the resulting table in a new data frame.
# inputs
# 1. tbl1 loaded from a csv file.
# 2. tbl2 is output from an query containing people_id and repository_id
# There can be multiple repository ids associated to each people id
#
mergetbl <- function(tbl1, tbl2)
{
  # tbl1 -- from csv file
  # tbl2 -- from sql query
  # 1. create an empty data frame
  # 2. go through tbl1 row by row
  # 3. for each row in tbl1, look at the current people_id in tbl2 and extract all associated repository_id
  # 4. duplicate the same row in tbl1 the same number of times there are associated repository ids
  # 5. merge duplicate rows with the column repository ids
  # 6. merge duplicate rows into new data frame
  # 7. repeat from 2. until last row in tbl1
  newtbl = data.frame(people_id=numeric(),repoCommitted=numeric(),isAuthor=numeric(),repoAuthor=numeric(),commonRepo=numeric())
  
  ntbl1rows<-nrow(tbl1)
  tbl2patched<-tbl2[complete.cases(tbl2),]
  for(n in 1:ntbl1rows)
  {
    ndup<-nrow(tbl2patched[tbl2patched$people_id==tbl1$people[n],])
    duprow<- tbl1[rep(n,ndup),]
    newtbl<-rbind(newtbl,duprow)
    
    
  }
  # newtbl <-merge(newtbl, tbl2patched,by.x="row.names", by.y="people_id")
}

