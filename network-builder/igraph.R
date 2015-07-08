#install the igraph package
install.packages("igraph")

#load the package
library(igraph)
library(Matrix)

# read the csv file 
ppl <- read.csv("people.csv", header=TRUE)

# use a subset for demo purpose
ppl <- ppl[c("people", "repository_id")]

#build edgelist
A <- spMatrix(nrow = length(unique(ppl$people)),
              ncol = length(unique(ppl$repository_id)),
              i = as.numeric(factor(ppl$people)),
              j = as.numeric(factor(ppl$repository_id)),
              x = rep(1, length(as.numeric(ppl$people))) )
row.names(A) <- levels(factor(ppl$people))
colnames(A) <- levels(factor(ppl$repository_id))
adj <- tcrossprod(A) 
g <- graph.adjacency(adj, mode = "undirected", weighted = TRUE, diag = FALSE)

#write to pajek file
write.graph(g, "pajNet.net", format = "pajek")

# build edgelist and graph from it

l <- lapply(split(ppl$people, ppl$repository_id), function(x) { browser(); t(combn(x, 2)) })
l <- l[sapply(l, length) > 0]
d <- do.call(rbind, lapply(seq(l), function(x) transform(setNames(as.data.frame(l[[x]]), c("Source", "Target")), label = names(l)[x] ) ))
g <- graph.data.frame(d, directed = F)

# aggregate -- see comments
tmp <- factor(apply(d[, c("Source", "Target")], 1, function(x) paste(sort(x), collapse = "-")  ))
d$weight <- ave(1:nrow(d), tmp, FUN = length)
d <- d[!duplicated(tmp), c("Source", "Target", "weight")]




# plot demo subset
plot(g, edge.curved = TRUE, edge.arrow.size = .25, edge.width = E(g)$weight)


#no duplicate values
com[!duplicated(com$people_id), ]


#Transform the com table into required graph format
com.network <- graph.data.frame(com, directed= F)

#Inspect the data:
#count the vertices
vcount(com.network)
