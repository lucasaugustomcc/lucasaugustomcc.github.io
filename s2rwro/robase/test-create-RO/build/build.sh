#!/bin/bash

# @BEGIN setup 			@DESC This script is used to build initial structures for a MD simulation of a protein in water, containing a glucan chain and ions​ 
# @IN structure_pdb		@DESC crystal ​structure​ of the protein @AS initial_structure
# 						@URI file:structure.pdb
# @IN topology_prot 	@DESC ​topology file for protein​s
# 						@URI file:../toppar/top_all22_prot.rtf
# @IN topology_carb  	@DESC topology file for carbohydrates
#						@URI file:../toppar/top_all36_carb.rtf
# @IN topology_pca	 	@DESC ​topology file for ​the non-standard residue PCA
#						@URI file:../toppar/pca.rtf
# @OUT fixed_1 			@DESC coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation​
# 						@URI file:fixed.1.pdb 
#						@AS final_structure_1
# @OUT fixed_2 			@DESC coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation​
# 						@URI file:fixed.2.pdb 
#						@AS final_structure_2

# @BEGIN split @desc the file structure.pdb is split into different parts. Each part represent a subsystem.​ 
# @IN structure_pdb @DESC ​crystal ​structure​ of the protein​ @AS initial_structure
#					@URI file:structure.pdb	
# @OUT protein_pdb 	@DESC coordinates of the protein atoms
#					@URI file:protein.pdb
# @OUT bglc_pdb  	@DESC coordinates of the glucan chain present in the crystal structure
#					@URI file:bglc.pdb
# @OUT water_pdb  	@DESC ​coordinates of water molecules present in the crystal structure
#					@URI file:water.pdb
# @OUT cal_pdb  	@DESC ​coordinates of calcium ions present in the crystal structure
#					@URI file:cal.pdb
grep ATOM structure.pdb > protein.pdb
grep HOH  structure.pdb > water.pdb
grep GLC  structure.pdb > bglc.pdb
grep CAL  structure.pdb > cal.pdb
# @END split

# @BEGIN psfgen @desc Starting the program psfgen​. This program takes the 4 files above, and assign force field parameters (charges, bonds etc) for the system. 
# @IN topology_prot 	@DESC ​topology file for protein​s
# 						@URI file:../toppar/top_all22_prot.rtf
# @IN topology_carb  	@DESC topology file for carbohydrates
#						@URI file:../toppar/top_all36_carb.rtf
# @IN topology_pca	 	@DESC ​topology file for ​the non-standard residue PCA
#						@URI file:../toppar/pca.rtf
# @IN protein_pdb 		@DESC coordinates of the protein atoms
#						@URI file:protein.pdb
# @IN bglc_pdb  		@DESC coordinates of the glucan chain present in the crystal structure
#						@URI file:bglc.pdb
# @IN water_pdb  		@DESC ​coordinates of water molecules present in the crystal structure
#						@URI file:water.pdb
# @IN cal_pdb  			@DESC ​coordinates of calcium ions present in the crystal structure
#						@URI file:cal.pdb
# @OUT hyd_pdb 			@DESC ​crystal structure with hydrogen atoms added​
#						@URI file:hyd.pdb
# @OUT hyd_psf			@DESC structure file for the crystal structure with hydrogen atoms added
#						@URI file:hyd.psf
psfgen << ENDMOL

# Read topology file
topology ../toppar/top_all22_prot.rtf
topology ../toppar/pca.rtf
topology ../toppar/top_all36_carb.rtf

# Build protein segment
pdbalias atom ILE CD1 CD
pdbalias residue HIS HSP
segment CBH1 { 
  first none
  pdb protein.pdb
  mutate 251 ALA
}
patch GLUP CBH1:119
patch ASPP CBH1:214
patch GLUP CBH1:217
patch GLUP CBH1:223
patch GLUP CBH1:334
patch ASPP CBH1:368
patch ASPP CBH1:378
patch DISU CBH1:138 CBH1:397
patch DISU CBH1:261 CBH1:331
patch DISU CBH1:25  CBH1:19
patch DISU CBH1:172 CBH1:210
patch DISU CBH1:230 CBH1:256
patch DISU CBH1:176 CBH1:209
patch DISU CBH1:238 CBH1:243
patch DISU CBH1:4   CBH1:72
patch DISU CBH1:67  CBH1:61
patch DISU CBH1:50  CBH1:71
regenerate angles dihedrals
coordpdb protein.pdb CBH1

