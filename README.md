# Y-graph: A max-ascent-angle graph for detecting clusters

which is published in IEEE Transactions on Transactions on Knowledge and Data Engineering（TKDE）, 2024.


Abstract: Graph clustering technique is highly effective in detecting complex-shaped clusters, in which graph building is a crucial step.
Nevertheless, building a reasonable graph that can exhibit high connectivity within clusters and low connectivity across clusters is
challenging. Herein, we design a max-ascent-angle graph called the ”Y-graph”, a high-sparse graph that automatically allocates dense
edges within clusters and sparse edges across clusters, regardless of their shapes or dimensionality. In the graph, every point x is
allowed to connect its nearest higher-density neighbor δ, and another higher-density neighbor γ, satisfying that the angle ∠δxγ is the
largest, called ”max-ascent-angle”. By seeking the max-ascent-angle, points are automatically connected as the Y-graph, which is a
reasonable graph that can effectively balance inter-cluster connectivity and intra-cluster non-connectivity. Besides, an edge weight
function is designed to capture the similarity of the neighbor probability distribution, which effectively represents the density
connectivity between points. By employing the Normalized-Cut (Ncut) technique, a Ncut-Y algorithm is proposed. Benefiting from the
excellent performance of Y-graph, Ncut-Y can fast seek and cut the edges located in the low-density boundaries between clusters,
thereby, capturing clusters effectively. Experimental results on both synthetic and real datasets demonstrate the effectiveness of
Y-graph and Ncut-Y
