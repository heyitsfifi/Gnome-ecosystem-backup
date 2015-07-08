library(RMySQL)
username <- readline(prompt= "Please enter your user name: ")
pass <- readline(prompt= "Please enter your password: ")
db <- readline(prompt= "Please enter your database name: ")
gnome = dbConnect(MySQL(), user=username, password=pass, dbname=db, host='localhost')


repeat{
  option <- readline(prompt="Select from following options:
  1: number of commits > third quartile\n
  2: number of committers >third\n
  3: number of authors >mean\n
  4: number of files > third
  5: repo of each person
  
                     ")
  
  print(option)
  
if(option==1){
  
  commitsAboveThird = dbGetQuery(gnome, "select r.id as 'repository'
from repositories r
left outer join scmlog s on s.repository_id = r.id
group by r.id
having count(distinct s.date) > 545;")
  
  write.csv(file="analysis.csv", x=commitsAboveThird)
  
  
}

if(option==2){
  committersAboveThird = dbGetQuery(gnome, "select r.id as 'repository'
from repositories r
left outer join scmlog s on s.repository_id = r.id
group by r.id
having count(distinct s.committer_id) > 52;")
  write.csv(file="secAnalysis.csv", x=committersAboveThird)
  
}
if(option==3){
  authorsAboveThird = dbGetQuery(gnome, "select r.id as 'repository'
from repositories r 
left outer join scmlog s on s.repository_id = r.id
group by r.id
having count(distinct s.author_id) > 63;")
  write.csv(file="thirdAnalysis.csv", x=authorsAboveThird)
  
}
if(option==4){
  filesAboveThird = dbGetQuery(gnome, "select r.id as 'repository'
from repositories r 
left outer join files f
on r.id = f.repository_id
group by r.id
having count(distinct f.file_name) >270;")
  write.csv(file="forthAnalysis.csv", x=filesAboveThird)
}
if(option==5){
  peoplePerRepo = dbGetQuery(gnome, "select distinct people_merged.id as 'people_id', scmlog.repository_id
from people_merged
left outer join identity_merging on people_merged.id = identity_merging.merged_id
left outer join people on identity_merging.merged_id = people.id
left outer join scmlog on people.id = scmlog.committer_id
group by people_merged.id, scmlog.repository_id;
")
   write.csv(file="peoplePerRepo.csv", x=peoplePerRepo)
}
}