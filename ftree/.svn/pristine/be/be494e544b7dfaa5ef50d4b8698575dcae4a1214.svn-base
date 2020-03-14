etree2html<-function(DF,SVGwidth=1000,SVGheight=500,SVGleft_margin=100,SVGright_margin=250,dir="", write_file=FALSE){			
	if(!etree.test(DF)) stop("first argument must be an event tree")		
			
	html_string<-paste0(		
		HTMLhead	,
		SVGwidth	,
		HTMLheight	,
		SVGheight	,
		HTMLmargin_right	,
		SVGright_margin	,
		HTMLmargin_left	,
		paste0('.attr("transform","translate(',SVGleft_margin,',0)"); ')	,
		HTMLjson	,
		etree2json(DF,c(3,4,6,7,8))	,
		HTMLd3script	
	)		 
			
			
	if(write_file==TRUE)  {				
		DFname<-paste(deparse(substitute(DF)))			
					
		file_name<-paste0(dir,DFname,".html")			
					
		eval(parse(text=paste0('write(html_string,"',file_name,'")')))			
					
	}		
						
html_string			
}			

############################ HTML strings #####################################

HTMLhead<-'<!doctype html></html>
<meta charset="utf-8" />
<style>
.node circle {     
  fill: #fff;    
  stroke: steelblue;    
  stroke-width: 1.5px; 
} 
.node {    
  font: 20px sans-serif; 
} 
.link {    
  fill: none;    
  stroke: #ccc;    
  stroke-width: 1.5px; 
}
</style> 
<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
<script type="text/javascript"> 
var width = '

HTMLheight<-'; 
var height = 
'

HTMLmargin_right<-'; 
var cluster = d3.layout.cluster()    
   .size([height, width-
   '

HTMLmargin_left<-'
]); 
var diagonal = d3.svg.diagonal()    
   .projection (function(d) { return [d.y, d.x];}); 
var svg = d3.select("body").append("svg")    
   .attr("width",width)    
   .attr("height",height)    
   .append("g")    
'

HTMLjson<-'
var root=
'

HTMLd3script<-'
;
  var nodes = cluster.nodes(root);    
   var links = cluster.links(nodes);    
   var link = svg.selectAll(".link")       
      .data(links)       
      .enter().append("path")       
      .attr("class","link")       
      .attr("d", diagonal);     
   var node = svg.selectAll(".node")       
      .data(nodes)       
      .enter().append("g")       
      .attr("class","node")       
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });    
   node.append("circle")       
      .attr("r", 4.5);    
   node.append("text")       
      .attr("dx", function(d) { return d.children ? 0 : 5; })       
      .attr("dy", function(d) {return d.type=="control" ? -30: -15; })       
      .style("text-anchor", function(d) { return d.children ? "middle" : "middle"; })      
      .text( function(d){ return d.name;}); 
   node.append("text")       
      .attr("dx", function(d) { return d.children ? 0 : 5; })       
      .attr("dy", function(d) {return d.type=="control" ? -10: 0; })       
      .style("text-anchor", function(d) { return d.children ? "middle" : "middle"; })  
      .style("font-size", 14 )
      .style( "fill", "green" )	  
      .text( function(d){ return d.type=="control" ? "Success="+d.prob: "";}); 
   node.append("text")       
      .attr("dx", function(d) { return d.children ? 0 : 10; })       
      .attr("dy", function(d) {return d.type=="outcome" ? 5: 0; })       
      .style("text-anchor", function(d) { return d.children ? "middle" : "right"; })  
      .style("font-size", 14 )
      .style( "fill", "blue" )	  
      .text( function(d){ return d.type=="outcome" ? "P="+d.freq.toPrecision(4): "";}); 
   node.append("text")       
      .attr("dx", function(d) { return d.children ? 0 : 10; })       
      .attr("dy", function(d) {return d.type=="outcome" ? 20: 0; })       
      .style("text-anchor", function(d) { return d.children ? "middle" : "right"; })  
      .style("font-size", 14 )
      .style( "fill", "purple" )	  
      .text( function(d){ return d.type=="outcome" ? "Severity="+d.severity: "";}); 	  

</script>
'