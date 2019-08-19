library(methods);
library(igraph);
require(qgraph);
library(rlist);
# paste(inputfile, ".shared", sep="")

input <- function(inputfile) {
   parameters <<- read.table(inputfile, as.is=T);
   rownames(parameters) <<- parameters[,1]
   mcl.data <<- read.csv(toString(parameters["correlations", 2]), header=T);
   pc <<- read.csv(toString(parameters["abundances", 2]), header=T);
   
   pc <<- pc[,-1] #Status is present
   mcl.data <<- mcl.data[,-1]
  clusters <- read.csv(toString(parameters["clusters", 2]), header=FALSE);
  singlelist <<- clusters[,2]
  pos <- 0;
  mcl.listFull <<- list()
  for (i in 1:length(singlelist)) {
     if (is.na(clusters[,1][i])) {
        mcl.listFull <<- list.append(mcl.listFull, c());
        pos <- pos + 1;
     }
     else {
        mcl.listFull[[pos]] <<- append(mcl.listFull[[pos]], as.character(singlelist[[i]]));
     }
  }
   #myclusters <<- read.csv(paste(inputfile, ".clusters.csv", sep=""));
}

run <- function() {
print("RUN");
##################################################
# runBacteria starts here
#Now we print the graph
#mcl.data has all the correlations
xn <- as.matrix(pc[,]);
#print(xn);
#quit();
xm <<- mcl.data
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

if(toString(parameters["centrality", 2]) == "true"){
        cent_table <- read.table(toString(parameters["centralities", 2]), header=T);
        cent_opacities <- xn[1,]
        #print(sum(cent_opacities[1]))
        for(j in 1:nrow(cent_table)){
                cent_opacities[cent_table[j,1]]<-as.numeric(cent_table[j, 2])#as.numeric(levels(cent_table[[1]][j]))[cent_table[[1]][j]]
        }
        #Normalize opacities
        cent_opacities <- cent_opacities / sum(cent_opacities)#tot_opacities
        #Make opacities go from 0.05 - 1.0 (the maximum centrality will have opacity = 1)
        max_opac <- max(cent_opacities)
        cent_opacities <- cent_opacities * (0.95/max_opac)
        cent_opacities <- cent_opacities + 0.05
}
xnames <- colnames(xn)
xnames <- gsub("Phylum", "P", xnames)
xnames <- gsub("Class", "C", xnames)
xnames <- gsub("Order", "O", xnames)
xnames <- gsub("Family", "F", xnames)
names.front <- substr(xnames, 1, 5)
substrRight <- function(x, n){
substr(x, nchar(x)-n+1, nchar(x))
}
names.back <- substrRight(xnames, 2)
#node.names <- paste0(names.front, ".", names.back)
node.names <<- substr(xnames, 1, 7)
logt <- function(x) x^3
xm <<- sapply(xm, logt)
xm <<- matrix(xm, ncol=length(node.names))
colnames(xm) <<- node.names
rownames(xm) <<- node.names

node.shapes <<- "circle"

# Assign node colors and shapes
#node.shapes <<- c()
node.colors <<- c()
node.colors2 <<- c()
node_names_graph <- colnames(xn)
color_list <- rainbow(31)
for(j in 1:length(node_names_graph)){
        node.colors[j] <<- "#BBBBBBFF"
        #node.shapes[j] <- shape_list[10]
        for(k in 1:length(mcl.listFull)){
                if(length(which(mcl.listFull[[k]]==node_names_graph[j]))>0){
                        col_index <- ( ( k * 6 ) %% 31 ) + 1
                        node.colors[j] <<- color_list[col_index]
                }
        }
        if(toString(parameters["centrality", 2]) == "true"){
                node.colors2[j] <<- node.colors[j]
                sep_color <- col2rgb(node.colors2[j])
                node.colors2[j] <<- rgb(sep_color[1], sep_color[2], sep_color[3], cent_opacities[j]*255, maxColorValue=255)
        }
        #for(k in 1:length(mcl.list)){
                #if(length(which(mcl.list[[k]]==node_names_graph[j]))>0){
                        #node.shapes[j] <- shape_list[k]
                        #node.names[j] <- paste(k, "_", node.names[j])
                #} 
        #}
}
}


