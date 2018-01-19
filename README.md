# QGraph
# Language: R
# Input: prefix (for CSV files for abundances, network and clusters, each of which affect visualization)
# Output: PNG

PluMA plugin to visualize networks using QGraph.  The plugin takes input in the form of a prefix,
which prefaces three data files: prefix.csv (the network), prefix.abund.csv (the abundance of each node),
and prefix.clusters.csv (the network clusters).

The network takes the form of a CSV file where rows and columns represent nodes and entry (i, j) 
represents the weight of the edge from node i to node j.

The abundances also take the form of a CSV file, where rows represent samples and columns represent nodes
in the network, and entry (i, j) holds the abundance of node j in sample i.

Finally, the clusters file takes the following format, with clusters separated by the line: "","x":

"","x"
"1","Family.Lachnospiraceae.0001"
"2","Family.Ruminococcaceae.0003"
"3","Family.Lachnospiraceae.0029"
"4","Family.Lachnospiraceae.0043"
"5","Family.Ruminococcaceae.0019"
"6","Family.Lachnospiraceae.0095"
"","x"
"1","Family.Porphyromonadaceae.0005"
"2","Family.Porphyromonadaceae.0006"
"3","Family.Lachnospiraceae.0045"
"4","Order.Clostridiales.0007"
"","x"
"1","Kingdom.Bacteria.0001"
"2","Family.Porphyromonadaceae.0013"
"3","Phylum.Firmicutes.0004"
"4","Family.Porphyromonadaceae.0024"

The QGraph plugin produces its output graph in .png format and uses the Fruchterman-Reingold algorithm
(Fruchterman and Reingold, 1991) for visualization.  It also colors nodes by cluster and uses size to
indicate abundance (larger nodes mean higher abundances).  A green edge indicates a positive edge weight
and a red edge indicates a negative edge weight, with edge thickness denoting magnitude (thicker=higher,
in both directions).
