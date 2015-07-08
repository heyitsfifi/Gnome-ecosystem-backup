library(ggplot2)
library(RMySQL)
username <- readline(prompt= "Please enter your user name: ")
pass <- readline(prompt= "Please enter your password: ")
db <- readline(prompt= "Please enter your database name: ")
gnome = dbConnect(MySQL(), user=username, password=pass, dbname=db, host='localhost')

repeat{
  option <- readline(prompt="Select from following options:
  0: Generate csv file\n
  1: Number of committers\n
  2: Number of authors\n
  3: Number of repo each person commits to\n
  4: Number of repo: authored commits to\n
  5: Exit ")
  
  
  print(option)
  
  if(option==0) {
    overviewCommitters = dbGetQuery(gnome, "select people_merged.id as 'people',count(scmlog.id) as 'committers', count(distinct scmlog.repository_id) as 'repositoryCommitter' 
                                    FROM people_merged 
    					              LEFT OUTER JOIN scmlog ON scmlog.committer_id = people_merged.id 
							              GROUP BY people_merged.id;")
    
    overviewAuthors = dbGetQuery(gnome,"select people_merged.id as 'people',count(scmlog.id) as 'authors', count(distinct scmlog.repository_id) as 'repositoryAuthor' 
                                 FROM people_merged
                          LEFT OUTER JOIN scmlog ON scmlog.author_id = people_merged.id
                          GROUP BY people_merged.id;")
    people <- merge(x=overviewCommitters, y=overviewAuthors)
    peoplePerRepo = dbGetQuery(gnome, "select distinct people_merged.id as 'people_id', scmlog.repository_id
from people_merged
left outer join identity_merging on people_merged.id = identity_merging.merged_id
left outer join people on identity_merging.merged_id = people.id
left outer join scmlog on people.id = scmlog.committer_id
group by people_merged.id, scmlog.repository_id;
")
    output <- merge(people,peoplePerRepo,by.x='people',by.y='people_id');
    write.csv(file="people.csv", x=output, na="0")
    
    
    
  }
  

  if(option== 1) {
    #fetch the number of times each person is the committer
    pCommitters = dbGetQuery(gnome, "SELECT people_merged.id as 'people',count(scmlog.id) as 'committers'
                             FROM people_merged 
  						              LEFT OUTER JOIN scmlog ON scmlog.committer_id = people_merged.id 
							              GROUP BY people_merged.id;")
    
    #plot histogram for Number of times each person is the committer
    pCommitsHist <- ggplot(pCommitters, aes(committers)) + geom_histogram() + ylab("Frequency") +ggtitle("No. Of people as committers")
    ggsave("pCommitterHistogram.png")
    
    
    #plot boxplot for number of times each person is the committer
    #boxplot with continuous x
    pCommitsBox <- ggplot(pCommitters, aes(people,committers)) + geom_boxplot() + ylab("Number of people")+ ggtitle("No. Of people as committers")
    ggsave("pCommitterBoxPlot.png")
  }
  if(option==2){
    #fetch the number of times each person is the author
    pAuthors = dbGetQuery(gnome,"SELECT  people_merged.id as 'people',count(scmlog.id) as 'authors'
                          FROM people_merged
                          LEFT OUTER JOIN scmlog ON scmlog.author_id = people_merged.id
                          GROUP BY people_merged.id;")
    
    #plot histogram for the number of times each person is the author
    pAuthorsHist <- ggplot(pAuthors, aes(authors)) + geom_histogram() + ylab("Frequency") +ggtitle("No. Of people as authors")
    ggsave("pAuthorsHistogram.png")
    
    #plot boxplot for the number of times each person is the author
    pAuthorsBox <- ggplot(pAuthors, aes(people, authors)) + geom_boxplot() + ylab("Number of authors") +ggtitle("No. Of people as authors")
    ggsave("pAuthorsBoxPlot.png")
  }
  if(option==3) {
    #fetch number of different repositories each person has committed to
    pRepoOfCommitters = dbGetQuery(gnome, "select people_merged.id as 'people',count(distinct scmlog.repository_id) as 'repository'
                                   from people_merged
                                   left outer join scmlog ON scmlog.committer_id = people_merged.id 
  							GROUP BY people_merged.id;")
    #plot histogram for the  number of different repositories each person has committed to
    pRepoCommitHist <- ggplot(pRepoOfCommitters, aes(repository)) + geom_histogram() + ylab("Frequency") +ggtitle("No. Of different repos per committer")
    ggsave("pRepoCommitterHist.png")
    
    #plot boxplot for the number of different repositories each person has committed to
    pRepoCommitBox <- ggplot(pRepoOfCommitters, aes(people, repository)) + geom_boxplot() + ylab("Number of repository") +ggtitle("No. Of different repos per committer")
    ggsave("pRepoCommitterBoxPlot.png")
    
    
  }
  if(option==4) {
    
    #fetch number of different repositories each person has authored commits to
    pRepoOfAuthors = dbGetQuery(gnome, "select people_merged.id as 'people' ,count(distinct scmlog.repository_id) as 'repository'
                                   from people_merged
                                   left outer join scmlog ON scmlog.author_id = people_merged.id
  							GROUP BY people_merged.id;")
    
    #plot histogram for the number of different repositories each person has authored commits to
    pRepoAuthorHist <- ggplot(pRepoOfAuthors, aes(repository)) + geom_histogram() + ylab("Frequency") +ggtitle("No. Of different repos per authors")
    ggsave("pRepoAuthorHist.png")
    
    #plot boxplot for the number of different repositories each person has authored commits to
    pRepoAuthorBox <- ggplot(pRepoOfAuthors, aes(people, repository)) + geom_boxplot() + ylab("Number of repository") +ggtitle("No. Of different repos per author")
    ggsave("pRepoAuthorBoxPlot.png")
    
  }
  if(option==5) {
    
    
    break; }
  
}
