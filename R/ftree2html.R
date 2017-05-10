ftree2html<-function(DF,dir="", write_file=FALSE){
	if(!test.ftree(DF)) stop("first argument must be a fault tree")
	

if(any(DF$Name!="")) {
	html_string<-paste0(
		HTMLhead,
		#hierarchyDF2json(DF,data.col=c(1,5:10,12:17)),
		hierarchyDF2json(DF,data.col=c(1:14,16:17)),
		';',
		HTMLd3script,
		'</script>'
	)
}else{
	html_string<-paste0(
		HTMLhead,
		#hierarchyDF2json(DF,data.col=c(1,5:10,12:17)),
		hierarchyDF2json(DF,data.col=c(1:15)),
		';',
		HTMLd3script2,
		'</script>'
	)
}

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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<style>
html{
  height: 100%;
}
body {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 5px;
}
</style>
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
var llim=1e-25;
var duration = 200,rectW = 124,rectH = 90,TrectH = 24;
var width_initial = $(window).width()/2-60;
var tree = d3.layout.tree()
.nodeSize([rectW*1.15, rectH*1.2])
.separation(function(a, b) { return (a.parent == b.parent ? 1 : 1.2); });
// the widget must select el, not "#body" as in html
var svg = d3.select("#body").append("svg").attr("width", "100%").attr("height", "100%")
.call(zm = d3.behavior.zoom().scaleExtent([0.05,5]).on("zoom", redraw)).append("g")
.attr("transform", "translate(" + width_initial + "," + 50 + ")");
zm.translate([width_initial, 20]);
root.x0 = 0;
root.y0 = height / 2;
var duration_backup = duration;
duration = 0;
//function collapse(d) {
//if (d.children) {
//d._children = d.children;
//d._children.forEach(collapse);
//d.children = null;}}
autocollapse(root);
duration = duration_backup;
update(root);
d3.select("#body").style("height", "100%");
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
nodeEnter.append("text")
.attr("x", rectW / 2 -144)
.attr("y", TrectH  +14)
.attr("text-anchor", "middle")
.attr("fill", "navy")
.text(function (d) {
return (d.tag=="top" && d.p2>0) ? "Mission Time" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -144)
.attr("y", TrectH  +26)
.attr("text-anchor", "middle")
.attr("fill", "navy")
.text(function (d) {
return (d.tag=="top" && d.p2>0) ? d.p2 : "" ;});
var orGate="m 75,65 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z";
var andGate="m 45,50 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15";
var priorityGate="m 45,50 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 m 0,10 30,0";
var inhibitGate="m 60,35 -15,6.340 0,17.3205 15,6.340  15,-6.340 0,-17.3205 z";
var alarmGate="m 75,65 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z m -30,0 v5 c0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 v-5";
var voteGate="m 75,65 c  -1.4,-10,.6,-22-15,-30  -15.6,8,-13.4,20,-15,30 m 0,0 0,10 30,0 0,-10 m-28,-7.5 27,0"; 
var house="m 45,50 0,15 30,0 0,-15 -15,-15  -15,15";
var undeveloped="m 60,35 m 0,0 l 24,15 l -24,15 l -24,-15 z";
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
case 14 : return(priorityGate);
break;
case 15 : return(voteGate);
break;
case 16 : return(voteGate);
break;
case 9 : return(house);
break;
case 6 : return(undeveloped);
break;
case 3 : return(undeveloped);
break;
default : return(component);
}})
.attr({stroke:"black",
"stroke-width":1,
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
.attr("x", rectW / 2-2)
.attr("y", TrectH  + 45)
.attr("text-anchor", "middle")
.attr("fill", "blue")
.text(function (d) {
return d.type>14 && d.p2>0 ? parseInt(d.p1)+" :"+parseInt(d.p2) : d.type==16 ? parseInt(d.p1)+" :" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -56)
.attr("y", TrectH  -26)
.attr("text-anchor", "middle")
.attr("fill", "magenta")
.text(function (d) {
return d.moe > 0 ? "R" : d.moe<0 ? "S" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -31)
.attr("y", TrectH  -26)
.attr("text-anchor", "right")
.attr("fill", "navy")
.text(function (d) {
return d.condition > 0 ? "Cond" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 +3)
.attr("y", TrectH  -26)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.moe==0 ? "red": "magenta";})
.text(function (d) {
return d.tag;});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) { return d.cfr>0&&d.condition==0 ? "Fail Rate":"";});
.text(function (d) { return d.cfr>0 ? "Fail Rate":"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) {return d.cfr>0&&d.condition==0 ? (d.cfr).toExponential(4):"";});
.text(function (d) {return d.cfr>0 ? (d.cfr).toExponential(4):"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 36)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) { return d.pbf>llim ? "Prob":"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) {return d.pbf>llim ? (d.pbf).toExponential(4):"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.condition==1 ? "dimgray": d.etype>0 ? "dimgray" : "lightgray" ;})
.text(function (d) { return d.crt>0 ? "Repair Time": d.etype==1 ? "Exponential": d.etype==2 ? "Weibull":"";});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.condition==1 ? "dimgray": d.etype>0 ? "dimgray" : "lightgray" ;})
.text(function (d) {return d.crt>0 ? (d.crt).toExponential(4):  d.etype==2 ? "B="+parseFloat(d.p1.toFixed(2)) : (d.etype==1 && d.p2>0) ? "exposure" :"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 36)
.attr("text-anchor", "left")
// must have an else for fill condition
.attr("fill",  function(d){return d.etype>0 ? "dimgray" : "white" ;})
.text(function (d) {return d.etype==2 ? "TS="+d.p2 : (d.etype==1 && d.p2>0) ? d.p2 :"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "black")
.text(function (d) { return d.type==13 ? "Phf="+parseFloat(d.p1.toFixed(2)) :"";});
nodeEnter.append("text")
.attr("x", function(d) { return d.type==2 ? rectW/2 : rectW/2+10;})
.attr("y", TrectH  + 60)
.attr("text-anchor", function(d) { return d.type==2 ? "middle" : "left";})
.attr("fill", "maroon")
.text(function (d) {
	return d.type==2 ? "T="+parseFloat(d.p2.toFixed(4)) +" Po=" +parseFloat(d.p1.toFixed(5))
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
function autocollapse(d) {
svg.selectAll("g.node").each(function(d) {
if (d.collapse==1) {
click(d);
}
})
}
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
'

############################ tbi HTML string #####################################

HTMLd3script2<-'
var llim=1e-25;
var duration = 200,rectW = 124,rectH = 120,TrectH = 40;
var width_initial = $(window).width()/2-60;
var tree = d3.layout.tree()
.nodeSize([rectW*1.15, rectH*1.2])
.separation(function(a, b) { return (a.parent == b.parent ? 1 : 1.2); });
// the widget must select el, not "#body" as in html
var svg = d3.select("#body").append("svg").attr("width", "100%").attr("height", "100%")
.call(zm = d3.behavior.zoom().scaleExtent([0.05,5]).on("zoom", redraw)).append("g")
.attr("transform", "translate(" + width_initial + "," + 50 + ")");
zm.translate([width_initial, 50]);
root.x0 = 0;
root.y0 = height / 2;
var duration_backup = duration;
duration = 0;
update(root);
autocollapse(root);
duration = duration_backup;
d3.select("#body").style("height", "100%");
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
.attr("y", 11)
.attr("text-anchor", "middle")
.text(function (d) {
return d.label;})
.call(wrap, rectW);
nodeEnter.append("text")
.attr("x", rectW / 2 -144)
.attr("y", TrectH  +14)
.attr("text-anchor", "middle")
.attr("fill", "navy")
.text(function (d) {
return (d.tag=="top" && d.p2>0) ? "Mission Time" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -144)
.attr("y", TrectH  +26)
.attr("text-anchor", "middle")
.attr("fill", "navy")
.text(function (d) {
return (d.tag=="top" && d.p2>0) ? d.p2 : "" ;});
var orGate="m 60,40 l 0,15 m 15,30 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z";
var andGate="m 60,40 l 0,15 m -15,15 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15";
var priorityGate="m 60,40 l 0,15 m -15,15 0,15 30,0 0,-15  a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 m 0,10 30,0";
var inhibitGate="m 60,40 l 0,15 m 0,0 -15,6.340 0,17.3205 15,6.340  15,-6.340 0,-17.3205 z";
var alarmGate="m 60,40 l 0,15 m 15,30 c  -1.4, -10, .6, -22 -15, -30 -15.6, 8, -13.4, 20, -15, 30, 0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 z m -30,0 v5 c0, 0 3, -8 15, -8 10, 0 15, 8 15, 8 v-5";
var voteGate="m 60,40 l 0,15 m 15,30 c  -1.4,-10,.6,-22-15,-30  -15.6,8,-13.4,20,-15,30 m 0,0 0,10 30,0 0,-10 m-28,-7.5 27,0";
var house="m 60,40 l 0,15 m -15,15 0,15 30,0 0,-15 -15,-15  -15,15";
var undeveloped="m 60,40 l 0,15 m 0,0 l 24,15 l -24,15 l -24,-15 z";
var component="m 60,40 l 0,15 m 15,15 a15,15 .2 0,0 -15,-15 a15,15 .2 0,0 -15,15 a15,15 .2 0,0 15,15 a15,15 .2 0,0 15,-15";
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
case 14 : return(priorityGate);
break;
case 15 : return(voteGate);
break;
case 16 : return(voteGate);
break;
case 9 : return(house);
break;
case 6 : return(undeveloped);
break;
case 3 : return(undeveloped);
break;
default : return(component);
}})
.attr({stroke:"black",
"stroke-width":1,
"stroke-linejoin":"round",
fill: "#fff"});
nodeEnter.append("text")
.attr("x", rectW / 2-2)
.attr("y", TrectH  + 30)
.attr("text-anchor", "middle")
.attr("fill",  function(d){return d.moe==0 ? "red": "magenta";})
.text(function (d) {
return d.moe>0 ? d.moe : d.id ;});
nodeEnter.append("text")
.attr("x", rectW / 2-2)
.attr("y", TrectH  + 45)
.attr("text-anchor", "middle")
.attr("fill", "blue")
.text(function (d) {
return d.type>14 && d.p2>0 ? parseInt(d.p1)+" :"+parseInt(d.p2) : d.type==16 ? parseInt(d.p1)+" :" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -56)
.attr("y", TrectH  -45)
.attr("text-anchor", "middle")
.attr("fill", "magenta")
.text(function (d) {
return d.moe > 0 ? "R" : d.moe<0 ? "S" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 -31)
.attr("y", TrectH  -45)
.attr("text-anchor", "right")
.attr("fill", "navy")
.text(function (d) {
return d.condition > 0 ? "Cond" : "" ;});
nodeEnter.append("text")
.attr("x", rectW / 2 +3)
.attr("y", TrectH  -45)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.moe==0 ? "red": "magenta";})
.text(function (d) {
return d.tag;});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) { return d.cfr>0&&d.condition==0 ? "Fail Rate":"";});
.text(function (d) { return d.cfr>0 ? "Fail Rate":"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
.attr("fill", "green")
//.text(function (d) {return d.cfr>0&&d.condition==0 ? (d.cfr).toExponential(4):"";});
.text(function (d) {return d.cfr>0 ? (d.cfr).toExponential(4):"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 36)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) { return d.pbf>llim ? "Prob":"";});
nodeEnter.append("text")
.attr("x", rectW/2+19)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "navy")
.text(function (d) {return d.pbf>llim ? (d.pbf).toExponential(4):"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 12)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.condition==1 ? "dimgray":"lightgray" ;})
.text(function (d) { return d.crt>0 ? "Repair Time": d.etype==1 ? "Exponential": d.etype==2 ? "Weibull":"";});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 24)
.attr("text-anchor", "left")
.attr("fill",  function(d){return d.condition==1 ? "dimgray":"lightgray" ;})
.text(function (d) {return d.crt>0 ? (d.crt).toExponential(4):  d.etype==2 ? "B="+parseFloat(d.p1.toFixed(2)) : (d.etype==1 && d.p2>0) ? "exposure" :"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 36)
.attr("text-anchor", "left")
// must have an else for fill condition
.attr("fill",  function(d){return d.etype>0 ? "dimgray" : "white" ;})
.text(function (d) {return d.etype==2 ? "TS="+d.p2 : (d.etype==1 && d.p2>0) ? d.p2 :"" ;});
nodeEnter.append("text")
.attr("x", -4)
.attr("y", TrectH  + 48)
.attr("text-anchor", "left")
.attr("fill", "black")
.text(function (d) { return d.type==13 ? "Phf="+parseFloat(d.p1.toFixed(2)) :"";});
nodeEnter.append("text")
.attr("x", function(d) { return d.type==2 ? rectW/2 : rectW/2+10;})
.attr("y", TrectH  + 60)
.attr("text-anchor", function(d) { return d.type==2 ? "middle" : "left";})
.attr("fill", "maroon")
.text(function (d) {
return d.type==2 ? "T="+parseFloat(d.p2.toFixed(4)) +" Po=" +parseFloat(d.p1.toFixed(5))
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
function autocollapse(d) {
svg.selectAll("g.node").each(function(d) {
if (d.collapse==1) {
click(d);
}
})
}
function redraw() {
svg.attr("transform",
"translate(" + d3.event.translate + ")"
+ " scale(" + d3.event.scale + ")");}
function elbow(d) {
var sourceY = d.source.y+TrectH,
sourceX = d.source.x+rectW/2-2,
targetY = d.target.y+TrectH,
targetX = d.target.x+rectW/2-2;
return "M" + sourceX + "," + sourceY
+ "V" + (sourceY+targetY)/2
+ "H" + targetX
+ "V" + targetY;}
function wrap(text, width) {
text.each(function () {
var label = d3.select(this).text();
while (true) {
var words = label.split(/\\s+/).reverse(),
word,
line = [],
lineNumber = 0,
lineHeight = 1.2, // ems
x = d3.select(this).attr("x"),
y = d3.select(this).attr("y"),
dy = d3.select(this).attr("dy") ? d3.select(this).attr("dy") : 0;
tspan = d3.select(this).text(null).append("tspan").attr("x", x).attr("y", y).attr("dy", dy + "em");
while (word = words.pop()) {
line.push(word);
tspan.text(line.join(" "));
if (tspan.node().getComputedTextLength() > width) {
line.pop();
tspan.text(line.join(" "));
line = [word];
tspan = d3.select(this).append("tspan").attr("x", x).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
}
}
if (lineNumber > 2)
width += 20;
else
break;
}
});
}
'