# QGraph
# Language: R
# Input: TXT 
# Output: prefix
# Tested with: PluMA 1.1, R 4.0.0

PluMA plugin to visualize networks using QGraph.  

The input takes the form of a TXT file of keyword-value pairs, tab-delimited:

correlations: Correlation network to visualize
abundances: Amount of each node in each sample (this determines node size)
clusters: Cluster CSV file
centralities: CSV file of centralities
spring: Apply spring method when determining node position (true or false)
fruchterman-reingold: Apply Fruchterman-Reingold method when determining node position (true or false)
centrality: Generate centrality graph (true or false)

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

Output files will be generated using the prefix:
prefix.pdf: Graph as a PDF
prefix.png: Graph as a PNG
prefix.FR.pdf: Graph after applying Fruchterman-Reingold, if it was marked true
prefix.centrality.pdf: Graph after coloring based on centrality, if it was marked true
