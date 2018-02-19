library(methods);
library(igraph);
require(qgraph);

# paste(inputfile, ".shared", sep="")

input <- function(inputfile) {

   pc <<- read.csv(paste(inputfile, ".csv", sep=""));
   pc2 <<- read.csv(paste(inputfile, ".abund.csv", sep=""));
   myclusters <<- read.csv(paste(inputfile, ".clusters.csv", sep=""));

}

run <- function() {
pc <<- pc[,-1] #Status is present
s <<- as.matrix(pc[,]);
s2 <<- as.matrix(pc[,]);
for (i in 1:nrow(s2)) {
   for (j in 1:ncol(s2)) {
      if (s2[i, j] < 0) {
         s2[i, j] <- 0;
      }
   }
}
#s <- matrix(runif(100, -1.0, 1.0), 10, 10);
#s.diag = diag(s);
#s[lower.tri(s,diag=T)] = 0
#s = s + t(s) + diag(s.diag)
g2 <<- graph.adjacency(s, mode="undirected", weighted=TRUE);
g3 <<- graph.adjacency(s2, mode="undirected", weighted=TRUE);
#adj <- matrix(sample(0:1,10^2,TRUE,prob=c(0.8,0.2)),nrow=10,ncol=10);
node.shapes <<- "circle"
node.names <<- colnames(pc);

#Now we print the graph
#mcl.data has all the correlations
pc2 <<- pc2[,-1];
xn <- as.matrix(pc2[,]);
#xm <- mcl.data
xc <- colSums(xn[,]);

### Node Sizes
xcfix <- xc;
minxcfix <- min(xc[which(xc>0)]);
xcfix[which(xc==0)] <- minxcfix;

scale <- ceiling(max(xcfix)/min(xcfix));
if (max(xcfix) %% min(xcfix) == 0) {
        node.size <<- log10(10^(nchar(scale)-1)*xcfix);
} else {
        node.size <<- log10(10^(nchar(scale))*xcfix);
}
node.size <<- 1.3*node.size;

# Node Colors
myclusters <<- myclusters[,-1]
cluster <- 1
clustervals <- numeric(length(node.names));
for (row in 1:length(myclusters)) {
  if (myclusters[row] == "x") {
     cluster <- cluster + 1;
  }
  else {
     clustervals[which(node.names == myclusters[row])] <- cluster;
  }
};

colors <- character(20);
colors[1] <- 'white';
colors[2] <- 'red';
colors[3] <- 'orange';
colors[4] <- 'yellow';
colors[5] <- 'green';
colors[6] <- 'green';
colors[7] <- 'magenta';
colors[8] <- 'pink';
colors[9] <- 'grey';
colors[10] <- 'cyan';
colors[11] <- 'lightcoral';
colors[12] <- 'lightsteelblue';
colors[13] <- 'indianred';
colors[14] <- 'lightgoldenrod';
colors[15] <- 'peru';
colors[16] <- 'mediumaquamarine';
colors[17] <- 'olivedrab';
colors[18] <- 'orchid';
colors[19] <- 'salmon';
colors[20] <- 'violet';
 
node.colors <<- character(length(clustervals));
for (row in 1:length(clustervals)) {
   node.colors[row] <<- colors[clustervals[row]+1];
}
}
output <- function(outputfile) {
png(file=outputfile, height=2160, width=3840, res = 300, pointsize = 7)
Q1 <- qgraph(s);
Q2 <- qgraph(s2);
#qgraph(Q1,
       #layout=layout.fruchterman.reingold(g2, start=layout.circle(g2), weights=((abs(E(g2)$weight))^5)*(20), coolexp=3, niter=500),
qgraph(Q2,
       layout=layout.fruchterman.reingold(g3, start=layout.circle(g3), weights=((abs(E(g3)$weight))^5)*(20), coolexp=3, niter=500),
       border.width=0.65,
       vsize=node.size,
       labels=node.names,
       shape=node.shapes,
       colors=node.colors,
       directed=FALSE,
       label.scale=FALSE,
       label.cex=1.2,
       label.position=5,
       legend=FALSE,
       legend.cex=0.4,
       diag=TRUE,
       ###Modify maximum, minimum, cut, and colFactor to tweak image display
       maximum=1,
       minimum=0.02,
       cut=.5,
       colFactor=.5,
       usePCH = T,
       mar=c(1,1,1,1));
}
