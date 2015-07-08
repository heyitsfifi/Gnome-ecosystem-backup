output <- merge(people,peoplePerRepo_patched,by.x='people',by.y='id');
write.csv(file="people.csv", x=output)

names(output)[names(output)=='people'] <- 'people_id';
names(output)[names(output)=='repositoryCommitter'] <- 'repoCommitter';
names(output)[names(output)=='repositoryAuthor'] <- 'repoAuthors';
names(output)[names(output)=='repository_id'] <- 'commonRepo';
