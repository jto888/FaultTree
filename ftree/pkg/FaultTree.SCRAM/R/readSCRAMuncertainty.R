## readSCRAMuncertainty.R
# Copyright 2017 OpenReliability.org
#
# A line-by-line parser of the output files from importance analysis
# from SCRAM http://scram-pra.org/ returning a dataframe containing five
# importance measures for each basic-event tag.
# 
# This source file over-writes FaultTree::sort.by.cols, which was never exported
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##

readSCRAMuncertainty<-function(x, dir="", show=c(FALSE, FALSE))  {

	fileName<-paste0(dir,x)
	obj_name<-substr(x, 1,nchar(x)-22)

	
## check that fileName provided is indeed for cutsets and indeed exists	
	
	conn <- file(fileName,open="r")
	on.exit(close(conn))
	
	quant<-FALSE
	qDF<-NULL
	histo<-FALSE
	hDF<-NULL
	

## intended for use with line by line feeding	
##	i=1
	while ( TRUE ) {
		linn = readLines(conn, n = 1)
		if ( length(linn) == 0 ) {
			break
		}
		
		test_line<-length(grep("<sum-of-products*",linn[1]))>0
		if(test_line) {
			in_string<-as.character(linn[1])
			first<- regexpr('probability=', linn[1])+13
## With SCRAM version >11.6 there was an addition of 'distribution' after 'probability' in this line
			if((nchar(linn[1])-2)>(first+13)) {
				last<-regexpr('distribution', linn[1])-3
			}else{
				last<-nchar(linn[1])-2
			}
			pb_string = substr(in_string, first, last)
## We are done reading the probability so proceed with the line reading loop
			next
		}
		
## second s in grep regex signifies start, if not present <quantile* would be accepted		
		t_quan<-length(grep("<quantiless*",linn[1]))>0
		if(t_quan) {
			quant<-TRUE
## get another line, because we are done with this one			 
			next
		}
		
		t_hist<-length(grep("<histogram*",linn[1]))>0
		if(t_hist) {
			histo<-TRUE
## get another line, because we are done with this one			 
			next
		}		
		
		if(quant) {
		t_end<-length(grep("</quantiles>",linn[1]))>0
			if(t_end) {
				quant<-FALSE
				next
			}else{
			DFline<-getDFline(linn[1])
			qDF<-rbind(qDF,DFline)			
			}
		} 
		
		if(histo) {
		t_end<-length(grep("</histogram>",linn[1]))>0
			if(t_end) {
				break
			}else{
			DFline<-getDFline(linn[1])
			hDF<-rbind(hDF,DFline)			
			}
		}		
		
	}
	
	probability<-as.numeric(pb_string)

	if(show[1] && show[2]) {
## set the graphic device for double plot output	
## order of numbers in first arg to matrix determines order top to bottom of plots	
## additional values represent relative width and height of graphic panes	
		layout(matrix(c(1,2),2,1, byrow=TRUE))
		layout.show(n=2)
	}	
		
	if(show[1]) {	
		unc_l<-hDF[,c(1,3,2)]
		names(unc_l)<-c("n","x","y")
		unc_h<-hDF[,c(1,4,2)]
		names(unc_h)<-c("n","x","y")
		unc_hist<-rbind(unc_l, unc_h)
		unc_hist<-sort.by.cols(unc_hist)

		plot(
		range(unc_hist$x), c(0, max(unc_hist$y)*1.1),
		 type='n', 
		xlab="Probability of Top Event",
		ylab="Count Fraction", 
		 yaxt="s",
		main=paste0(obj_name," uncertainty")
		)
				
		x.poly<-c(unc_hist$x, max(unc_hist$x), min(unc_hist$x))
		y.poly<-c(unc_hist$y,0,0)
		polygon(x.poly, y.poly, col="lightblue", border=NA)
		abline(v=probability, col="red")
		mtext(paste0("  ",probability),1, at=probability, adj=0, col="red")		
## supress bin lines beyond 50 bins
		if(nrow(hDF)<51) {
			abline(v=unc_h$x, col="white")
## redraw the plot border that the vlines over wrote		
			box(lty = 'solid', col = 'black')			
		}
	}	
	
	if(show[2]) {	
		
		title<-paste0(obj_name," uncertainty")
		if(show[1] && show[2]) {title<-""}
		
		plot(
		qDF$lower, qDF$value, 
		xlim=c(min(hDF$lower), max(hDF$upper)),
		 type='n', 
		xlab="Probability of Top Event",
		ylab="Quantile", 
		main=title
		)
		
		lines(smooth.spline(qDF$upper, qDF$value, spar=0.5), col="blue")
		lines(smooth.spline(qDF$lower, qDF$value, spar=0.5), col="blue")
		abline(v=probability, col="red")
		if(show[1] && show[2]) {
		text(probability,.1,labels="Point Estimate", pos=4, col="red")
		}else{
		text(probability,.05,labels="Point Estimate", pos=4, col="red")		
		}
		mtext(paste0("  ",probability),1, at=probability, adj=0, col="red")
		##mtext(paste0(probability),1, col="red")
	}	

	
	if(show[1] && show[2]) {
## reset the graphics device for single output
	par(mfrow=c(1,1))	
	}
	
	outList<-list(probability=probability, quantiles=qDF, histogram=hDF)
##	outList<-list(probability,qDF, hDF)
	outList
}	

	
getDFline<-function(in_line) {	
	in_string<-as.character(in_line)
	f_num<-regexpr('number=', in_line)+8

	val<-regexpr('value=', in_line)
	low<-regexpr('lower-bound=', in_line)
	upp<-regexpr('upper-bound=', in_line)

	f_val<-val+7
	f_low<-low+13
	f_upp<-upp+13
	
	l_num<-val-3
	l_val<-low-3
	l_low<-upp-3

	l_upp<-nchar(in_string)-3

	num_s <- substr(in_string, f_num, l_num)
	value<-as.numeric(substr(in_string, f_val, l_val))
	lower<-as.numeric(substr(in_string, f_low, l_low))
	upper<-as.numeric(substr(in_string, f_upp, l_upp))

	DFline<-data.frame(number=num_s,value,lower,upper)

DFline
}

sort.by.cols<-function(x, cols=NULL, na.last = FALSE, decreasing = FALSE) {

	if(length(dim(x))<2)  {
		stop("must provide a dataframe or matrix with more than one column")
	}

	if(length(cols)==0)  {
		cols<-seq(1:dim(x)[2])
	}


	col_arg<-NULL
	for(col in cols)  {
		col_arg<-paste0(col_arg, paste0("x[,",col,"],"))
	}

sort_string<-paste0("x[order(", col_arg, "na.last=",na.last,",decreasing=",decreasing,"),]" )

	x.sorted<-eval(parse(text=sort_string))
x.sorted
}
