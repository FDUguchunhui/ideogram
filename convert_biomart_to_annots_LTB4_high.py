''' Converts gene data from Ensembl Biomart to JSON-formatted annotations'''

import json, random
import math

annots = []

chrs = [
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
	"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
	"21", "22", "X", "Y"
]

file_name = "LTB4_high_expr.csv"
file = open(file_name, "r").readlines()

for chr in chrs:
	annots.append({"chr": chr, "annots": []});

for line in file[1:]:

	columns = line.strip().split(",")

	chr = columns[0]

	if chr not in chrs:
		# E.g. chrMT, alternate loci scaffolds
		continue

	if chr == "X":
		chr = 22
	elif chr == "Y":
		chr = 23
	else:
		chr = int(chr) - 1


	start = int(columns[2])/1.00
	length = int(columns[3])/1.00 - start
	gene_name = columns[1]
	gene_expr = float(columns[4])

	annot = [
		gene_name,
		start,
		length,
        5,
		5,
    ]

	annots[chr]["annots"].append(annot)

top_annots = {}
top_annots["keys"] = ["name", "start", "length", "expression-level", "gene-type"]
top_annots["annots"] = annots
annots = json.dumps(top_annots)

open("data/camilla_LTB4_high.json", "w").write(annots)