output <- function(outputfile) {
print("OUTPUT");
g2 <- graph.adjacency(xm, mode="undirected", weighted=TRUE)
if (toString(parameters["spring", 2]) == "true") {
pdf(file=paste(outputfile, "pdf", sep="."), height=2160, width=3840)
Q <- qgraph(xm)
qgraph(Q, layout="spring",
       border.width=0.65,
       vsize=node.size,
       labels=node.names,
       shape=node.shapes,
       color=node.colors,
       label.scale=FALSE,
       label.cex=1.2,
       label.position=5,
       legend=FALSE,
       legend.cex=0.4,
       diag=TRUE,
       ###Modify maximum, minimum, cut, and colFactor to tweak image display
       maximum=1,
       minimum=0.02,
       #minimum=0.1,
       cut=.5,
       colFactor=.5,
       #Green edges only
       #negCol="#FFFFFF00",
       #Green edges only
       #negCol="#FFFFFF00",
       #Red edges only
       #posCol="#FFFFFF00",
       #edge.width=0.2,
           usePCH = T,
       mar=c(1,1,1,1))
dev.off()
}

if (toString(parameters["fruchterman-reingold", 2]) == "true") {
pdf(file=paste(outputfile, "FR.pdf", sep="."), height=2160, width=3840)
Q <- qgraph(xm)
qgraph(Q,
           layout=layout.fruchterman.reingold(g2, start=layout.circle(g2), weights=((abs(E(g2)$weight))^5)*(20), coolexp=3, niter=500),
           #layout=layout.fruchterman.reingold(g2, start=layout.circle(g2), weights=((abs(E(g2)$weight)))*(40), coolexp=3, niter=500),
       #layout=layout.fruchterman.reingold(g2, start=layout.circle(g2), weights=((abs(E(g2)$weight))), coolexp=3, niter=500),
           border.width=0.65,
       vsize=node.size,
       labels=node.names,
       shape=node.shapes,
       color=node.colors,
       label.scale=FALSE,
       label.cex=1.2,
       label.position=5,
       legend=FALSE,
       legend.cex=0.4,
       legend=FALSE,
       legend.cex=0.4,
       diag=TRUE,
       ###Modify maximum, minimum, cut, and colFactor to tweak image display
       maximum=1,
       minimum=0.02,
       #minimum=0.1,
       cut=.5,
       colFactor=.5,
       #Green edges only
       #negCol="#FFFFFF00",
       #Red edges only
       #posCol="#FFFFFF00",
       #edge.width=0.2,
           usePCH = T,
       mar=c(1,1,1,1))
dev.off()
}

if (toString(parameters["centrality", 2]) == "true") {
pdf(file=paste(outputfile, "centrality.pdf", sep="."), height=2160, width=3840)
        Q <- qgraph(xm)
        qgraph(Q, layout="spring",
                   border.width=0.65,
                   vsize=node.size,
                   labels=node.names,
                   shape=node.shapes,
                   color=node.colors2,
                   label.scale=FALSE,
                   label.cex=1.2,
                   label.position=5,
                   legend=FALSE,
                   legend.cex=0.4,
                   diag=TRUE,
                   ###Modify maximum, minimum, cut, and colFactor to tweak image display
                   maximum=1,
                   minimum=0.02,
                   #minimum=0.1,
                   cut=.5,
                   colFactor=.5,
                   #Green edges only
                   #negCol="#FFFFFF00",
                   #Green edges only
                   #negCol="#FFFFFF00",
                   #Red edges only
                   #posCol="#FFFFFF00",
                   #edge.width=0.2,
                   usePCH = T,
                   mar=c(1,1,1,1))
        dev.off()
}

}
