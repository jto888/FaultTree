## readSCRAMprobability.R
# Copyright 2017 OpenReliability.org
#
# A line-by-line parser of the output file from SCRAM probabiilty analysis
#  http://scram-pra.org/ returning a scalar vector holding the single output value.
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

readSCRAMprobability<-function(x, dir="")  {

	fileName<-paste0(dir,x)
## check that fileName provided is indeed for probability and indeed exists

	conn <- file(fileName,open="r")
	on.exit(close(conn))

	prod<-NULL
	be_vector<-NULL
	scram_cs_list<-list(NULL)
	scram_prob_list<-list(NULL)




	while ( TRUE ) {
		linn = readLines(conn, n = 1)
		if ( length(linn) == 0 ) {
			break
		}

		t2<-length(grep("<product order*",linn[1]))>0
		t3<-length(grep("<basic-event name*",linn[1]))>0
		t5<-length(grep("</results",linn[1]))>0

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
## We are done reading this line so get next line
			next
		}

## line handlers based on grep tests

		if(t2)  {

			prod<-c(prod,getProd(linn[1]))

			if(!is.null(be_vector) ) {
## encountering this node with a be_vector signifies the end of a previous collection of basic-event names
## so those need to be handled now, by adding to the appropriate list for this cut set order

				product_order<-length(be_vector)

				if(length(scram_cs_list)<product_order)  {
					scram_cs_list[[product_order]]<-t(as.matrix(be_vector))
				}else{
					if(is.null(scram_cs_list[[product_order]]))  {
						scram_cs_list[[product_order]]<-t(as.matrix(be_vector))
					}else{
						scram_cs_list[[product_order]]<-rbind(scram_cs_list[[product_order]],t(as.matrix(be_vector)))
					}
				}

				if(length(scram_prob_list)<product_order)  {
					scram_prob_list[[product_order]]<-prod[length(prod)-1]
				}else{
					if(is.null(scram_prob_list[[product_order]]))  {
						scram_prob_list[[product_order]]<-prod[length(prod)-1]
					}else{
						scram_prob_list[[product_order]]<-c(scram_prob_list[[product_order]],prod[length(prod)-1])
					}
				}

			}

			be_vector<-NULL
# closure of product order handler
		}

		if(t3) {
## build the be_vector for later processing into scram_cs_lists
			in_string<-as.character(linn[1])
			first<- regexpr('=', linn[1])+2
			last<-nchar(linn[1])-3
			be = substr(in_string, first, last)

			if(is.null(be_vector)) {
				be_vector<-be
			}else{
				be_vector<-c(be_vector, be)
			}
		}

		if(t5) {
## encountering this node signifies the end of a previous collection of basic-event names
## so those need to be handled now, by adding to the appropriate list for last product_order with checking
			product_order<-length(be_vector)
			if(length(scram_cs_list)<product_order)  {
				scram_cs_list[[product_order]]<-t(as.matrix(be_vector))
			}else{
				if(is.null(scram_cs_list[[product_order]]))  {
					scram_cs_list[[product_order]]<-t(as.matrix(be_vector))
				}else{
					scram_cs_list[[product_order]]<-rbind(scram_cs_list[[product_order]],t(as.matrix(be_vector)))
				}
			}
## note this is now placing the last entry in the prod vector into the list

			if(length(scram_prob_list)<product_order)  {
				scram_prob_list[[product_order]]<-prod[length(prod)]
			}else{
				if(is.null(scram_prob_list[[product_order]]))  {
					scram_prob_list[[product_order]]<-prod[length(prod)]
				}else{
					scram_prob_list[[product_order]]<-c(scram_prob_list[[product_order]],prod[length(prod)])
				}
			}

		break
		}

## closure of the line reading loop
	}




	outDF<-NULL
	pad_mat<-NULL

	max_order<-length(scram_cs_list)

	DFnames<-NULL
	for(DFnm in 1:max_order)  {
		DFnames<-c(DFnames, paste0("X", DFnm))
	}
	DFnames<-c(DFnames, "prob")

for(list_order in max_order:1)  {


		if(!is.null(scram_cs_list[[list_order]]))  {
		
## sort each row, preserving the order of collected rows so they match the scram_prob_list entries
			if(list_order>1 && nrow(scram_cs_list[[list_order]]) > 1)  {
			scram_cs_list[[list_order]]<-t(apply(scram_cs_list[[list_order]],1,sort))
			}
			
			padding<-max_order-list_order


			if(padding > 0 )  {
				pad_mat<-matrix(nrow=nrow(scram_cs_list[[list_order]]), ncol=padding)

				temp_DF<-data.frame(scram_cs_list[[list_order]], pad_mat, scram_prob_list[list_order])

			}else{
				temp_DF<-data.frame(scram_cs_list[[list_order]], scram_prob_list[list_order])

			}


			names(temp_DF)<-DFnames

		}

		outDF<-rbind(temp_DF, outDF)
## Must eliminate value in temp_DF, else it will still exist when the next lower list_order is NULL
		temp_DF<-NULL
	}
	
	x<-outDF
	cs_cols<-seq(1:(dim(x)[2]-1))
	col_arg<-paste0("-x[,",dim(x)[2], "],")
	for(col in cs_cols)  {
		col_arg<-paste0(col_arg, paste0("x[,",col,"],"))
	}
	sort_string<-paste0("x[order(", col_arg, "na.last=F,decreasing=F),]" )
	outDF<-eval(parse(text=sort_string))
	row.names(outDF)<-as.character(1:length(outDF[,1])) 
	
	outlist<-list(probability=as.numeric(pb_string), cutsets_prob=outDF)
## not sure why this line was duplicated
##	outlist<-list(probability=as.numeric(pb_string), cutsets_prob=outDF)

outlist
}


	getProd<-function(in_line) {
				in_string<-as.character(in_line)
				first<- regexpr('probability=', in_line)+13
				last<-regexpr('contribution=', in_line)-3
				prod_strg <-substr(in_string, first, last)

				prod_val<-as.numeric(prod_strg)

	}



