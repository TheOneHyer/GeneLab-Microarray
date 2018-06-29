#!/usr/bin/env Rscript

# install.packages("optparse")
suppressPackageStartupMessages(library("optparse"))

# Read options
option_list=list(
  make_option(c("-i","--input"),type="character",help="Path to file with buried raw array information [required]"),
  make_option(c("-o","--output"),type="character",help="Path and filename for saving extracted data [required]")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

norm = opt$normalization

if (is.null(opt$input)){ # Check and set input file handle
  print_help(opt_parser)
  stop("No path to input file provided. Please look over the available options\n", call. = F)
}else inFH = opt$input

if (is.null(opt$output)){ # Check and set output file handle
  print_help(opt_parser)
  stop("No path to out file provided. Please look over the available options\n", call. = F)
}else outFH = opt$output

cat("Reading in file...")
test = read.delim(inFH, stringsAsFactors = F, header = F) # Read in processed file

cat("Extracting raw values...\n")
G = test[,grep("gMedianSignal",test)] # Idenitfy median foreground intensity columns
cat("-")
R = test[,grep("rMedianSignal",test)]
cat("-")
Gb = test[,grep("gBGMedianSignal",test)] # Idenitfy median background intensities columns
cat("-")
Rb = test[,grep("rBGMedianSignal",test)]
cat("-")
startInd = grep("gMedianSignal",G) + 1 # Indentify starting row index of raw values
cat("-")
G = G[startInd:length(G)] # Extract raw values
cat("-")
R = R[startInd:length(R)]
cat("-")
Gb = Gb[startInd:length(Gb)]
cat("-")
Rb = Rb[startInd:length(Rb)]
cat("-")
raw = cbind(R,G,Rb,Gb) # Bind raw value vectors into dataframe
cat("-")
row.names(raw) = test[startInd:nrow(test),grep("FeatureNum", test)] # Add unique feature numbers for mapping to genes
cat("-\n")

write.table(raw,file = outFH,sep="\t",quote = F)
cat("Success! Raw values saved to:",outFH)