# Build carbohydrate segment
pdbalias residue GLC BGLC
segment BGLC {
  pdb bglc.pdb
}
patch 14bb BGLC:452 BGLC:453
patch 14bb BGLC:453 BGLC:454
patch 14bb BGLC:454 BGLC:455
patch 14bb BGLC:455 BGLC:456
patch 14bb BGLC:456 BGLC:457
patch 14bb BGLC:457 BGLC:458
patch 14bb BGLC:458 BGLC:459
patch 14bb BGLC:459 BGLC:460
regenerate angles dihedrals
coordpdb bglc.pdb BGLC

# Build structural waters segment
pdbalias residue HOH TIP3
pdbalias atom HOH O OH2
segment H2O {
        auto none
        pdb water.pdb}
coordpdb water.pdb H2O

# Build Calcium segment
segment CAL {
  pdb cal.pdb
}
coordpdb cal.pdb CAL

# Guess missing coordinates
guesscoord

# Write structure and coordinate files
writepdb hyd.pdb
writepsf hyd.psf

ENDMOL

rm protein.pdb water.pdb bglc.pdb cal.pdb
# @END psfgen

# @BEGIN solvate 		@DESC Using the program solvate​ ​to imerse the system in a water box.​
# @IN hyd_pdb 			@DESC ​crystal structure with hydrogen atoms added​
#						@URI file:hyd.pdb
# @IN hyd_psf			@DESC structure file for the crystal structure with hydrogen atoms added
#						@URI file:hyd.psf
# @OUT wbox_pdb 		@DESC coordinates of the solvated system​
#						@URI file:wbox.pdb
# @OUT wbox_psf 		@DESC structure file of the solvated system​
#						@URI file:wbox.psf
echo "
package require solvate
solvate hyd.psf hyd.pdb -rotate -t 16 -o wbox
exit
" > solv.tcl

vmd -dispdev text -e solv.tcl
rm solv.tcl
# @END solvate

# @BEGIN ionize 		@DESC  With the program autoionize, introduce ions to neutralize the system.​ 
# @IN wbox_pdb 			@DESC coordinates of the solvated system​
#						@URI file:wbox.pdb
# @IN wbox_psf 			@DESC structure file of the solvated system​
#						@URI file:wbox.psf
# @OUT cbh1_pdb 		@DESC initial coordinates for the simulations, containing protein, water, ions and glucan chain
#						@URI file:cbh1.pdb
# @OUT cbh1_psf 		@DESC ​structure file for the coordinate file cbh1.pdb
#						@URI file:cbh1.psf
# ionic strength = 0.10
echo "
package require autoionize
autoionize -psf wbox.psf -pdb wbox.pdb -nna 21 -ncl 10 -o cbh1
exit
" > ionize.tcl
vmd -dispdev text -e ionize.tcl
rm ionize.tcl wbox* hyd*

# @END ionize

# @BEGIN constraints_definition @DESC We define the atoms that should be kept fixed in the equilibration steps of the MD simulations.​
# @IN cbh1_pdb 					@DESC ​initial coordinates for the simulations, containing protein, water, ions and glucan chain​
#								@URI file:cbh1.pdb
# @IN cbh1_psf 					@DESC ​​structure file for the coordinate file cbh1.pdb
#								@URI file:cbh1.psf
# @OUT fixed_1 					@DESC coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation​
# 								@URI file:fixed.1.pdb
#								@AS final_structure_1 
# @OUT fixed_2 					@DESC coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation​
# 								@URI file:fixed.2.pdb 
#								@AS final_structure_2
echo '
mol new cbh1.psf
mol addfile cbh1.pdb
set all [atomselect top all]
$all set beta 0
set fixed [atomselect top "(protein or segname BGLC) and noh"]
$fixed set beta 500
$all writepdb fixed.1.pdb

set all [atomselect top all]
$all set beta 0
set fixed [atomselect top "protein and name CA"]
$fixed set beta 500
$all writepdb fixed.2.pdb
exit
' > fixed.tcl

vmd -dispdev text -e fixed.tcl
rm fixed.tcl
# @END constraints_definition
# @END setup