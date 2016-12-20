ftree2html<-function(DF,dir="", write_file=FALSE){
	if(!ftree.test(DF)) stop("first argument must be a fault tree")

	html_string<-paste0(
		HTMLhead,
		##ftree2json(DF,c(1,2,4:7,15,17,18))	,
		##hierarchyDF2json(DF,id.col=1,parent.col=3,data.col=c(1,2,4:7,15,17,18)),
##		hierarchyDF2json(DF,data.col=c(1,5:16)),
## eliminating repairable data attribute will result in:
		hierarchyDF2json(DF,data.col=c(1,5:11,13:16)),
		HTMLd3script
	)


	if(write_file==TRUE)  {
		DFname<-paste(deparse(substitute(DF)))

		file_name<-paste0(dir,DFname,".html")

		eval(parse(text=paste0('write(html_string,"',file_name,'")')))

	}

outDF<-ftree2table(DF)
outDF 

}

############################ HTML strings #####################################

HTMLhead<-'<!DOCTYPE html>
<meta charset="utf-8">
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<div id="body"></div>
<style>
.node {cursor: pointer;}
.node text {font: 10px sans-serif;font-weight: bold;}
.link {fill: none;stroke: #ccc;stroke-width: 1.5px;}
</style>
<script>
width = 960,height = 800;
var root =
'

HTMLd3script<-'
;
var duration = 750,rectW = 124,rectH = 90,TrectH = 24;
var tree = d3.layout.tree()
.nodeSize([rectW*1.15, rectH*1.2])
.separation(function(a, b) { return (a.parent == b.parent ? 1 : 1.2); });
var svg = d3.select("#body").append("svg").attr("width", 1000).attr("height", 1000)
.call(zm = d3.behavior.zoom().scaleExtent([.5,3]).on("zoom", redraw)).append("g")
.attr("transform", "translate(" + 350 + "," + 20 + ")");
zm.translate([350, 20]);
root.x0 = 0;
root.y0 = height / 2;
function collapse(d) {
if (d.children) {
d._children = d.children;
d._children.forEach(collapse);
d.children = null;}}
update(root);
d3.select("#body").style("height", "800px");
function update(source) {
var nodes = tree.nodes(root)
links = tree.links(nodes);
var node = svg.selectAll("g.node")
.data(nodes, function (d) {
return d.id || (d.id = ++i);});
var nodeEnter = node.enter().append("g")
.attr("class", "node")
.attr("transform", function (d) {
return "translate(" + source.x0 + "," + source.y0 + ")";})
.on("click", click);
nodeEnter.append("rect")
.attr("width", rectW)
.attr("height", TrectH)
.attr("stroke", function (d) {
return d._children ? "blue" : "black";})
.attr("stroke-width", 1)
.style("fill", function (d) {
return d._children ? "lightcyan" : "#fff";});
nodeEnter.append("text")
.attr("x", rectW/2)
.attr("y", 10)
.attr("text-anchor", "middle")
.text(function (d) {
return d.name;});
nodeEnter.append("text")
.attr("x", rectW/2)
.attr("y", 17)
.attr("dy", ".35em")
.attr("text-anchor", "middle")
.text(function (d) {
return d.name2;});
var orGate="m 75,65 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z";
var andGate="m 45,50 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15";
var condGate="m 45,50 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 m 0,10 30,0";
//var condGate="m 45,50 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 m 0,15 15,-30 15,30";
var inhibitGate="m 60,35 -15,6.340 0,17.3205 15,6.340  15,-6.340 0,-17.3205 z";
var alarmGate="m 75,65 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z m -30,0 v5 c0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 v-5";
var component="m 75, 50 a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 a15,15 .2 0,0 15,15 a15,15 .2 0,0 15,-15";
nodeEnter.append("path")
.attr("d",
function(d) {switch (d.type) {
case 10 : return(orGate);
break;
case 11 : return(andGate);
break;
case 12 : return(inhibitGate);
break;
case 13 : return(alarmGate);
break;
case 14 : return(condGate);
break;
default : return(component);
}})
.attr({stroke:"black",
"stroke-width":1.5,
"stroke-linejoin":"round",
fill: "#fff"});
nodeEnter.append("text")
.attr("x", rectW / 2-2)
.attr("y", TrectH  + 25)
.attr("text-anchor", "middle")
.attr("fill",  function(d){return d.moe==0 ? "red": "magenta";})
//.attr("font", "12px")
//.attr("stroke", "white")
//.attr("stroke-width", ".5px")
.text(function (d) {
return d.moe>0 ? d.moe : d.id ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -56)
.attr("y", TrectH  -26)
.attr("text-anchor", "middle")
.attr("fill", "magenta")
.text(function (d) {
return d.moe > 0 ? "R" : d.moe<0 ? "S" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -28)
.attr("y", TrectH  -26)
.attr("text-anchor", "right")
.attr("fill", "navy")
.text(function (d) {
return d.condition > 0 ? "Cond" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 +44)
.attr("y", TrectH  -26)
.attr("text-anchor", "right")
.attr("fill",  function(d){return d.moe==0 ? "red": "magenta";})
.text(function (d) {
return d.tag_obj;});
nodeEnter.append("text")
.attr("x", rectW/2+18)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) { return d.cfr>0&&d.condition==0 ? "Fail Rate":"";});
.text(function (d) { return d.cfr>0 ? "Fail Rate":"";});
nodeEnter.append("text")
.attr("x", rectW/2+18)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) {return d.cfr>0&&d.condition==0 ? (d.cfr).toExponential(4):"";});
.text(function (d) {return d.cfr>0 ? (d.cfr).toExponential(4):"";});
nodeEnter.append("text")
.attr("x", rectW/2+18)
.attr("y", TrectH  + 36)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) { return d.pbf>0 ? "Prob":"";});
nodeEnter.append("text")
.attr("x", rectW/2+18)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) {return d.pbf>0 ? (d.pbf).toExponential(4):"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
//.attr("fill",  function(d){return d.condition==0 ? "lightgray": d.repairable==1 ? "dimgray": "white" ;})
.attr("fill",  function(d){return d.condition==1 ? "dimgray":"lightgray" ;})
.text(function (d) { return d.crt>0 ? "Repair Time":"";});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
//.attr("fill",  function(d){return d.condition==0 ? "lightgray": d.repairable==1 ? "dimgray": "white" ;})
.attr("fill",  function(d){return d.condition==1 ? "dimgray":"lightgray" ;})
.text(function (d) {return d.crt>0 ? (d.crt).toExponential(4):"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "black")
.text(function (d) { return d.type==13 ? "Phf="+parseFloat(d.phf_pz.toFixed(2)) :"";});
nodeEnter.append("text")
//.attr("x", rectW/2)
.attr("x", function(d) { return d.type==2 ? rectW/2 : rectW/2+10;})
.attr("y", TrectH  + 60)
.attr("text-anchor", function(d) { return d.type==2 ? "middle" : "left";})
.attr("fill", "maroon")
.text(function (d) {
	return d.type==2 ? "T="+parseFloat(d.interval.toFixed(4)) +" Po=" +parseFloat(d.phf_pz.toFixed(5))
	: d.type==5 ? "T="+parseFloat(d.interval.toFixed(4))
	:"";});
var nodeUpdate = node.transition()
.duration(duration)
.attr("transform", function (d) {
return "translate(" + d.x + "," + d.y + ")";});
nodeUpdate.select("rect")
.attr("width", rectW)
.attr("height", TrectH)
.attr("stroke", function (d) {
return d._children ? "blue" : "black";})
.attr("stroke-width", 1)
.style("fill", function (d) {
return d._children ? "lightcyan" : "#fff";});
nodeUpdate.select("text")
.style("fill-opacity", 1);
var nodeExit = node.exit().transition()
.duration(duration)
.attr("transform", function (d) {
return "translate(" + source.x + "," + source.y + ")";})
.remove();
nodeExit.select("rect")
.attr("width", rectW)
.attr("height", TrectH)
.attr("stroke", "black")
.attr("stroke-width", 1);
nodeExit.select("text");
var link = svg.selectAll("path.link")
.data(links, function (d) {
return d.target.id;});
link.enter().insert("path", "g")
.attr("class", "link")
.attr("x", rectW / 2)
.attr("y", rectH / 2)
.attr("d", function (d) {
var o = {
x: source.x0,
y: source.y0};
return elbow({
source: o,
target: o});});
link.transition()
.duration(duration)
.attr("d", elbow);
link.exit().transition()
.duration(duration)
.attr("d", function (d) {
var o = {
x: source.x,
y: source.y};
return elbow({
source: o,
target: o});})
.remove();
nodes.forEach(function (d) {
d.x0 = d.x;
d.y0 = d.y;});}
function click(d) {
if (d.children) {
d._children = d.children;
d.children = null;
} else {
d.children = d._children;
d._children = null;}
update(d);}
function redraw() {
svg.attr("transform",
"translate(" + d3.event.translate + ")"
+ " scale(" + d3.event.scale + ")");}
function elbow(d) {
var sourceY = d.source.y+TrectH,
sourceX = d.source.x+rectW/2-2,
targetY = d.target.y+TrectH+20,
targetX = d.target.x+rectW/2-2;
return "M" + sourceX + "," + sourceY
+ "V" + (sourceY+targetY)/2
+ "H" + targetX
+ "V" + targetY;}
</script>

'